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
    print('[CASE_REPO] getCases() called');
    
    // Verify teacher's school_id
    final teacherSchoolId = await session.loadUserSchoolId();
    final teacherUserId = await session.loadUserId();
    print('[CASE_REPO] Teacher context - userId: $teacherUserId, schoolId: $teacherSchoolId');
    
    if (teacherSchoolId == null) {
      print('[CASE_REPO] ⚠️ CRITICAL WARNING: Teacher school_id is NULL!');
      print('[CASE_REPO] ⚠️ Backend may return cases from ALL schools or fail!');
    }
    
    final headers = await auth.buildHeaders(asGuest: false);
    print('[CASE_REPO] Request headers keys: ${headers.keys.toList()}');
    
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

    print('[CASE_REPO] Request path: $path');

    final resp = await apiClient.get<Map<String, dynamic>>(
      path,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
      expectEnvelope: false, // Ignore envelope for cases
    );

    print('[CASE_REPO] Response received');
    print('[CASE_REPO] Response data type: ${resp.data.runtimeType}');
    print('[CASE_REPO] Response keys: ${resp.data is Map ? (resp.data as Map).keys.toList() : "Not a Map"}');

    // Parse: {results: [...]} - langsung tanpa wrapper 'data'
    if (resp.data['results'] is List) {
      final caseList = List<Map<String, dynamic>>.from(resp.data['results'] as List);
      print('[CASE_REPO] Parsed ${caseList.length} cases from results array');
      
      // CRITICAL: Check school_id in each case
      final schoolIdsInCases = <int>{};
      for (var i = 0; i < caseList.length; i++) {
        final caseData = caseList[i];
        final caseSchoolId = caseData['school_id'];
        final reportId = caseData['report_id'] ?? caseData['id'];
        
        if (caseSchoolId != null) {
          final schoolId = caseSchoolId is num 
              ? caseSchoolId.toInt() 
              : int.tryParse(caseSchoolId.toString());
          if (schoolId != null) {
            schoolIdsInCases.add(schoolId);
            if (schoolId != teacherSchoolId) {
              print('[CASE_REPO] ❌ CRITICAL: Case #$i (report_id: $reportId) has school_id: $schoolId');
              print('[CASE_REPO] ❌ But teacher school_id is: $teacherSchoolId');
              print('[CASE_REPO] ❌ THIS IS A CROSS-SCHOOL DATA LEAK!');
            } else {
              print('[CASE_REPO] ✅ Case #$i (report_id: $reportId) - school_id matches: $schoolId');
            }
          }
        } else {
          print('[CASE_REPO] ⚠️ Case #$i (report_id: $reportId) - school_id is NULL in response');
        }
      }
      
      if (schoolIdsInCases.length > 1) {
        print('[CASE_REPO] ❌ CRITICAL: Found cases from MULTIPLE schools: $schoolIdsInCases');
        print('[CASE_REPO] ❌ Backend filtering is NOT working correctly!');
      } else if (schoolIdsInCases.isNotEmpty && schoolIdsInCases.first != teacherSchoolId) {
        print('[CASE_REPO] ❌ CRITICAL: All cases are from wrong school!');
        print('[CASE_REPO] ❌ Cases school_id: ${schoolIdsInCases.first}, Teacher school_id: $teacherSchoolId');
      } else if (schoolIdsInCases.isEmpty) {
        print('[CASE_REPO] ⚠️ WARNING: No school_id found in any case - cannot verify filtering');
      } else {
        print('[CASE_REPO] ✅ All cases are from correct school: ${schoolIdsInCases.first}');
      }
      
      print('[CASE_REPO] Returning ${caseList.length} cases');
      return caseList;
    }

    print('[CASE_REPO] Response structure unexpected - returning empty list');
    print('[CASE_REPO] Raw response data: ${resp.data}');
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
    
    print('[DEBUG] getCaseAttachments returning ${attachmentList.length} items');
    return attachmentList;
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
      expectEnvelope: false, // Ignore envelope for cases
    );
  }
}

