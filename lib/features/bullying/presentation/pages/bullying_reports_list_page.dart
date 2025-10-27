import 'package:flutter/material.dart';
import 'package:sikap/features/bullying/presentation/pages/bullying_detail_page.dart';
import 'package:sikap/features/bullying/presentation/pages/bullying_report_wizard_page.dart';

class BullyingReportsListPage extends StatefulWidget {
  const BullyingReportsListPage({super.key});

  @override
  State<BullyingReportsListPage> createState() => _BullyingReportsListPageState();
}

class _BullyingReportsListPageState extends State<BullyingReportsListPage> {
  final List<_ReportItem> _all = [
    _ReportItem(
      status: 'Baru',
      title: 'Bullying Verbal',
      createdAt: DateTime(2025, 8, 22, 9, 18),
      category: 'Secara verbal',
      description:
          'Terjadi tindakan bullying secara verbal seperti mengejek dan menghina saat pelajaran berlangsung.',
      evidences: const ['Screenshot chat', 'Catatan kronologi'],
      anonymous: false,
      confirmTruth: true,
    ),
    _ReportItem(
      status: 'Diproses',
      title: 'Pengucilan',
      createdAt: DateTime(2025, 8, 21, 15, 10),
      category: 'Pengucilan',
      description: 'Dikucilkan dari kelompok belajar dan kegiatan ekstrakurikuler.',
      evidences: const ['Foto daftar hadir'],
      anonymous: true,
      confirmTruth: true,
    ),
    _ReportItem(
      status: 'Selesai',
      title: 'Cyberbullying',
      createdAt: DateTime(2025, 8, 18, 8, 30),
      category: 'Cyberbullying',
      description: 'Komentar menghina di media sosial dan pesan direct yang kasar.',
      evidences: const ['Tangkapan layar komentar'],
      anonymous: false,
      confirmTruth: true,
    ),
  ];

  String _filter = 'Semua';
  String _sort = 'Terbaru';

  List<_ReportItem> get _filteredSorted {
    List<_ReportItem> list = _all.where((c) => _filter == 'Semua' || c.status == _filter).toList();
    list.sort((a, b) => _sort == 'Terbaru' ? b.createdAt.compareTo(a.createdAt) : a.createdAt.compareTo(b.createdAt));
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
            MaterialPageRoute(builder: (context) => const BullyingReportWizardPage()),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildPillButton(icon: Icons.filter_list, label: 'Filter', onTap: _showFilterDialog)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildPillButton(icon: Icons.sort, label: 'Urutkan', onTap: _showSortDialog)),
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

  Widget _buildPillButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF7F55B1)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...['Semua', 'Baru', 'Diproses', 'Selesai'].map(
                  (s) => RadioListTile<String>(
                    title: Text(s),
                    value: s,
                    groupValue: _filter,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => _filter = val);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...['Terbaru', 'Terlama'].map(
                  (s) => RadioListTile<String>(
                    title: Text(s),
                    value: s,
                    groupValue: _sort,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => _sort = val);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ReportItem {
  _ReportItem({
    required this.status,
    required this.title,
    required this.createdAt,
    required this.category,
    required this.description,
    required this.evidences,
    required this.anonymous,
    required this.confirmTruth,
  });

  final String status;
  final String title;
  final DateTime createdAt;
  final String category;
  final String description;
  final List<String> evidences;
  final bool anonymous;
  final bool confirmTruth;
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
            builder: (context) => BullyingDetailPage(
              title: item.title,
              status: item.status,
              createdAt: item.createdAt,
              category: item.category,
              description: item.description,
              evidences: item.evidences,
              anonymous: item.anonymous,
              confirmTruth: item.confirmTruth,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                child: Text(item.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              const SizedBox(height: 8),
              Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.edit_calendar, size: 18, color: Colors.black45),
                  const SizedBox(width: 8),
                  Text(_formatDate(item.createdAt), style: const TextStyle(color: Colors.black45)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


