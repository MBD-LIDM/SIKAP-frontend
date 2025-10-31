import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sikap/core/network/api_client.dart';

void main() {
  test('POST merges headers without dropping X-Guest-Token', () async {
    late Map<String, String> captured;
    final client = MockClient((request) async {
      captured = request.headers;
      return http.Response(
        jsonEncode({'success': true, 'data': {}}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final api = ApiClient(httpClient: client);
    await api.post<Map<String, dynamic>>(
      '/api/test',
      {'ping': 'pong'},
      headers: {'X-Guest-Token': 'abc123'},
      expectEnvelope: false,
    );

    expect(captured['X-Guest-Token'], 'abc123');
    expect(captured['Accept'], 'application/json');
    expect(captured['Content-Type']?.startsWith('application/json'), isTrue);
  });
}
