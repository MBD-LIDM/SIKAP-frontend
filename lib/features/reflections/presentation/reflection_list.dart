import 'package:flutter/material.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/features/scenarios/data/scenario_repository.dart';

class ReflectionListPage extends StatefulWidget {
  const ReflectionListPage({
    super.key,
    required this.scenarioTitle,
    required this.scenarioDescription,
    required this.question,
    this.scenarioId,
  });

  final String scenarioTitle;
  final String scenarioDescription;
  final String question;
  final int?
      scenarioId; // optional backend scenario id to fetch real reflections

  @override
  State<ReflectionListPage> createState() => _ReflectionListPageState();
}

class _ReflectionListPageState extends State<ReflectionListPage> {
  String _sort = 'Terbaru';

  // Placeholder data. Will be replaced by API data when scenarioId is provided.
  List<_ReflectionItem> _reflections = [
    _ReflectionItem(
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        text:
            'Saya belajar untuk minta bantuan wali kelas saat melihat teman dibully.'),
    _ReflectionItem(
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        text:
            'Saat sedih, saya mencoba bernapas dalam dan bicara ke orang tua.'),
    _ReflectionItem(
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        text:
            'Saya akan melapor dengan aman dan tidak menghadapi sendiri pelaku.'),
  ];
  bool _loadingRemote = false;

