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
    final headers = await _auth.buildHeaders(asGuest: asGuest);
    final body = {'reflection': reflection};
    final resp = await _apiClient.post<Map<String, dynamic>>(
      '/api/wellbeing/scenarios/$scenarioId/reflections/',
      body,
      headers: headers,
      transform: (raw) => raw as Map<String, dynamic>,
    );
    // resp.data should be the object returned by backend for the created
    // reflection, e.g. {"reflection_id": 123}
    final data = resp.data;
    return data['reflection_id'] as int?;
  }

  // Get reflections submitted by current user/guest (requires auth headers).
  Future<List<dynamic>> getMyReflections({bool asGuest = true}) async {
    final headers = await _auth.buildHeaders(asGuest: asGuest);
    final resp = await _apiClient.get<List<dynamic>>(
      '/api/wellbeing/scenarios/reflections/my/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return resp.data;
  }

  // Get reflections history for a given guest id (teacher/staff may use this
  // to view an individual student's history). This endpoint may require
  // authentication depending on backend rules; we leave headers built by auth.
  Future<List<dynamic>> getReflectionsHistory(int guestId) async {
    final headers = await _auth.buildHeaders();
    final resp = await _apiClient.get<List<dynamic>>(
      '/api/wellbeing/scenarios/reflections/history/$guestId/',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return resp.data;
  }

  // For teacher/staff: list reflections within the school with optional filters.
  // Accepts optional scenarioId and optional date range (use UTC ISO strings).
  Future<List<dynamic>> getSchoolReflections({
    String? scenarioId,
    DateTime? createdAtGte,
    DateTime? createdAtLte,
  }) async {
    final params = <String>[];
    if (scenarioId != null && scenarioId.isNotEmpty)
      params.add('scenario_id=$scenarioId');
    if (createdAtGte != null)
      params.add(
          'created_at_gte=${Uri.encodeComponent(createdAtGte.toUtc().toIso8601String())}');
    if (createdAtLte != null)
      params.add(
          'created_at_lte=${Uri.encodeComponent(createdAtLte.toUtc().toIso8601String())}');
    final q = params.isNotEmpty ? '?${params.join('&')}' : '';
    final headers = await _auth.buildHeaders();
    final resp = await _apiClient.get<List<dynamic>>(
      '/api/wellbeing/scenarios/reflections/school/$q',
      headers: headers,
      transform: (raw) => raw as List<dynamic>,
    );
    return resp.data;
  }
}
