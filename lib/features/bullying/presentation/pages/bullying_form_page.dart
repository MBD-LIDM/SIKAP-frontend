import 'package:flutter/material.dart';
import 'package:sikap/features/bullying/data/repositories/bullying_repository.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/auth/session_service.dart';

class BullyingFormPage extends StatefulWidget {
  final String? bullyingId; // null for create, not null for edit
  const BullyingFormPage({super.key, this.bullyingId});

  @override
  State<BullyingFormPage> createState() => _BullyingFormPageState();
}

class _BullyingFormPageState extends State<BullyingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  final _session = SessionService();
  final _api = ApiClient();

  String _selectedType = 'verbal';
  String _selectedSeverity = 'medium';
  bool _isLoading = false;

  // Incident types dari BE: [{incident_type_id, type_name}, ...]
  List<Map<String, dynamic>> _incidentTypes = [];
  int? _incidentTypeId; // hasil mapping dari _selectedType → incident_type_id

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // pastikan guest session ada, lalu load incident types
    await _session.ensureGuest();
    if (!mounted) return;
    await _loadIncidentTypes();
  }

  Future<void> _loadIncidentTypes() async {
    try {
      // Jika endpoint ini butuh guest, pastikan ApiClient/Interceptor menambah X-Guest-Token.
      // Response pakai envelope: { success, message, data: [...] }
      final res = await _api.get<Map<String, dynamic>>(
        "/api/bullying/incident-types/",
        transform: (raw) => raw as Map<String, dynamic>,
      );

      final list = (res.data["data"] as List).cast<Map<String, dynamic>>();
      setState(() {
        _incidentTypes = list;

        // mapping default dari selected type (verbal) → incident_type_id
        final match = _incidentTypes.firstWhere(
          (e) => (e["type_name"] as String).toLowerCase() == _selectedType,
          orElse: () => _incidentTypes.first,
        );
        _incidentTypeId = (match["incident_type_id"] as num).toInt();
      });
    } catch (e, st) {
      // Jangan blok UI, tapi beri log
      // ignore: avoid_print
      print("[ERROR] load incident types: $e");
      print(st);
    }
  }

  Future<void> _submitForm() async {
    // ignore: avoid_print
    print("[DEBUG] Submit pressed");
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form tidak valid. Lengkapi semua field wajib."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_incidentTypeId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jenis insiden belum siap. Coba lagi sebentar..."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final guestToken = await _session.loadGuestToken();
    final guestId = await _session.loadGuestId();
    if (guestToken == null || guestId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sesi tamu belum tersedia. Sedang mencoba quick-login..."),
          backgroundColor: Colors.orange,
        ),
      );
      final ok = await _session.ensureGuest();
      if (!ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal membuat sesi tamu. Coba lagi."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    final repo = BullyingRepository(
      apiClient: _api,
      auth: AuthHeaderProvider(
        // Pastikan AuthHeaderProvider menambahkan X-Guest-Token saat asGuest=true.
        loadUserToken: () async => null,
        loadGuestToken: () async => _session.loadGuestToken(),
      ),
    );

    final data = {
      // Rekomendasi: jika BE sudah derive guest dari token, baris ini bisa dihapus.
      "guest_id": guestId,
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "location": _locationController.text.trim(),
      "incident_type_id": _incidentTypeId,
      "severity": _selectedSeverity,
      "confirm_truth": true,
      // opsional:
      // "target_pseudonym": "",
      // "is_anonymous": false,
    };

    try {
      // ignore: avoid_print
      print("[DEBUG] Sending POST /api/bullying/report/ with data=$data");
      final res = await repo.createBullyingReport(data, asGuest: true);
      // ignore: avoid_print
      print("[DEBUG] Response received: ${res.data}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Laporan berhasil dikirim 🎉"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e, st) {
      // ignore: avoid_print
      print("[ERROR] Failed to submit report: $e");
      print(st);

      // Retry sekali jika 401 dengan ensureGuest
      try {
        final ok = await _session.ensureGuest();
        if (ok) {
          final res2 = await repo.createBullyingReport(data, asGuest: true);
          // ignore: avoid_print
          print("[DEBUG] Response after reauth: ${res2.data}");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Laporan berhasil dikirim 🎉"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
          return;
        }
      } catch (_) {
        // ignore
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim laporan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bullyingId == null ? 'Laporkan Bullying' : 'Edit Laporan'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7F55B1), // Purple
              Color(0xFFFFDBB6), // Light peach
            ],
            stops: [0.76, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Laporan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    if (value.trim().length < 10) {
                      return 'Deskripsi minimal 10 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi Kejadian',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Lokasi minimal 2 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Jenis (mapping ke incident_type_id)
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Bullying',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'verbal', child: Text('Verbal')),
                    DropdownMenuItem(value: 'physical', child: Text('Fisik')),
                    DropdownMenuItem(value: 'cyber', child: Text('Cyber')),
                    DropdownMenuItem(value: 'social', child: Text('Sosial')),
                    DropdownMenuItem(value: 'sexual', child: Text('Seksual')),
                    DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      // sinkronkan id bila list sudah siap
                      final match = _incidentTypes.firstWhere(
                        (e) => (e["type_name"] as String).toLowerCase() == _selectedType,
                        orElse: () => _incidentTypes.isNotEmpty ? _incidentTypes.first : {},
                      );
                      final id = match["incident_type_id"];
                      _incidentTypeId = id is num ? id.toInt() : id as int?;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Severity
                DropdownButtonFormField<String>(
                  value: _selectedSeverity,
                  decoration: const InputDecoration(
                    labelText: 'Tingkat Keparahan',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Rendah')),
                    DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                    DropdownMenuItem(value: 'high', child: Text('Tinggi')),
                    DropdownMenuItem(value: 'critical', child: Text('Kritis')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSeverity = value!;
                    });
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.bullyingId == null ? 'Kirim Laporan' : 'Update Laporan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
