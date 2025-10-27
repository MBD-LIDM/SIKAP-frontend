import 'package:flutter/material.dart';

class ReflectionListPage extends StatefulWidget {
  const ReflectionListPage({
    super.key,
    required this.scenarioTitle,
    required this.scenarioDescription,
    required this.question,
  });

  final String scenarioTitle;
  final String scenarioDescription;
  final String question;

  @override
  State<ReflectionListPage> createState() => _ReflectionListPageState();
}

class _ReflectionListPageState extends State<ReflectionListPage> {
  String _sort = 'Terbaru';

  // Placeholder data. Nantinya dapat diganti dari API/backend.
  final List<_ReflectionItem> _reflections = [
    _ReflectionItem(createdAt: DateTime.now().subtract(const Duration(hours: 2)), text: 'Saya belajar untuk minta bantuan wali kelas saat melihat teman dibully.'),
    _ReflectionItem(createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)), text: 'Saat sedih, saya mencoba bernapas dalam dan bicara ke orang tua.'),
    _ReflectionItem(createdAt: DateTime.now().subtract(const Duration(days: 3)), text: 'Saya akan melapor dengan aman dan tidak menghadapi sendiri pelaku.'),
  ];

  List<_ReflectionItem> get _sortedList {
    final list = [..._reflections];
    list.sort((a, b) => _sort == 'Terbaru' ? b.createdAt.compareTo(a.createdAt) : a.createdAt.compareTo(b.createdAt));
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.scenarioTitle, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Deskripsi Skenario: ${widget.scenarioDescription}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text('Pertanyaan yang diberikan: ${widget.question}', style: const TextStyle(color: Colors.white70)),
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
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
                        ]),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sort,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            items: const [
                              DropdownMenuItem(value: 'Terbaru', child: Text('Terbaru')),
                              DropdownMenuItem(value: 'Terlama', child: Text('Terlama')),
                            ],
                            onChanged: (v) => setState(() => _sort = v ?? 'Terbaru'),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _sortedList.length,
                  itemBuilder: (context, index) {
                    final item = _sortedList[index];
                    return _ReflectionCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Text(_formatDate(item.createdAt), style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.text),
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


