import 'api_env.dart';

Uri buildUri(String base, Map<String, dynamic?> params) {
  final p = params..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
  final uri = Uri.parse("${ApiEnv.baseUrl}$base").replace(queryParameters: p.map((k, v) => MapEntry(k, "$v")));
  return uri;

  
}
