import 'api_exception.dart';

T transformList<T>(dynamic json, T Function(List<dynamic>) mapper) {
  if (json is Map && json["results"] is List) return mapper(json["results"]);
  if (json is List) return mapper(json);
  throw ApiException(message: "Format list tidak dikenali");
}