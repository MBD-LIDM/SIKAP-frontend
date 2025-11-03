import 'package:flutter/material.dart';
import 'package:sikap/features/bullying/presentation/pages/bullying_detail_page.dart';
import 'package:sikap/features/bullying/presentation/pages/bullying_form_page.dart';
import 'package:sikap/features/bullying/presentation/pages/bullying_report_wizard_page.dart';
import 'package:sikap/features/bullying/data/repositories/bullying_repository.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

class BullyingReportsListPage extends StatefulWidget {
  const BullyingReportsListPage({super.key});

  @override
  State<BullyingReportsListPage> createState() =>
      _BullyingReportsListPageState();
}

class _BullyingReportsListPageState extends State<BullyingReportsListPage> {
  late final BullyingRepository repo;
  late final SessionService _session;
  bool _isLoading = true;
  List<_ReportItem> _all = [];

  String _filter = 'Semua';
  String _sort = 'Terbaru';

  @override
  void initState() {
    super.initState();
    _session = SessionService();
    repo = BullyingRepository(
      apiClient: ApiClient(),
      session: _session,
      auth: AuthHeaderProvider(
        loadUserToken: () async => null,
        loadGuestToken: () async => await _session.loadGuestToken(),
        loadGuestId: () async => await _session.loadGuestId(),
      ),
      gate: guestAuthGateInstance(),
    );
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      await ensureGuestAuthenticated();
      print("[DEBUG] Loading bullying reports");
      final token = await _session.loadGuestToken();
      if (token == null || token.isEmpty) {
        await ensureGuestAuthenticated();
      }
      final result = await repo.getMyBullyingReports(asGuest: true);
      print("[DEBUG] Loaded reports: ${result.data}");
      if (result.success && result.data != null) {
        setState(() {
          _all = result.data!
              .map((item) => _ReportItem.fromJson(item as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to load reports: ${result.message}')));
        }
      }
    } catch (e) {
      print("[DEBUG] Error loading reports: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error loading reports: $e')));
      }
    }
  }

  List<_ReportItem> get _filteredSorted {
    List<_ReportItem> list =
        _all.where((c) => _filter == 'Semua' || c.status == _filter).toList();
    list.sort((a, b) => _sort == 'Terbaru'
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Bullying'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BullyingReportWizardPage()),
          );
        },
        backgroundColor: const Color(0xFFC89EFF),
        foregroundColor: Colors.white,
        label: const Text('Buat Laporan'),
        icon: const Icon(Icons.add),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: _buildPillButton(
                                  icon: Icons.filter_list,
                                  label: 'Filter',
                                  onTap: _showFilterDialog)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildPillButton(
                                  icon: Icons.sort,
                                  label: 'Urutkan',
                                  onTap: _showSortDialog)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredSorted.length,
                          itemBuilder: (context, index) {
                            final item = _filteredSorted[index];
                            return _ReportCard(item: item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPillButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF7F55B1)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Filter status'),
          children: [
            RadioGroup<String>(
              groupValue: _filter,
              onChanged: (val) {
                if (val == null) return;
                setState(() => _filter = val);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...['Semua', 'Baru', 'Diproses', 'Selesai', 'Ditolak'].map(
                    (s) => RadioListTile<String>(
                      title: Text(s),
                      value: s,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Urutkan'),
          children: [
            RadioGroup<String>(
              groupValue: _sort,
              onChanged: (val) {
                if (val == null) return;
                setState(() => _sort = val);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...['Terbaru', 'Terlama'].map(
                    (s) => RadioListTile<String>(
                      title: Text(s),
                      value: s,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReportItem {
  _ReportItem({
    required this.id,
    required this.status,
    required this.title,
    required this.createdAt,
    required this.category,
    required this.description,
    required this.evidences,
    required this.anonymous,
    required this.confirmTruth,
    this.teacherComment,
    this.teacherCommentDate,
  });

  final String id;
  final String status;
  final String title;
  final DateTime createdAt;
  final String category;
  final String description;
  final List<String> evidences;
  final bool anonymous;
  final bool confirmTruth;
  final String? teacherComment;
  final DateTime? teacherCommentDate;

  factory _ReportItem.fromJson(Map<String, dynamic> json) {
    String category =
        (json['incident_type_name'] ?? json['incident_type'] ?? json['type'] ?? '')
            .toString();
    if (category.isEmpty) {
      final dynamic t = json['incident_type_id'] ?? json['incident_type'];
      int? id;
      if (t is num) id = t.toInt();
      if (t is String) id = int.tryParse(t);
      if (id != null) category = _mapIncidentTypeIdToName(id);
    } else {
      final lower = category.toLowerCase();
      if (lower.contains('fisik') || lower.contains('physical')) category = 'Secara fisik';
      else if (lower.contains('verbal')) category = 'Secara verbal';
      else if (lower.contains('cyber')) category = 'Cyberbullying';
      else if (lower.contains('sosial') || lower.contains('social') || lower.contains('pengucilan')) category = 'Pengucilan';
      else if (lower.contains('lain') || lower.contains('other') || lower.contains('seksual') || lower.contains('sexual')) category = 'Lainnya';
    }
    if (category.isEmpty) {
      // Try mapping from id or numeric type
      final dynamic t = json['incident_type_id'] ?? json['incident_type'];
      int? id;
      if (t is num) id = t.toInt();
      if (t is String) id = int.tryParse(t);
      if (id != null) {
        category = _mapIncidentTypeIdToName(id);
      }
    }
    final String description = (json['description'] ?? '').toString();
    final String computedTitle =
        (json['title'] ?? '').toString().trim().isNotEmpty
            ? (json['title'] as String)
            : (category.isNotEmpty
                ? category
                : (description.isNotEmpty
                    ? (description.length > 60
                        ? '${description.substring(0, 60)}…'
                        : description)
                    : ''));

    return _ReportItem(
      id: json['id']?.toString() ?? '',
      status: (json['status'] ?? '').toString(),
      title: computedTitle,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      category: category,
      description: description,
      evidences: List<String>.from(json['evidences'] ?? []),
      anonymous: json['anonymous'] ?? false,
      confirmTruth: json['confirm_truth'] ?? false,
      teacherComment: json['teacher_comment'],
      teacherCommentDate: json['teacher_comment_date'] != null
          ? DateTime.tryParse(json['teacher_comment_date'])
          : null,
    );
  }

  static String _mapIncidentTypeIdToName(int id) {
    switch (id) {
      case 1:
        return 'Secara fisik';
      case 2:
        return 'Secara verbal';
      case 3:
        return 'Cyberbullying';
      case 4:
        return 'Pengucilan';
      case 5:
        return 'Lainnya';
      default:
        return '';
    }
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.item});
  final _ReportItem item;

  Color get statusColor {
    switch (item.status) {
      case 'Baru':
        return const Color(0xFF2196F3);
      case 'Diproses':
        return const Color(0xFFFF9800);
      case 'Selesai':
        return const Color(0xFF2E7D32);
      case 'Ditolak':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  static String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BullyingDetailPage(id: item.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(item.status,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
              const SizedBox(height: 8),
              Text(item.title.isNotEmpty ? item.title : item.category,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.edit_calendar,
                      size: 18, color: Colors.black45),
                  const SizedBox(width: 8),
                  Text(_formatDate(item.createdAt),
                      style: const TextStyle(color: Colors.black45)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
