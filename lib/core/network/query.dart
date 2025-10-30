import 'api_env.dart';

Uri buildUri(String base, Map<String, dynamic> params) {
  final filtered = Map<String, dynamic>.from(params)
    ..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

  final baseUri = Uri.parse(ApiEnv.baseUrl);
  final clean = base.startsWith('/') ? base.substring(1) : base;
  final basePath = baseUri.path.endsWith('/')
      ? baseUri.path
      : (baseUri.path.isEmpty ? '/' : '${baseUri.path}/');

  return baseUri.replace(
    path: '$basePath$clean',
    queryParameters: filtered.map((k, v) => MapEntry(k, '$v')),
  );
}
