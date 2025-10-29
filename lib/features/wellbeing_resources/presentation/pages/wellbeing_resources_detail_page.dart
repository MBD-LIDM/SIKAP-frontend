import 'package:flutter/material.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/features/wellbeing_resources/data/repositories/wellbeing_resources_repository.dart';
import 'package:sikap/features/wellbeing_resources/data/models/wellbeing_resources_model.dart';
import 'package:sikap/core/network/api_exception.dart';

class WellbeingResourcesDetailPage extends StatefulWidget {
  final String resourceId;

  const WellbeingResourcesDetailPage({
    super.key,
    required this.resourceId,
  });

  @override
  State<WellbeingResourcesDetailPage> createState() =>
      _WellbeingResourcesDetailPageState();
}

class _WellbeingResourcesDetailPageState
    extends State<WellbeingResourcesDetailPage> {
  bool _loading = true;
  String? _error;
  WellbeingResourcesModel? _resource;

  late final WellbeingResourcesRepository _repo;

  @override
  void initState() {
    super.initState();
    final api = ApiClient();
    final auth = AuthHeaderProvider(
        loadUserToken: () async => null, loadGuestToken: () async => null);
    _repo = WellbeingResourcesRepository(apiClient: api, auth: auth);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp =
          await _repo.getResourceDetail(widget.resourceId, asGuest: true);
      final data = resp.data;
      if (data == null) throw ApiException(message: 'Data resource kosong');
      setState(() {
        _resource =
            WellbeingResourcesModel.fromJson(Map<String, dynamic>.from(data));
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan';
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sumber Daya'),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _load,
                        child: const Text('Coba lagi'),
                      )
                    ],
                  )
                : _resource == null
                    ? const Text('Tidak ada data')
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_resource!.title,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 8),
                              Text('By: ${_resource!.authorId}'),
                              const SizedBox(height: 12),
                              Text(_resource!.description),
                              const SizedBox(height: 16),
                              Text('Category: ${_resource!.category}'),
                              const SizedBox(height: 8),
                              Text('Type: ${_resource!.type}'),
                              const SizedBox(height: 8),
                              Text(
                                  'Views: ${_resource!.viewsCount} • Likes: ${_resource!.likesCount}'),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
