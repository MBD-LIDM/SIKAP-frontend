import 'package:flutter/material.dart';

class BullyingDetailPage extends StatelessWidget {
  const BullyingDetailPage({
    super.key,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.category,
    required this.description,
    required this.evidences,
    required this.anonymous,
    required this.confirmTruth,
    this.teacherComment,
    this.teacherCommentDate,
  });

  final String title;
  final String status;
  final DateTime createdAt;
  final String category;
  final String description;
  final List<String> evidences;
  final bool anonymous;
  final bool confirmTruth;
  final String? teacherComment;
  final DateTime? teacherCommentDate;

  Color get statusColor {
    switch (status) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan Bullying'),
        backgroundColor: const Color(0xFF7F55B1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF7F55B1),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12)),
                          ),
                          const SizedBox(height: 8),
                          // Title
                          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87)),
                          const SizedBox(height: 12),
                          // Created at
                          Row(
                            children: [
                              const Icon(Icons.edit_calendar, size: 18, color: Colors.black45),
                              const SizedBox(width: 8),
                              Text(_formatDate(createdAt), style: const TextStyle(color: Colors.black45)),
                            ],
                          ),
                          const Divider(height: 32),
                          // Category
                          const Text('Kategori Bullying', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4B5),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1)),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.record_voice_over, color: Color(0xFF7F55B1)),
                                const SizedBox(width: 8),
                                Text(category, style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Description
                          const Text('Penjelasan', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
                          const SizedBox(height: 8),
                          Text(description.isEmpty ? '-' : description),
                          const SizedBox(height: 16),
                          // Evidences
                          const Text('Bukti', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
                          const SizedBox(height: 8),
                          if (evidences.isEmpty)
                            const Text('-', style: TextStyle(color: Colors.black54))
                          else
                            Column(
                              children: evidences
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
                                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                                          ]),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.insert_drive_file, color: Color(0xFF7F55B1)),
                                              const SizedBox(width: 8),
                                              Expanded(child: Text(e)),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          const SizedBox(height: 8),
                          // Teacher Comment (optional)
                          if (teacherComment != null) ...[
                            const Divider(height: 32),
                            const Text('Komentar Guru', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.edit_calendar, size: 18, color: Colors.black45),
                                const SizedBox(width: 8),
                                Text(
                                  teacherCommentDate != null ? _formatDate(teacherCommentDate!) : '-',
                                  style: const TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6D7FF),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Text(
                                teacherComment!,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}










