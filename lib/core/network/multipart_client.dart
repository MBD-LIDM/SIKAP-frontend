import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_env.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'dart:convert';

class MultipartClient {
  final http.Client _client;
  MultipartClient({http.Client? client}) : _client = client ?? http.Client();

  Future<ApiResponse<dynamic>> uploadAttachments({
    required int reportId,
    required List<File> files,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse("${ApiEnv.baseUrl}/api/bullying/report/$reportId/attachments/");
    final req = http.MultipartRequest("POST", uri);
    if (headers != null) req.headers.addAll(headers);

    for (final f in files) {
      req.files.add(await http.MultipartFile.fromPath("files", f.path));
    }

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    final json = jsonDecode(resp.body);

    if (resp.statusCode >= 200 && resp.statusCode < 300 && json["success"] == true) {
      return ApiResponse(json["data"]);
    }
    throw ApiException(
      message: json is Map ? (json["message"] ?? "Upload gagal") : "Upload gagal",
      code: resp.statusCode,
      errors: json is Map ? json["errors"] : null,
    );
  }
}
