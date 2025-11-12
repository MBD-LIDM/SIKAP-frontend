// lib/features/cases/data/repositories/case_repository.dart

import 'package:flutter/foundation.dart';
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
    final teacherSchoolId = await session.loadUserSchoolId();
    if (teacherSchoolId == null) {
      throw ApiException(
        message: 'Akun tidak terhubung dengan sekolah. Silakan login ulang.',
        code: 409,
      );
    }

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
      final query = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      path = '$path?$query';
    }

    final resp = await apiClient.get<dynamic>(
      path,
      headers: headers,
      transform: (raw) => raw,
      expectEnvelope: false, // Ignore envelope for cases
    );
    final raw = resp.data;
    final caseList = _normalizeCaseList(raw);

    final sanitized = <Map<String, dynamic>>[];
    final blockedReportIds = <dynamic>[];

    for (final caseData in caseList) {
      final schoolId = _parseInt(caseData['school_id']);
      if (schoolId == null || schoolId == teacherSchoolId) {
        sanitized.add(caseData);
      } else {
        blockedReportIds.add(caseData['report_id'] ?? caseData['id']);
      }
    }

    if (blockedReportIds.isNotEmpty) {
      debugPrint(
        '[CASE_REPO] Blocked ${blockedReportIds.length} cross-school case(s): $blockedReportIds',
      );
      await _recordCrossSchoolAlert(
        path: path,
        blockedIds: blockedReportIds,
        expectedSchoolId: teacherSchoolId,
      );
    }

    return sanitized;
  }

  /// GET /api/bullying/cases/{report_id}/
  /// Detail satu laporan di sekolah staff
  Future<Map<String, dynamic>> getCaseDetail(int reportId) async {
    final headers = await auth.buildHeaders(asGuest: false);

    final resp = await apiClient.get<Map<String, dynamic>>(
      '/api/bullying/cases/$reportId/',
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: false, // Ignore envelope for cases
    );

    // Parse: {data: {...}} - langsung
    if (resp.data['data'] is Map) {
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

    final resp = await apiClient.get<dynamic>(
      '/api/bullying/report/$reportId/attachments/',
      headers: headers,
      transform: (raw) {
        if (raw is List) return raw;
        if (raw is Map && raw['results'] is List) return raw['results'];
        if (raw is Map && raw['data'] is List) return raw['data'];
        return <dynamic>[];
      },
      expectEnvelope: false,
    );

    print('[DEBUG] getCaseAttachments raw response: ${resp.data}');

    final attachmentList = (resp.data as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    print(
        '[DEBUG] getCaseAttachments returning ${attachmentList.length} items');
    return attachmentList;
  }

  /// PATCH /api/bullying/cases/{report_id}/status/
  /// Update status handling laporan
  /// For 'Ditolak' or 'Selesai', a non-empty [comment] is required.
  Future<void> updateCaseStatus(int reportId, String status, {String? comment}) async {
    final headers = await auth.buildHeaders(asGuest: false);

    // Enforce comment for Ditolak/Selesai
    final needsComment = status == 'Ditolak' || status == 'Selesai';
    if (needsComment) {
      final c = (comment ?? '').trim();
      if (c.isEmpty) {
        throw ApiException(
          code: 400,
          message: 'Komentar wajib diisi untuk status $status.',
        );
      }
    }

    final payload = <String, dynamic>{
      'status': status,
      if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
    };

    await apiClient.patch<Map<String, dynamic>>(
      '/api/bullying/cases/$reportId/status/',
      payload,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: false, // Ignore envelope for cases
    );
  }

  List<Map<String, dynamic>> _normalizeCaseList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      final results = raw['results'];
      if (results is List) {
        return results
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      final data = raw['data'];
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }
    debugPrint('[CASE_REPO] Unexpected cases payload shape: $raw');
    return const [];
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<void> _recordCrossSchoolAlert({
    required String path,
    required List<dynamic> blockedIds,
    required int expectedSchoolId,
  }) async {
    try {
      await session.saveLastAuthLog(
        method: 'GET',
        url: path,
        headers: {
          'warning': 'blocked_cross_school_cases',
          'expected_school_id': expectedSchoolId.toString(),
          'blocked_report_ids': blockedIds.map((e) => '$e').join(','),
          'blocked_count': blockedIds.length.toString(),
        },
      );
    } catch (e) {
      debugPrint('[CASE_REPO] Failed to persist isolation alert: $e');
    }
  }
}
