import 'package:flutter/material.dart';
import 'package:sikap/features/bullying/data/repositories/bullying_repository.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart'; // <— penting
import 'package:sikap/core/network/api_exception.dart';

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

  late final AuthHeaderProvider _auth;
  late final BullyingRepository _repo;

  // UI state
  String _selectedSeverity = 'medium';
  bool _isLoading = false;

  // Data incident types dari server: [{id, name, slug}]
  List<Map<String, dynamic>> _incidentTypes = [];
  int? _incidentTypeId;

  @override
  void initState() {
    super.initState();
    _auth = AuthHeaderProvider(
      loadUserToken: () async => null, // guest-only flow
      loadGuestToken: () async => await _session.loadGuestToken(),
    );
    _repo = BullyingRepository(
      apiClient: _api,
      session: _session,
      auth: _auth,
      gate: guestAuthGateInstance(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      // Pastikan sesi tamu ada (akan quick-login bila perlu).
      await ensureGuestAuthenticated();

      // Muat incident types
      await _loadIncidentTypes();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Inisialisasi gagal: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _loadIncidentTypes() async {
    try {
      final headers = await _auth.buildHeaders(asGuest: true);
      final resp = await _api.get<dynamic>(
        "/api/bullying/incident-types/",
        headers: headers,
        transform: (raw) {
          if (raw is List) return raw;
          if (raw is Map && raw['results'] is List) return raw['results'];
          throw const FormatException("Unexpected incident-types shape");
        },
      );

      final list = (resp.data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .map((e) {
            final dynamicId = e['incident_type_id'] ?? e['id'];
            final dynamicName =
                e['type_name'] ?? e['name'] ?? e['type'] ?? 'Unknown';
            final id = (dynamicId is num)
                ? dynamicId.toInt()
                : int.tryParse('$dynamicId');
            final name = '$dynamicName';
            return {
              'id': id,
              'name': name,
              'slug': name.toLowerCase().trim(),
            };
          })
          .where((m) => m['id'] != null)
          .toList();

      int? pickedId;
      if (list.isNotEmpty) {
        pickedId = list.first['id'] as int;
      }

      if (!mounted) return;
      setState(() {
        _incidentTypes = list;
        _incidentTypeId = pickedId;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memuat jenis insiden. Coba lagi."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
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

    // Pastikan sesi tamu tersambung sebelum mengirim laporan.
    var token = await _session.loadGuestToken();
    var guestId = await _session.loadGuestId();

    if ((token == null || token.isEmpty) || guestId == null) {
      try {
        await ensureGuestAuthenticated();
      } catch (_) {
        // Dibiarkan: validasi akan memastikan gid tersedia di bawah.
      }
      token = await _session.loadGuestToken();
      guestId = await _session.loadGuestId();
    }

    if (guestId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sesi tamu hilang. Coba lagi setelah login cepat."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final payload = <String, dynamic>{
      "incident_type_id": _incidentTypeId, // integer id
      "description": _descriptionController.text.trim(), // >= 10 chars
      "location": _locationController.text.trim(), // >= 2 chars
      "severity": _selectedSeverity, // low|medium|high|critical
      "confirm_truth": true,
    };

    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      payload["title"] = title;
    }

    setState(() => _isLoading = true);
    try {
      final res = await _repo.createBullyingReport(payload, asGuest: true);
      // ignore: avoid_print
      print("[DEBUG] createBullyingReport OK: ${res.data}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Laporan berhasil dikirim."),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (e.code == 401) {
        try {
          await ensureGuestAuthenticated();
          final res2 = await _repo.createBullyingReport(payload, asGuest: true);
          // ignore: avoid_print
          print("[DEBUG] createBullyingReport retry OK: ${res2.data}");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Laporan berhasil dikirim."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
          return;
        } catch (_) {
          // Fallthrough ke snackbar umum di bawah.
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Gagal mengirim laporan (${e.code ?? 'ERR'}): ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
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
    final canSubmit = !_isLoading && _incidentTypeId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.bullyingId == null ? 'Laporkan Bullying' : 'Edit Laporan'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7F55B1), Color(0xFFFFDBB6)],
            stops: [0.76, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Judul tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Deskripsi tidak boleh kosong';
                      if (v.trim().length < 10)
                        return 'Deskripsi minimal 10 karakter';
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
                    validator: (v) => (v == null || v.trim().length < 2)
                        ? 'Lokasi minimal 2 karakter'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Dropdown "Jenis Bullying"
                  DropdownButtonFormField<int>(
                    value: _incidentTypeId,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Bullying',
                      border: OutlineInputBorder(),
                    ),
                    items: _incidentTypes.map((m) {
                      return DropdownMenuItem<int>(
                        value: m['id'] as int,
                        child: Text(m['name'] as String),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _incidentTypeId = value),
                    validator: (_) =>
                        _incidentTypeId == null ? 'Pilih jenis bullying' : null,
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
                      DropdownMenuItem(
                          value: 'critical', child: Text('Kritis')),
                    ],
                    onChanged: (v) => setState(() => _selectedSeverity = v!),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: canSubmit ? _submitForm : null,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(widget.bullyingId == null
                            ? 'Kirim Laporan'
                            : 'Update Laporan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
