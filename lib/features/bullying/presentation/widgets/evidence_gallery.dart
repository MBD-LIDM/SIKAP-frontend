import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/auth/ensure_guest_auth.dart';
import 'package:sikap/features/bullying/data/repositories/bullying_repository.dart';
import 'package:sikap/features/bullying/data/models/attachment_model.dart';

class EvidenceGallery extends StatefulWidget {
  final int reportId;
  final bool asGuest;
  const EvidenceGallery({super.key, required this.reportId, this.asGuest = true});

  @override
  State<EvidenceGallery> createState() => _EvidenceGalleryState();
}

class _EvidenceGalleryState extends State<EvidenceGallery> {
  final SessionService _session = SessionService();
  late final BullyingRepository _repo;

  bool _loading = false;
  List<Attachment> _items = const [];

  @override
  void initState() {
    super.initState();
    final api = ApiClient();
    final auth = AuthHeaderProvider(
      loadUserToken: () async => await _session.loadUserToken(),
      loadGuestToken: () async => await _session.loadGuestToken(),
      loadGuestId: () async => await _session.loadGuestId(),
    );
    _repo = BullyingRepository(
      apiClient: api,
      session: _session,
      auth: auth,
      gate: guestAuthGateInstance(),
    );
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      if (widget.asGuest) {
        await ensureGuestAuthenticated();
      }
      final items = await _repo.getReportAttachmentsTyped(
        reportId: widget.reportId,
        asGuest: widget.asGuest,
      );
      if (!mounted) return;
      setState(() => _items = items);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openUrl(String url) {
    final uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Memuat...', style: TextStyle(color: Colors.black54)),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 4 / 3,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final att = _items[index];
            if (att.kind == 'image') {
              return GestureDetector(
                onTap: () => _openUrl(att.fileUrl),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    att.fileUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      // Signed URL mungkin expired → refresh daftar
                      _load();
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.refresh, color: Colors.grey),
                      );
                    },
                  ),
                ),
              );
            }
            // PDF
            return OutlinedButton.icon(
              onPressed: () => _openUrl(att.fileUrl),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Lihat PDF'),
            );
          },
        ),
      ],
    );
  }
}

