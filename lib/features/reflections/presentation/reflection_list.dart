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
  String _scenarioFilterValue = 'all'; // 'all' or scenario_id as string
  Map<int, String> _scenarioIdToTitle = {}; // {101: 'Hilangnya Kotak Pensil Teman', ...}

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
      backgroundColor: const Color(0xFF7F55B1),
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
              SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
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
                                  isExpanded: true,
                                  value: _scenarioFilterValue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  items: [
                                    const DropdownMenuItem(
                                      value: 'all',
                                      child: Text('Semua Skenario',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1),
                                    ),
                                    ..._scenarioIdToTitle.entries.map(
                                      (e) => DropdownMenuItem(
                                        value: e.key.toString(),
                                        child: Text(
                                          '${e.key} - ${e.value}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      _scenarioFilterValue = v ?? 'all';
                                    });
                                    _loadRemote();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
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
                                  isExpanded: true,
                                  value: _sort,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Terbaru',
                                      child: Row(
                                        children: [
                                          Icon(Icons.sort, size: 18),
                                          SizedBox(width: 8),
                                          Text('Terbaru'),
                                        ],
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Terlama',
                                      child: Row(
                                        children: [
                                          Icon(Icons.sort, size: 18),
                                          SizedBox(width: 8),
                                          Text('Terlama'),
                                        ],
                                      ),
                                    ),
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
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _sortedList.length,
                      itemBuilder: (context, index) {
                        final item = _sortedList[index];
                        return _ReflectionCard(item: item);
                      },
                    ),
                  ],
                ),
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
    // Preselect scenario filter if page is invoked with a specific scenarioId
    if (widget.scenarioId != null) {
      _scenarioFilterValue = widget.scenarioId!.toString();
    }
    _loadScenarioOptions();
    _loadRemote();
  }

  Future<void> _loadScenarioOptions() async {
    try {
      final repo = ScenarioRepository();
      final list = await repo.loadScenarios();
      // Map remoteId -> title
      final map = <int, String>{};
      for (final s in list) {
        if (s.remoteId != null) {
          map[s.remoteId!] = s.title;
        }
      }
      if (mounted) {
        setState(() {
          _scenarioIdToTitle = map;
        });
      }
    } catch (_) {
      // ignore mapping errors, filter will just show "Semua Skenario"
    }
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
      
      final repo = ScenarioRepository(apiClient: api, auth: auth, session: session);
      final selectedScenarioId =
          _scenarioFilterValue != 'all' ? _scenarioFilterValue : null;
      print('[REFLECTION_LIST] Fetching reflections for scenarioId: $selectedScenarioId');

      List<dynamic> data;
      if (isStaff) {
        data = await repo.getSchoolReflections(
          scenarioId: selectedScenarioId,
          staffSchoolId: staffSchoolId,
        );
      } else {
        data = await repo.getMyReflections(asGuest: true);
        if (selectedScenarioId != null) {
          data = data.where((item) {
            if (item is Map && item['scenario_id'] != null) {
              final sid = item['scenario_id'];
              return sid.toString() == selectedScenarioId;
            }
            if (item is Map && item['reflection'] is Map) {
              final inner = item['reflection'] as Map;
              final sid = inner['scenario_id'];
              if (sid != null) {
                return sid.toString() == selectedScenarioId;
              }
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
              (e is Map) ? Map<String, dynamic>.from(e) : {};

          final created = _parseCreatedAt(m);
          final text = _extractReflectionText(m);

          if (created != null && text.isNotEmpty) {
            parsed.add(_ReflectionItem(createdAt: created, text: text));
          }
        } catch (_) {
          // skip invalid item
        }
      }

      print('[REFLECTION_LIST] Parsed ${parsed.length} valid reflection(s)');
      setState(() => _reflections = parsed);
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
    // Convert to local time and format like: 6 Agustus 2025 10:30
    final local = dt.toLocal();
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    final day = local.day;
    final monthName = months[local.month - 1];
    final year = local.year;
    final time = '${two(local.hour)}:${two(local.minute)}';
    return '$day $monthName $year $time';
  }
}

// --------------------------- Helpers ---------------------------

DateTime? _parseCreatedAt(Map<String, dynamic> m) {
  final candidates = [
    m['created_at'],
    m['createdAt'],
    m['timestamp'],
    // Sometimes nested under "reflection"
    (m['reflection'] is Map) ? (m['reflection'] as Map)['timestamp'] : null,
  ];
  for (final v in candidates) {
    if (v is String) {
      final parsed = DateTime.tryParse(v);
      if (parsed != null) return parsed;
    }
  }
  return null;
}

String _extractReflectionText(Map<String, dynamic> m) {
  // 1) Top-level keys
  for (final key in ['jawaban', 'text', 'answer']) {
    final v = m[key];
    if (v is String && v.trim().isNotEmpty) return v.trim();
  }
  // 2) Nested under "reflection"
  final r = m['reflection'];
  if (r is String && r.trim().isNotEmpty) return r.trim();
  if (r is Map) {
    for (final key in ['jawaban', 'text', 'answer']) {
      final v = r[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
  }
  return '';
}
