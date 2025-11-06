import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sikap/core/network/api_client.dart';
import 'package:sikap/core/network/auth_header_provider.dart';

import '../../scenarios/domain/models/scenario_models.dart';

/// Repository for scenarios. By default it loads scenarios from local asset
/// JSON (maintain existing behaviour). When an [ApiClient] is provided (or
/// created by default) it also exposes methods to interact with server
/// endpoints related to scenario reflections.
class ScenarioRepository {
  ScenarioRepository({
    this.assetPath = 'assets/data/scenarios_data.json',
    ApiClient? apiClient,
    AuthHeaderProvider? auth,
  })  : _apiClient = apiClient ?? ApiClient(),
        _auth = auth ?? AuthHeaderProvider();

  final String assetPath;
  final ApiClient _apiClient;
  final AuthHeaderProvider _auth;

  Future<List<ScenarioItem>> loadScenarios() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => ScenarioItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, List<ScenarioItem>>> loadByLevel() async {
    final scenarios = await loadScenarios();
    final Map<String, List<ScenarioItem>> grouped = {};
    for (final item in scenarios) {
      grouped.putIfAbsent(item.level, () => []).add(item);
    }
    return grouped;
  }

  // --------------------------- Network methods ---------------------------
  // Submit a reflection for a given scenario. The backend expects a JSON
  // body with a `reflection` field (object). Returns the newly created
  // reflection_id when available.
  Future<int?> submitReflection({
    required int scenarioId,
    required Map<String, dynamic> reflection,
    bool asGuest = true,
  }) async {
    print('[SCENARIO_REPO] submitReflection() called');
    print('[SCENARIO_REPO] scenarioId: $scenarioId, asGuest: $asGuest');
    print('[SCENARIO_REPO] reflection payload keys: ${reflection.keys.toList()}');
    
    final headers = await _auth.buildHeaders(asGuest: asGuest);
    final body = {'reflection': reflection};
    
    print('[SCENARIO_REPO] Request body structure: {reflection: {${reflection.keys.join(', ')}}}');
    
    final resp = await _apiClient.post<Map<String, dynamic>>(
      '/api/wellbeing/scenarios/$scenarioId/reflections/',
      body,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
    );
    
    print('[SCENARIO_REPO] submitReflection response - status: ${resp.status}');
    print('[SCENARIO_REPO] Response data keys: ${resp.data.keys.toList()}');
    
    // resp.data should be the object returned by backend for the created
    // reflection, e.g. {"reflection_id": 123}
    final data = resp.data;
    final reflectionId = data['reflection_id'] as int?;
    print('[SCENARIO_REPO] Extracted reflection_id: $reflectionId');
    
    return reflectionId;
  }

  // Get reflections submitted by current user/guest (requires auth headers).
  Future<List<dynamic>> getMyReflections({bool asGuest = true}) async {
    final headers = await _auth.buildHeaders(asGuest: asGuest);
    final resp = await _apiClient.get<dynamic>(
      '/api/wellbeing/scenarios/reflections/my/',
      headers: headers,
      transform: (raw) => raw,
      expectEnvelope: false,
    );

    final raw = resp.data;
    if (raw is Map<String, dynamic>) {
      if (raw['results'] is List) {
        return List<dynamic>.from(raw['results'] as List);
      }
      if (raw['data'] is List) {
        return List<dynamic>.from(raw['data'] as List);
      }
    } else if (raw is List) {
      return List<dynamic>.from(raw);
    }

    return [];
  }

