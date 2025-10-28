import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../scenarios/domain/models/scenario_models.dart';

class ScenarioRepository {
  ScenarioRepository({this.assetPath = 'assets/data/scenarios_data.json'});

  final String assetPath;

  Future<List<ScenarioItem>> loadScenarios() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
    return list.map((e) => ScenarioItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, List<ScenarioItem>>> loadByLevel() async {
    final scenarios = await loadScenarios();
    final Map<String, List<ScenarioItem>> grouped = {};
    for (final item in scenarios) {
      grouped.putIfAbsent(item.level, () => []).add(item);
    }
    return grouped;
  }
}



