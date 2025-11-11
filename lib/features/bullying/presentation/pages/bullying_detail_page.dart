import 'package:flutter/material.dart';
import 'package:sikap/features/bullying/data/repositories/bullying_repository.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/features/bullying/presentation/widgets/evidence_gallery.dart';

class BullyingDetailPage extends StatefulWidget {
  const BullyingDetailPage({super.key, required this.id});

  final String id;

  @override
  State<BullyingDetailPage> createState() => _BullyingDetailPageState();
}

class _BullyingDetailPageState extends State<BullyingDetailPage> {
  late final BullyingRepository repo;
  late final SessionService _session;
  bool _isLoading = true;
  Map<String, dynamic>? _data;
  String? _error;
  List<Map<String, dynamic>> _attachments = [];

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
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      await ensureGuestAuthenticated();
      print("[DEBUG] Loading bullying detail for id: ${widget.id}");
      final result = await repo.getBullyingDetail(widget.id, asGuest: true);
      print("[DEBUG] Loaded detail: ${result.data}");
      if (result.success && result.data != null) {
        // Some backends wrap payload under an extra 'data' key
        final raw = result.data!;
        final inner = (raw is Map && raw['data'] is Map)
            ? Map<String, dynamic>.from(raw['data'] as Map)
            : Map<String, dynamic>.from(raw as Map);
        // Try inline attachments if present
        List<Map<String, dynamic>> inlineAtt = [];
        final inline =
            inner['attachments'] ?? inner['evidences'] ?? inner['files'];
        if (inline is List) {
          inlineAtt =
              inline.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
        setState(() {
          _data = inner;
          _attachments = inlineAtt;
          _isLoading = false;
        });
        // If no inline attachments, fetch via endpoint
        if (_attachments.isEmpty) {
          print("[DEBUG] No inline attachments, fetching via API");
          final rid = int.tryParse(inner['id']?.toString() ?? widget.id);
          print("[DEBUG] Report ID for attachments: $rid");
          if (rid != null) {
            final list =
                await repo.getReportAttachments(reportId: rid, asGuest: true);
            print("[DEBUG] Fetched ${list.length} attachments from API");
            for (var i = 0; i < list.length; i++) {
              print("[DEBUG] Attachment $i: ${list[i]}");
            }
            if (mounted) setState(() => _attachments = list);
          }
        } else {
          print("[DEBUG] Found ${_attachments.length} inline attachments");
          for (var i = 0; i < _attachments.length; i++) {
            print("[DEBUG] Inline attachment $i: ${_attachments[i]}");
          }
        }
      } else {
        setState(() {
          _error = result.message;
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to load detail: ${result.message}')));
        }
      }
    } catch (e) {
      print("[DEBUG] Error loading detail: $e");
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error loading detail: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Laporan Bullying'),
          backgroundColor: const Color(0xFF7F55B1),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _data == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Laporan Bullying'),
          backgroundColor: const Color(0xFF7F55B1),
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('Error: $_error')),
      );
    }

    final rawTitle = (_data!['title'] ?? '').toString();
    // Determine category display name robustly from various possible fields
    String categoryName =
        (_data!['incident_type_name'] ?? _data!['incident_type'] ?? '')
            .toString();
    if (categoryName.isEmpty) {
      // Try ID-based mapping
      final dynamic t = _data!['incident_type_id'] ?? _data!['incident_type'];
      int? id;
      if (t is num) id = t.toInt();
      if (t is String) id = int.tryParse(t);
      if (id != null) categoryName = _mapIncidentTypeIdToName(id);
    }
    if (categoryName.isEmpty) {
      // Try slug/key mapping (english/indonesian)
      final dynamic k = _data!['incident_type'] ?? _data!['type'];
      if (k is String && k.trim().isNotEmpty) {
        categoryName = _mapIncidentTypeKeyToName(k.trim());
      }
    }
    final title = rawTitle.isNotEmpty
        ? rawTitle
        : (categoryName.isNotEmpty ? categoryName : 'Laporan Bullying');
    final status = (_data!['status'] ?? '').toString();
    final createdAt =
        DateTime.tryParse(_data!['created_at'] ?? '') ?? DateTime.now();
    final category = categoryName;
    final description = (_data!['description'] ??
            _data!['desc'] ??
            _data!['report_description'] ??
            _data!['details'] ??
            _data!['content'] ??
            '')
        .toString();
    final teacherComment = _data!['teacher_comment'];
    final teacherCommentDate = _data!['teacher_comment_date'] != null
        ? DateTime.tryParse(_data!['teacher_comment_date'])
        : null;

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
                                Icon(
                                  _iconForCategory(category),
                                  color: const Color(0xFF7F55B1),
                                ),
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
                          Builder(builder: (context) {
                            final rid = int.tryParse(
                                  _data!['id']?.toString() ?? widget.id,
                                ) ??
                                int.tryParse(widget.id);
                            if (rid == null) {
                              return const Text('-',
                                  style: TextStyle(color: Colors.black54));
                            }
                            return EvidenceGallery(reportId: rid, asGuest: true);
                          }),
                          const SizedBox(height: 8),
                          // Teacher Comment (optional)
                          if (teacherComment != null) ...[
                            const Divider(height: 32),
                            const Text('Komentar Guru',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.edit_calendar,
                                    size: 18, color: Colors.black45),
                                const SizedBox(width: 8),
                                Text(
                                  teacherCommentDate != null
                                      ? _formatDate(teacherCommentDate)
                                      : '-',
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
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2)),
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

  Color _getStatusColor(String status) {
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

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  String _mapIncidentTypeIdToName(int id) {
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

  String _mapIncidentTypeKeyToName(String key) {
    final k = key.toLowerCase();
    if (k.contains('fisik') || k.contains('physical')) return 'Secara fisik';
    if (k.contains('verbal')) return 'Secara verbal';
    if (k.contains('cyber')) return 'Cyberbullying';
    if (k.contains('sosial') ||
        k.contains('social') ||
        k.contains('pengucilan')) return 'Pengucilan';
    if (k.contains('seksual') || k.contains('sexual')) return 'Lainnya';
    if (k.contains('lain') || k.contains('other')) return 'Lainnya';
    return '';
  }

  IconData _iconForCategory(String name) {
    final n = name.toLowerCase();
    if (n.contains('fisik') || n.contains('physical')) {
      return Icons.pan_tool;
    }
    if (n.contains('verbal')) {
      return Icons.record_voice_over;
    }
    if (n.contains('cyber')) {
      return Icons.computer;
    }
    if (n.contains('sosial') ||
        n.contains('pengucilan') ||
        n.contains('social')) {
      return Icons.group_off;
    }
    return Icons.more_horiz;
  }

}
