import 'package:flutter/material.dart';
import 'case_confirmation_page.dart';
import 'package:sikap/features/cases/data/repositories/case_repository.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

class CaseDetailPage extends StatefulWidget {
  const CaseDetailPage({
    super.key,
    required this.reportId,
  });

  final int reportId;

  @override
  State<CaseDetailPage> createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  late final CaseRepository _repo;
  late final SessionService _session;
  bool _isLoading = true;
  Map<String, dynamic>? _data;
  List<Map<String, dynamic>> _attachments = [];
  String? _error;

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
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      // Load case detail
      final detail = await _repo.getCaseDetail(widget.reportId);

      // Load attachments
      final attachments = await _repo.getCaseAttachments(widget.reportId);

      setState(() {
        _data = detail;
        _attachments = attachments;
        _isLoading = false;
      });
    } catch (e) {
      print("[DEBUG] Error loading case detail: $e");
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading detail: $e')),
      );
    }
  }

  Future<void> _handleStatusUpdate(String newStatus) async {
    try {
      await _repo.updateCaseStatus(widget.reportId, newStatus);
      if (!mounted) return;

      // Reload detail
      await _loadDetail();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Status berhasil diupdate'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Gagal update status: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Baru':
        return const Color(0xFF2196F3);
      case 'Diproses':
        return const Color(0xFFFF9800);
      case 'Ditolak':
        return const Color(0xFFD32F2F);
      case 'Selesai':
        return const Color(0xFF2E7D32);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  String _filenameFromUrl(String url) {
    if (url.isEmpty) return '-';
    try {
      final segs = Uri.parse(url).pathSegments;
      if (segs.isNotEmpty) return segs.last;
    } catch (_) {}
    return url;
  }

  IconData _iconForCategory(String name) {
    final n = name.toLowerCase();
    if (n.contains('fisik')) return Icons.pan_tool;
    if (n.contains('verbal')) return Icons.record_voice_over;
    if (n.contains('cyber')) return Icons.computer;
    if (n.contains('sosial') || n.contains('pengucilan'))
      return Icons.group_off;
    return Icons.more_horiz;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Kasus'),
          backgroundColor: const Color(0xFF7F55B1),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _data == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Kasus'),
          backgroundColor: const Color(0xFF7F55B1),
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('Error: $_error')),
      );
    }

    // Extract data with fallbacks
    final rawTitle = (_data!['title'] ?? '').toString();
    final typeField = (_data!['type'] ?? '').toString(); // Use 'type' field
    final description = (_data!['description'] ?? '').toString();
    final status = (_data!['status'] ?? '').toString();
    final createdAt =
        DateTime.tryParse(_data!['created_at']?.toString() ?? '') ??
            DateTime.now();

    // Map type to display name
    String categoryName = '-';
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
        categoryName = typeField; // fallback to raw value
    }

    final title = rawTitle.isNotEmpty
        ? rawTitle
        : (categoryName != '-' ? categoryName : 'Laporan Bullying');

    final category = categoryName;

    print('[DEBUG] Attachments: ${_attachments.length} items');
    print('[DEBUG] Attachments data: $_attachments');
    final evidences = _attachments.map((a) {
      final fileUrl = a['file_url']?.toString() ?? '';
      print('[DEBUG] Processing attachment: $fileUrl');
      return _filenameFromUrl(fileUrl);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kasus'),
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
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                color: _getStatusColor(status)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(status,
                                style: TextStyle(
                                    color: _getStatusColor(status),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                          ),
                          const SizedBox(height: 8),
                          // Title
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87)),
                          const SizedBox(height: 12),
                          // Created at
                          Row(
                            children: [
                              const Icon(Icons.edit_calendar,
                                  size: 18, color: Colors.black45),
                              const SizedBox(width: 8),
                              Text(_formatDate(createdAt),
                                  style:
                                      const TextStyle(color: Colors.black45)),
                            ],
                          ),
                          const Divider(height: 32),
                          // Category
                          const Text('Kategori Bullying',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4B5),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1)),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_iconForCategory(category),
                                    color: const Color(0xFF7F55B1)),
                                const SizedBox(width: 8),
                                Text(category,
                                    style:
                                        const TextStyle(color: Colors.black87)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Description
                          const Text('Penjelasan',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87)),
                          const SizedBox(height: 8),
                          Text(description.isEmpty ? '-' : description),
                          const SizedBox(height: 16),
                          // Evidences
                          const Text('Bukti',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87)),
                          const SizedBox(height: 8),
                          if (evidences.isEmpty)
                            const Text('-',
                                style: TextStyle(color: Colors.black54))
                          else
                            Column(
                              children: evidences.map((e) {
                                final idx = evidences.indexOf(e);
                                final attachment = _attachments[idx];
                                final kind =
                                    attachment['kind']?.toString() ?? '';

                                // Dynamic icon based on kind
                                IconData fileIcon = Icons.insert_drive_file;
                                if (kind == 'image') {
                                  fileIcon = Icons.image;
                                } else if (kind == 'pdf') {
                                  fileIcon = Icons.picture_as_pdf;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2)),
                                        ]),
                                    child: Row(
                                      children: [
                                        Icon(fileIcon,
                                            color: const Color(0xFF7F55B1)),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(e)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white)),
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CaseConfirmationPage(
                                  caseTitle: title, action: 'tolak'),
                            ),
                          );
                          if (!context.mounted) return;
                          if (result != null) {
                            await _handleStatusUpdate('Ditolak');
                            Navigator.of(context).pop(result);
                          }
                        },
                        child: const Text('Tolak'),
                      ),
                    ),
                    if (status != 'Diproses') ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB678FF),
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CaseConfirmationPage(
                                    caseTitle: title, action: 'proses'),
                              ),
                            );
                            if (!context.mounted) return;
                            if (result != null) {
                              await _handleStatusUpdate('Diproses');
                              Navigator.of(context).pop(result);
                            }
                          },
                          child: const Text('Proses',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                    if (status == 'Diproses') ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB678FF),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await _handleStatusUpdate('Selesai');
                          },
                          child: const Text('Selesai'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
