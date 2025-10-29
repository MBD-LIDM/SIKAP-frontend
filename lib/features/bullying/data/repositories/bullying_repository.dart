import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

import '../models/bullying_create_response.dart';
import '../models/bullying_detail_response.dart';
import '../models/bullying_list_response.dart';
import '../models/bullying_model.dart';

class BullyingRepository {
  final ApiClient apiClient;
  final AuthHeaderProvider auth;

  BullyingRepository({required this.apiClient, required this.auth});

  Future<BullyingCreateResponse> createBullyingReport(Map<String, dynamic> data,
      {bool asGuest = false}) async {
    final headers = await auth.build(asGuest: asGuest);
    final resp = await apiClient.post<Map<String, dynamic>>(
        '/api/bullying/report/', data,
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return BullyingCreateResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<BullyingDetailResponse> getBullyingDetail(String id,
      {bool asGuest = false}) async {
    final headers = await auth.build(asGuest: asGuest);
    final resp = await apiClient.get<Map<String, dynamic>>(
        '/api/bullying/report/$id/',
        headers: headers,
        transform: (raw) => raw as Map<String, dynamic>);
    return BullyingDetailResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<BullyingListResponse> getBullyingList(
      {String? status,
      String? incidentType,
      String? createdAtGte,
      String? createdAtLte,
      bool asGuest = false}) async {
    final params = <String>[];
    if (status != null) params.add('status=$status');
    if (incidentType != null) params.add('incident_type=$incidentType');
    if (createdAtGte != null) params.add('created_at_gte=$createdAtGte');
    if (createdAtLte != null) params.add('created_at_lte=$createdAtLte');
    final q = params.isNotEmpty ? '?${params.join('&')}' : '';

    final headers = await auth.build(asGuest: asGuest);
    final resp = await apiClient.get<List<dynamic>>('/api/bullying/cases/$q',
        headers: headers, transform: (raw) => raw as List<dynamic>);
    return BullyingListResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data});
  }

  Future<BullyingModel> updateBullyingReport(
      String id, Map<String, dynamic> data) async {
    final headers = await auth.build();
    final resp = await apiClient.patch<Map<String, dynamic>>(
        '/api/bullying/report/$id/', data,
        headers: headers, transform: (raw) => raw as Map<String, dynamic>);
    return BullyingModel.fromJson(resp.data);
  }

  Future<bool> deleteBullyingReport(String id) async {
    final headers = await auth.build();
    await apiClient.patch('/api/bullying/report/$id/delete/', {},
        headers: headers);
    return true;
  }
}
