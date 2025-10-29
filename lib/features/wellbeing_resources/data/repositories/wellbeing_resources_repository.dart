import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

import '../models/wellbeing_resources_create_response.dart';
import '../models/wellbeing_resources_detail_response.dart';
import '../models/wellbeing_resources_list_response.dart';

class WellbeingResourcesRepository {
  final ApiClient apiClient;
  final AuthHeaderProvider auth;

  WellbeingResourcesRepository({required this.apiClient, required this.auth});

  Future<WellbeingResourcesListResponse> getResourcesList(
      {String? category,
      String? type,
      String? ordering,
      bool asGuest = false}) async {
    final params = <String>[];
    if (category != null && category.isNotEmpty)
      params.add('category=$category');
    if (type != null && type.isNotEmpty) params.add('type=$type');
    if (ordering != null && ordering.isNotEmpty)
      params.add('ordering=$ordering');
    final q = params.isNotEmpty ? '?${params.join('&')}' : '';

    final headers = await auth.build(asGuest: asGuest);

    final resp = await apiClient.get<List<dynamic>>(
        '/api/wellbeing/resources/$q',
        headers: headers,
        transform: (raw) => raw as List<dynamic>);
    return WellbeingResourcesListResponse(
        success: true, message: '', data: resp.data);
  }

  Future<WellbeingResourcesDetailResponse> getResourceDetail(String id,
      {bool asGuest = false}) async {
    final headers = await auth.build(asGuest: asGuest);
    final resp = await apiClient.get<Map<String, dynamic>>(
        '/api/wellbeing/resources/$id/',
        headers: headers,
        transform: (raw) => raw as Map<String, dynamic>);
    return WellbeingResourcesDetailResponse(
        success: true, message: '', data: resp.data);
  }

  Future<WellbeingResourcesCreateResponse> createResource(
      Map<String, dynamic> data) async {
    final headers = await auth.build();
    final resp = await apiClient.post<Map<String, dynamic>>(
        '/api/wellbeing/resources/', data,
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return WellbeingResourcesCreateResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<WellbeingResourcesDetailResponse> updateResource(
      String id, Map<String, dynamic> data) async {
    final headers = await auth.build();
    final resp = await apiClient.patch<Map<String, dynamic>>(
        '/api/wellbeing/resources/$id/', data,
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return WellbeingResourcesDetailResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<bool> deleteResource(String id) async {
    final headers = await auth.build();
    // ApiClient doesn't have delete implemented; use patch to mark deleted or implement delete call later.
    // For now attempt to call endpoint via post to a delete action if backend supports it.
    await apiClient.patch('/api/wellbeing/resources/$id/delete/', {},
        headers: headers);
    return true;
  }

  Future<bool> likeResource(String id) async {
    final headers = await auth.build();
    await apiClient.post('/api/wellbeing/resources/$id/like/', {},
        headers: headers);
    return true;
  }

  Future<bool> unlikeResource(String id) async {
    final headers = await auth.build();
    await apiClient.post('/api/wellbeing/resources/$id/unlike/', {},
        headers: headers);
    return true;
  }

  Future<bool> viewResource(String id, {bool asGuest = false}) async {
    final headers = await auth.build(asGuest: asGuest);
    await apiClient.post('/api/wellbeing/resources/$id/view/', {},
        headers: headers);
    return true;
  }
}
