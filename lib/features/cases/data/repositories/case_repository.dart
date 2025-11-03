// lib/features/cases/data/repositories/case_repository.dart

import 'package:sikap/core/auth/session_service.dart';
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/api_exception.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

class CaseRepository {
  final ApiClient apiClient;
  final SessionService session;
  final AuthHeaderProvider auth;

  CaseRepository({
    required this.apiClient,
    required this.session,
    required this.auth,
  });

  /// GET /api/bullying/cases/
  /// List semua laporan di sekolah staff
  Future<List<Map<String, dynamic>>> getCases({
    String? status,
    String? incidentType,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) async {
    final headers = await auth.buildHeaders(asGuest: false);
    
    // Build query params
    final queryParams = <String, String>{};
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (incidentType != null && incidentType.isNotEmpty) {
      queryParams['incident_type'] = incidentType;
    }
    if (createdAfter != null) {
      queryParams['created_at__gte'] = createdAfter.toIso8601String();
    }
    if (createdBefore != null) {
      queryParams['created_at__lte'] = createdBefore.toIso8601String();
    }

    String path = '/api/bullying/cases/';
    if (queryParams.isNotEmpty) {
      final query = queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      path = '$path?$query';
    }

    final resp = await apiClient.get<Map<String, dynamic>>(
      path,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: true, // Backend uses envelope wrapper
    );

    // Parse envelope: {success, message, data: {results: [...]}}
    if (resp.data['success'] == true && resp.data['results'] is List) {
      return List<Map<String, dynamic>>.from(resp.data['results'] as List);
    }
    return [];
  }

  /// GET /api/bullying/cases/{report_id}/
  /// Detail satu laporan di sekolah staff
  Future<Map<String, dynamic>> getCaseDetail(int reportId) async {
    final headers = await auth.buildHeaders(asGuest: false);
    
    final resp = await apiClient.get<Map<String, dynamic>>(
      '/api/bullying/cases/$reportId/',
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: true,
    );

    // Parse envelope: {success, message, data: {...}}
    if (resp.data['success'] == true && resp.data['data'] is Map) {
      return Map<String, dynamic>.from(resp.data['data'] as Map);
    }
    throw ApiException(
      message: 'Failed to parse case detail',
      code: 500,
    );
  }

  /// GET /api/bullying/report/{report_id}/attachments/
  /// List semua bukti/evidence yang diupload murid
  Future<List<Map<String, dynamic>>> getCaseAttachments(int reportId) async {
    final headers = await auth.buildHeaders(asGuest: false);
    
    final resp = await apiClient.get<Map<String, dynamic>>(
      '/api/bullying/report/$reportId/attachments/',
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: true,
    );

    // Parse envelope: {success, message, results: [...]}
    if (resp.data['success'] == true && resp.data['results'] is List) {
      return List<Map<String, dynamic>>.from(resp.data['results'] as List);
    }
    return [];
  }

  /// PATCH /api/bullying/cases/{report_id}/status/
  /// Update status handling laporan
  Future<void> updateCaseStatus(int reportId, String status) async {
    final headers = await auth.buildHeaders(asGuest: false);
    
    final payload = {'status': status};
    
    await apiClient.patch<Map<String, dynamic>>(
      '/api/bullying/cases/$reportId/status/',
      payload,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: true,
    );
  }
}

