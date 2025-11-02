// lib/features/bullying/data/repositories/bullying_repository.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sikap/core/auth/guest_auth_gate.dart';
import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/auth_header_provider.dart';
import 'package:sikap/core/network/with_guest_auth_retry.dart';

import '../models/bullying_create_response.dart';
import '../models/bullying_detail_response.dart';
import '../models/bullying_list_response.dart';
import '../models/bullying_model.dart';

class BullyingRepository {
  final ApiClient apiClient;
  final SessionService session;
  final AuthHeaderProvider auth;
  final GuestAuthGate gate;

  BullyingRepository({
    required this.apiClient,
    required this.session,
    required this.auth,
    required this.gate,
  });

  // =========================
  // G U E S T   E N D P O I N T S
  // =========================

  /// GET /api/bullying/incident-types/
  /// Guest-allowed. Kembalikan list map sederhana (id, type_name, dst).
  Future<List<Map<String, dynamic>>> getIncidentTypes(
      {bool asGuest = true}) async {
    if (!asGuest) {
      final headers = await auth.buildHeaders(asGuest: false);
      final resp = await apiClient.get<List<dynamic>>(
        '/api/bullying/incident-types/',
        headers: headers,
        transform: (raw) => raw as List<dynamic>,
        expectEnvelope: false,
      );
      return resp.data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    await gate.ensure();
    return withGuestAuthRetry(() async {
      final headers = await auth.guestHeaders();
      final resp = await apiClient.get<List<dynamic>>(
        '/api/bullying/incident-types/',
        headers: headers,
        transform: (raw) => raw as List<dynamic>,
        expectEnvelope: false,
      );
      return resp.data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }, gate);
  }

  /// POST /api/bullying/report/
  /// HARUS menyertakan: incident_type_id (INT), description(>=10), confirm_truth
  Future<BullyingCreateResponse> createBullyingReport(
    Map<String, dynamic> data, {
    bool asGuest = true,
  }) async {
    if (!asGuest) {
      final headers = await auth.buildHeaders(asGuest: false);
      final resp = await apiClient.post<Map<String, dynamic>>(
        '/api/bullying/report/',
        _sanitizeCreatePayload(data),
        headers: headers,
        transform: (raw) => raw as Map<String, dynamic>,
        expectEnvelope: false,
      );
      return BullyingCreateResponse.fromJson(resp.data);
    }

    await gate.ensure();
    return withGuestAuthRetry(() async {
      final payload = _sanitizeCreatePayload(data);

      final headers = await auth.guestHeaders();
      final resp = await apiClient.post<Map<String, dynamic>>(
        '/api/bullying/report/',
        payload,
        headers: headers,
        transform: (raw) => raw as Map<String, dynamic>,
        expectEnvelope: false,
      );
      return BullyingCreateResponse.fromJson(resp.data);
    }, gate);
  }

  Map<String, dynamic> _sanitizeCreatePayload(Map<String, dynamic> input) {
    final payload = Map<String, dynamic>.from(input);

    // Coerce incident_type_id to int if possible
    final incidentType = payload['incident_type_id'];
    if (incidentType is String) {
      final parsed = int.tryParse(incidentType);
      if (parsed != null) payload['incident_type_id'] = parsed;
    }
    if (payload['incident_type_id'] is num) {
      payload['incident_type_id'] =
          (payload['incident_type_id'] as num).toInt();
    }

    // Keep only the allowed keys
    final allowedKeys = {
      'description',
      'incident_type_id',
      'confirm_truth',
    };
    payload.removeWhere((key, value) => !allowedKeys.contains(key));

    // Basic presence checks
    if (payload['incident_type_id'] == null) {
      throw ApiException(
        code: 400,
        message: 'incident_type_id is required',
      );
    }
    if (payload['description'] == null) {
      throw ApiException(
        code: 400,
        message: 'description is required',
      );
    }
    if (payload['confirm_truth'] == null) {
      throw ApiException(
        code: 400,
        message: 'confirm_truth is required',
      );
    }

    return payload;
  }

  /// GET /api/bullying/report/history/{guest_id}/
  /// Ini cara paling aman untuk “my reports” pada guest flow.
  Future<BullyingListResponse> getGuestHistory({
    required int guestId,
    bool asGuest = true,
  }) async {
    if (!asGuest) {
      final headers = await auth.buildHeaders(asGuest: false);
      final resp = await apiClient.get<List<dynamic>>(
        '/api/bullying/report/history/$guestId/',
        headers: headers,
        transform: (raw) {
          if (raw is List) return raw;
          if (raw is Map && raw['results'] is List) return raw['results'];
          if (raw is Map && raw['data'] is List) return raw['data'];
          throw const FormatException('Unexpected history shape');
        },
        expectEnvelope: false,
      );
      return BullyingListResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data},
      );
    }

    await gate.ensure();
    return withGuestAuthRetry(() async {
      final headers = await auth.guestHeaders();
      final resp = await apiClient.get<List<dynamic>>(
        '/api/bullying/report/history/$guestId/',
        headers: headers,
        transform: (raw) {
          if (raw is List) return raw;
          if (raw is Map && raw['results'] is List) return raw['results'];
          if (raw is Map && raw['data'] is List) return raw['data'];
          throw const FormatException('Unexpected history shape');
        },
        expectEnvelope: false,
      );
      return BullyingListResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data},
      );
    }, gate);
  }

  /// GET /api/bullying/report/{id}/
  /// Detail laporan guest (header harus X-Guest-Token).
  Future<BullyingDetailResponse> getBullyingDetail(
    String id, {
    bool asGuest = true,
  }) async {
    if (!asGuest) {
      final headers = await auth.buildHeaders(asGuest: false);
      final resp = await apiClient.get<Map<String, dynamic>>(
        '/api/bullying/report/$id/',
        headers: headers,
        transform: (raw) => raw as Map<String, dynamic>,
        expectEnvelope: false,
      );
      return BullyingDetailResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data},
      );
    }

    await gate.ensure();
    return withGuestAuthRetry(() async {
      final headers = await auth.guestHeaders();
      final resp = await apiClient.get<Map<String, dynamic>>(
        '/api/bullying/report/$id/',
        headers: headers,
        transform: (raw) => raw as Map<String, dynamic>,
        expectEnvelope: false,
      );
      return BullyingDetailResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data},
      );
    }, gate);
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
  Future<BullyingListResponse> getMyBullyingReports(
      {bool asGuest = true}) async {
    if (!asGuest) {
      final headers = await auth.buildHeaders(asGuest: false);
      final resp = await apiClient.get<List<dynamic>>(
        '/api/bullying/report/my/',
        headers: headers,
        transform: (raw) {
          if (raw is List) return raw;
          if (raw is Map && raw['results'] is List) return raw['results'];
          if (raw is Map && raw['data'] is List) return raw['data'];
          throw const FormatException('Unexpected my shape');
        },
        expectEnvelope: false,
      );
      return BullyingListResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data},
      );
    }

    await gate.ensure();
    return withGuestAuthRetry(() async {
      final headers = await auth.guestHeaders();
      final resp = await apiClient.get<List<dynamic>>(
        '/api/bullying/report/my/',
        headers: headers,
        transform: (raw) {
          if (raw is List) return raw;
          if (raw is Map && raw['results'] is List) return raw['results'];
          if (raw is Map && raw['data'] is List) return raw['data'];
          throw const FormatException('Unexpected my shape');
        },
        expectEnvelope: false,
      );
      return BullyingListResponse.fromJson(
        {'success': true, 'message': '', 'data': resp.data},
      );
    }, gate);
  }
}