  // Get reflections history for a given guest id (teacher/staff may use this
  // to view an individual student's history). This endpoint requires staff authentication.
  Future<List<dynamic>> getReflectionsHistory(int guestId) async {
    print('[SCENARIO_REPO] getReflectionsHistory() called for guestId: $guestId');
    
    // Use staff authentication explicitly (asGuest: false)
    final headers = await _auth.buildHeaders(asGuest: false);
    
    final resp = await _apiClient.get<List<dynamic>>(
      '/api/wellbeing/scenarios/reflections/history/$guestId/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    
    print('[SCENARIO_REPO] getReflectionsHistory response - status: ${resp.status}, count: ${resp.data.length}');
    return resp.data;
  }

  // For teacher/staff: list reflections within the school with optional filters.
  // Accepts optional scenarioId and optional date range (use UTC ISO strings).
  // Backend endpoint: /api/wellbeing/scenarios/reflections/school/
  Future<List<dynamic>> getSchoolReflections({
    String? scenarioId,
    DateTime? createdAtGte,
    DateTime? createdAtLte,
  }) async {
    print('[SCENARIO_REPO] getSchoolReflections() called');
    print('[SCENARIO_REPO] Parameters - scenarioId: $scenarioId, createdAtGte: $createdAtGte, createdAtLte: $createdAtLte');
    
    // Build query parameters - use double underscore format like bullying cases API
    final queryParams = <String, String>{};
    if (scenarioId != null && scenarioId.isNotEmpty) {
      queryParams['scenario_id'] = scenarioId;
    }
    if (createdAtGte != null) {
      queryParams['created_at__gte'] = createdAtGte.toUtc().toIso8601String();
    }
    if (createdAtLte != null) {
      queryParams['created_at__lte'] = createdAtLte.toUtc().toIso8601String();
    }
    
    // Build query string
    String path = '/api/wellbeing/scenarios/reflections/school/';
    if (queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      path = '$path?$query';
    }
    
    print('[SCENARIO_REPO] Request path: $path');
    print('[SCENARIO_REPO] Query params: $queryParams');
    
    // Use staff authentication explicitly (asGuest: false)
    final headers = await _auth.buildHeaders(asGuest: false);
    
    // Log authentication headers (mask sensitive data)
    print('[SCENARIO_REPO] Request headers keys: ${headers.keys.toList()}');
    if (headers.containsKey('Cookie')) {
      final cookieValue = headers['Cookie'] ?? '';
      final maskedCookie = cookieValue.length > 30
          ? '${cookieValue.substring(0, 15)}...${cookieValue.substring(cookieValue.length - 10)}'
          : '***';
      print('[SCENARIO_REPO] Cookie header: $maskedCookie');
    }
    if (headers.containsKey('X-CSRFToken')) {
      final csrfValue = headers['X-CSRFToken'] ?? '';
      final maskedCsrf = csrfValue.length > 20
          ? '${csrfValue.substring(0, 8)}...${csrfValue.substring(csrfValue.length - 4)}'
          : '***';
      print('[SCENARIO_REPO] X-CSRFToken header: $maskedCsrf');
    }
    if (headers.containsKey('X-Guest-Token')) {
      print('[SCENARIO_REPO] ⚠️ WARNING: X-Guest-Token found in staff request!');
    }
    
    // Use expectEnvelope: false to handle various response formats
    final resp = await _apiClient.get<dynamic>(
      path,
      headers: headers,
      transform: (raw) => raw,
      expectEnvelope: false,
    );
    
    print('[SCENARIO_REPO] Response received - status: ${resp.status}');
    print('[SCENARIO_REPO] Response data type: ${resp.data.runtimeType}');
    
    // Handle multiple response formats like cases API:
    // - {results: [...]} (paginated)
    // - [{...}, {...}] (plain list)
    // - {data: [...]} (enveloped list)
    final raw = resp.data;
    List<dynamic> reflectionList = [];
    
    if (raw is Map<String, dynamic>) {
      if (raw['results'] is List) {
        reflectionList = List<dynamic>.from(raw['results'] as List);
        print('[SCENARIO_REPO] Parsed ${reflectionList.length} reflections from results array (paginated)');
      } else if (raw['data'] is List) {
        reflectionList = List<dynamic>.from(raw['data'] as List);
        print('[SCENARIO_REPO] Parsed ${reflectionList.length} reflections from data field (enveloped)');
      } else {
        print('[SCENARIO_REPO] ⚠️ Response is Map but no results/data array found');
        print('[SCENARIO_REPO] Response keys: ${raw.keys.toList()}');
      }
    } else if (raw is List) {
      reflectionList = List<dynamic>.from(raw);
      print('[SCENARIO_REPO] Parsed ${reflectionList.length} reflections from direct array');
    } else {
      print('[SCENARIO_REPO] ⚠️ Unexpected response structure - returning empty list');
      print('[SCENARIO_REPO] Raw response data: $raw');
    }
    
    if (reflectionList.isNotEmpty && reflectionList.first is Map) {
      final firstItem = reflectionList.first as Map;
      print('[SCENARIO_REPO] First reflection item keys: ${firstItem.keys.toList()}');
    }
    
    print('[SCENARIO_REPO] Returning ${reflectionList.length} reflection(s)');
    return reflectionList;
  }
}
