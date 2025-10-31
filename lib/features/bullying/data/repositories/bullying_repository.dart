// lib/features/bullying/data/repositories/bullying_repository.dart
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

  // =========================
  // G U E S T   E N D P O I N T S
  // =========================

  /// GET /api/bullying/incident-types/
  /// Guest-allowed. Kembalikan list map sederhana (id, type_name, dst).
  Future<List<Map<String, dynamic>>> getIncidentTypes({bool asGuest = true}) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.get<List<dynamic>>(
      '/api/bullying/incident-types/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return resp.data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// POST /api/bullying/report/
  /// HARUS menyertakan: guest_id, incident_type_id (INT), description(>=10), location(>=2), severity, confirm_truth
  Future<BullyingCreateResponse> createBullyingReport(
    Map<String, dynamic> data, {
    bool asGuest = true,
  }) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.post<Map<String, dynamic>>(
      '/api/bullying/report/',
      data,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
    );
    return BullyingCreateResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }

  /// GET /api/bullying/report/history/{guest_id}/
  /// Ini cara paling aman untuk “my reports” pada guest flow.
  Future<BullyingListResponse> getGuestHistory({
    required int guestId,
    bool asGuest = true,
  }) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.get<List<dynamic>>(
      '/api/bullying/report/history/$guestId/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return BullyingListResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }

  /// GET /api/bullying/report/{id}/
  /// Detail laporan guest (header harus X-Guest-Token).
  Future<BullyingDetailResponse> getBullyingDetail(
    String id, {
    bool asGuest = true,
  }) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.get<Map<String, dynamic>>(
      '/api/bullying/report/$id/',
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
    );
    return BullyingDetailResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }

  // =========================
  // S T A F F   E N D P O I N T S
  // =========================

  /// GET /api/bullying/cases/?status=&incident_type=&created_at__gte=&created_at__lte=
  /// STAFF-ONLY (Authorization: Bearer ...). asGuest default = false.
  Future<BullyingListResponse> getBullyingCases({
    String? status,
    String? incidentType,
    String? createdAtGte,
    String? createdAtLte,
    bool asGuest = false, // <- staff by default
  }) async {
    final params = <String>[];
    if (status != null) params.add('status=$status');
    if (incidentType != null) params.add('incident_type=$incidentType');
    if (createdAtGte != null) params.add('created_at__gte=$createdAtGte');
    if (createdAtLte != null) params.add('created_at__lte=$createdAtLte');
    final q = params.isNotEmpty ? '?${params.join('&')}' : '';

    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.get<List<dynamic>>(
      '/api/bullying/cases/$q',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return BullyingListResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }

  /// PATCH /api/bullying/report/{id}/
  /// STAFF-ONLY untuk edit konten laporan (jika diizinkan). Pakai Bearer.
  Future<BullyingModel> updateBullyingReport(
    String id,
    Map<String, dynamic> data, {
    bool asGuest = false, // staff
  }) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.patch<Map<String, dynamic>>(
      '/api/bullying/report/$id/',
      data,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
    );
    return BullyingModel.fromJson(resp.data);
  }

  /// “Soft delete”/aksi lain yang di-backend di-protect (staff).
  Future<bool> deleteBullyingReport(
    String id, {
    bool asGuest = false, // staff
  }) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    await apiClient.patch(
      '/api/bullying/report/$id/delete/',
      {},
      headers: headers,
    );
    return true;
  }

  // =========================
  // (Opsional) Tetap sediakan "my" untuk kasus token-derived di BE.
  // Catatan: hanya bekerja jika backend benar-benar mendukung "my"
  // berbasis guest token. Kalau ragu, pakai getGuestHistory().
  // =========================
  Future<BullyingListResponse> getMyBullyingReports({bool asGuest = true}) async {
    final headers = await auth.buildHeaders(asGuest: asGuest);
    final resp = await apiClient.get<List<dynamic>>(
      '/api/bullying/report/my/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return BullyingListResponse.fromJson(
      {'success': true, 'message': '', 'data': resp.data},
    );
  }
}