  List<_ReflectionItem> get _sortedList {
    final list = [..._reflections];
    list.sort((a, b) => _sort == 'Terbaru'
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Refleksi Siswa'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF7F55B1),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.scenarioTitle,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(
                            'Deskripsi Skenario: ${widget.scenarioDescription}',
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text('Pertanyaan yang diberikan: ${widget.question}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2)),
                                ]),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _sort,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'Terbaru', child: Text('Terbaru')),
                                  DropdownMenuItem(
                                      value: 'Terlama', child: Text('Terlama')),
                                ],
                                onChanged: (v) =>
                                    setState(() => _sort = v ?? 'Terbaru'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _sortedList.length,
                      itemBuilder: (context, index) {
                        final item = _sortedList[index];
                        return _ReflectionCard(item: item);
                      },
                    ),
                  ),
                ],
              ),
              if (_loadingRemote)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRemote();
  }

  Future<void> _loadRemote() async {
    setState(() => _loadingRemote = true);
    try {
      final session = SessionService();
      final api = ApiClient();
      int? staffSchoolId;

      // Check if user is staff (counselor/teacher) or guest (student)
      final isStaff = await session.isStaffLoggedIn();
      print('[REFLECTION_LIST] Loading reflections - isStaff: $isStaff');
      
      // Create AuthHeaderProvider with correct auth based on user type
      final auth = AuthHeaderProvider(
        loadUserToken: isStaff 
            ? () async => await session.loadUserToken()
            : () async => null,
        loadGuestToken: isStaff 
            ? () async => null
            : () async => await session.loadGuestToken(),
        loadGuestId: isStaff 
            ? () async => null
            : () async => await session.loadGuestId(),
        loadCsrfToken: isStaff 
            ? () async => await session.loadCsrfToken()
            : () async => null,
      );
      
      if (isStaff) {
        final userId = await session.loadUserId();
        final schoolId = await session.loadUserSchoolId();
        final role = await session.loadUserRole();
        print('[REFLECTION_LIST] Staff context - userId: $userId, schoolId: $schoolId, role: $role');
        
        if (schoolId == null) {
          print('[REFLECTION_LIST] ⚠️ WARNING: Staff schoolId is NULL!');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Akun guru tidak memiliki school_id. Hubungi admin.')),
            );
            setState(() => _loadingRemote = false);
          }
          return;
        }
        staffSchoolId = schoolId;
      } else {
        final guestId = await session.loadGuestId();
        print('[REFLECTION_LIST] Guest context - guestId: $guestId');
      }
      
      final repo =
          ScenarioRepository(apiClient: api, auth: auth, session: session);
      print('[REFLECTION_LIST] Fetching reflections for scenarioId: ${widget.scenarioId}');

      List<dynamic> data;
      if (isStaff) {
        data = await repo.getSchoolReflections(
          scenarioId: widget.scenarioId?.toString(),
          staffSchoolId: staffSchoolId,
        );
      } else {
        data = await repo.getMyReflections(asGuest: true);
        if (widget.scenarioId != null) {
          data = data.where((item) {
            if (item is Map && item['scenario_id'] != null) {
              final sid = item['scenario_id'];
              return sid.toString() == widget.scenarioId.toString();
            }
            return false;
          }).toList();
        }
      }

      print('[REFLECTION_LIST] Received ${data.length} reflection(s) from API');

      DateTime? _parseDate(dynamic v) {
        if (v is DateTime) return v;
        if (v is String) return DateTime.tryParse(v.trim());
        return null;
      }

      final List<_ReflectionItem> parsed = [];
      for (final e in data) {
        try {
          final Map<String, dynamic> m =
              (e is Map) ? Map<String, dynamic>.from(e) : <String, dynamic>{};
          if (m.isEmpty) {
            // ignore: avoid_print
            print('[REFLECTION_LIST] Skipping non-map reflection item: $e');
            continue;
          }

          final refl = m['reflection'];

          // 1) Cari tanggal dari beberapa kandidat field (top-level lalu di dalam reflection)
          DateTime? created;
          for (final key
              in ['created_at', 'created', 'submitted_at', 'timestamp']) {
            final v = m[key];
            if (v != null) {
              created = _parseDate(v);
              if (created != null) break;
            }
          }
          if (created == null && refl is Map) {
            for (final key
                in ['created_at', 'created', 'submitted_at', 'timestamp']) {
              final v = refl[key];
              if (v != null) {
                created = _parseDate(v);
                if (created != null) break;
              }
            }
          }

          // 2) Ambil teks refleksi dari beberapa kemungkinan sumber
          String text = '';
          if (refl is String) {
            text = refl;
          } else if (refl is Map && refl['jawaban'] is String) {
            // Bentuk umum: { jawaban, jenjang, timestamp, scenario_id, ... }
            text = refl['jawaban'] as String;
          } else if (refl is Map && refl['text'] is String) {
            text = refl['text'] as String;
          } else if (m['jawaban'] is String) {
            text = m['jawaban'] as String;
          } else if (m['text'] is String) {
            text = m['text'] as String;
          } else if (m['answer'] is String) {
            text = m['answer'] as String;
          } else if (m['content'] is String) {
            text = m['content'] as String;
          }

          text = text.trim();

          if (created == null || text.isEmpty) {
            // ignore: avoid_print
            print(
                '[REFLECTION_LIST] Skipping invalid item (date/text missing). Keys: ${m.keys.toList()}');
            continue;
          }

          parsed.add(_ReflectionItem(createdAt: created, text: text));
        } catch (err, st) {
          // ignore: avoid_print
          print(
              '[REFLECTION_LIST] Error parsing reflection item: $err\n$st');
          // skip invalid item
        }
      }

      print('[REFLECTION_LIST] Parsed ${parsed.length} valid reflection(s)');

      if (parsed.isNotEmpty) {
        setState(() => _reflections = parsed);
      } else {
        print('[REFLECTION_LIST] ⚠️ No reflections parsed from API response');
        if (mounted && data.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Format data refleksi tidak dikenali. Silakan hubungi admin.'),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('[REFLECTION_LIST] ❌ Failed to load remote reflections: $e');
      print('[REFLECTION_LIST] Stack trace: $stackTrace');
    } finally {
      setState(() => _loadingRemote = false);
    }
  }
}

class _ReflectionItem {
  _ReflectionItem({required this.createdAt, required this.text});
  final DateTime createdAt;
  final String text;
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({required this.item});
  final _ReflectionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jawaban :',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.text,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Timestamp :',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(item.createdAt),
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }
}
