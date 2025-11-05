import 'package:flutter/material.dart';
import 'case_detail_page.dart';
import 'package:sikap/features/cases/data/repositories/case_repository.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

class CasesListPage extends StatefulWidget {
  const CasesListPage({super.key});

  @override
  State<CasesListPage> createState() => _CasesListPageState();
}

class _CasesListPageState extends State<CasesListPage> {
  late final CaseRepository _repo;
  late final SessionService _session;
  List<_CaseItem> _all = [];
  bool _isLoading = true;

  String _filter = 'Semua';
  String _sort = 'Terbaru';

  @override
  void initState() {
    super.initState();
    _session = SessionService();
    _repo = CaseRepository(
      apiClient: ApiClient(),
      session: _session,
      auth: AuthHeaderProvider(
        loadUserToken: () async => await _session.loadUserToken(),
        loadCsrfToken: () async => await _session.loadCsrfToken(),
        loadGuestToken: () async => null,
        loadGuestId: () async => null,
      ),
    );
    _loadCases();
  }

  Future<void> _loadCases() async {
    setState(() => _isLoading = true);
    try {
      final cases = await _repo.getCases();
      setState(() {
        _all = cases.map((item) {
          final status = (item['status'] ?? '').toString();
          final createdAt =
              DateTime.tryParse(item['created_at']?.toString() ?? '') ??
                  DateTime.now();

          // Extract title and category from 'type' field
          final rawTitle = (item['title'] ?? '').toString();
          final typeField = (item['type'] ?? '').toString();
          final description = (item['description'] ?? '').toString();

          // Map type to display name
          String categoryName = '';
          if (typeField.isNotEmpty) {
            final t = typeField.toLowerCase();
            if (t.contains('fisik'))
              categoryName = 'Secara fisik';
            else if (t.contains('verbal'))
              categoryName = 'Secara verbal';
            else if (t.contains('cyber'))
              categoryName = 'Cyberbullying';
            else if (t.contains('sosial') || t.contains('pengucilan'))
              categoryName = 'Pengucilan';
            else if (t.contains('lainnya') || t.contains('other'))
              categoryName = 'Lainnya';
            else
              categoryName = typeField;
          }

          final title = rawTitle.isNotEmpty
              ? rawTitle
              : (categoryName.isNotEmpty
                  ? categoryName
                  : (description.isNotEmpty
                      ? description.substring(
                          0, description.length.clamp(0, 60))
                      : 'Laporan Bullying'));

          return _CaseItem(
            reportId: item['report_id'] ?? item['id'],
            status: status,
            title: title,
            createdAt: createdAt,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("[DEBUG] Error loading cases: $e");
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cases: $e')),
      );
    }
  }

  List<_CaseItem> get _filteredSorted {
    List<_CaseItem> list =
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
        title: const Text('Lihat Kasus'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              children: [
                // Filter & Sort Row
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: _filteredSorted.length,
                          itemBuilder: (context, index) {
                            final item = _filteredSorted[index];
                            return _CaseCard(item: item);
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
                  ...['Semua', 'Baru', 'Diproses', 'Ditolak'].map(
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

class _CaseItem {
  _CaseItem(
      {required this.reportId,
      required this.status,
      required this.title,
      required this.createdAt});
  final dynamic reportId; // Can be int or string
  final String status;
  final String title;
  final DateTime createdAt;
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.item});
  final _CaseItem item;

  Color get statusColor {
    switch (item.status) {
      case 'Baru':
        return const Color(0xFF2196F3);
      case 'Diproses':
        return const Color(0xFFFF9800);
      case 'Ditolak':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
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
            // Status Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            Text(item.title,
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
    );

    if (item.reportId != null) {
      return GestureDetector(
        onTap: () {
          final reportId = item.reportId is int
              ? item.reportId
              : int.tryParse(item.reportId.toString());
          if (reportId != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CaseDetailPage(reportId: reportId),
              ),
            );
          }
        },
        child: card,
      );
    }
    return card;
  }

  static String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }
}
