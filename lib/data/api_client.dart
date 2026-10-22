import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFailure implements Exception {
  const ApiFailure(this.status, [this.code]);
  final int status;
  final String? code;
}

/// Transport autenticado compartilhado. Nunca registra tokens ou dados privados.
class ApiClient {
  ApiClient({required this.baseUrl, required this.accessToken,
    required this.refreshSession, required this.userId, http.Client? client,
    this.readTimeout = const Duration(seconds: 30),
    this.writeTimeout = const Duration(seconds: 15)}) : _client = client ?? http.Client();
  final String? Function() userId;
  final Uri baseUrl;
  final String? Function() accessToken;
  final Future<void> Function() refreshSession;
  final http.Client _client;
  final Duration readTimeout;
  final Duration writeTimeout;

  Future<dynamic> request(String method, String path, {Map<String, String>? query, Object? body}) async {
    final owner = userId();
    if (owner == null) throw const ApiFailure(401);
    final read = method == 'GET';
    var refreshed = false;
    var transientFailures = 0;
    while (true) {
      if (userId() != owner) throw const ApiFailure(401);
      final token = accessToken();
      if (token == null) throw const ApiFailure(401);
      final uri = baseUrl.resolve(path).replace(queryParameters: query);
      final request = http.Request(method, uri)..headers.addAll({
        'Authorization': 'Bearer $token', 'Accept': 'application/json',
        if (body != null) 'Content-Type': 'application/json',
      });
      if (body != null) request.body = jsonEncode(body);
      late http.Response response;
      try {
        response = await _send(request).timeout(read ? readTimeout : writeTimeout);
      } on TimeoutException {
        if (read && ++transientFailures < 3) continue;
        rethrow;
      } on http.ClientException {
        if (read && ++transientFailures < 3) continue;
        rethrow;
      }
      if (userId() != owner) throw const ApiFailure(401);
      if (read && const [502, 503, 504].contains(response.statusCode) && ++transientFailures < 3) {
        await Future<void>.delayed(Duration(milliseconds: 500 * transientFailures));
        continue;
      }
      if (response.statusCode == 401 && !refreshed) {
        refreshed = true;
        await refreshSession();
        continue;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        String? code;
        try { code = (jsonDecode(response.body) as Map<String, dynamic>)['code'] as String?; }
        catch (_) { /* Authentication errors may not have a JSON body. */ }
        throw ApiFailure(response.statusCode, code);
      }
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }
  }

  Future<http.Response> _send(http.Request request) async =>
    http.Response.fromStream(await _client.send(request));

  void close() => _client.close();
}
