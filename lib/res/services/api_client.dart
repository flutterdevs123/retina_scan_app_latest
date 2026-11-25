import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException; // Sirf mobile ke liye error catch karne ko

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:retina_scan_app/res/constants/api_config.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';

/// Error with a message that is safe to show to the user.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;

  /// HTTP status code (null or 0 for network errors).
  final int? statusCode;

  @override
  String toString() => message;
}

/// The only place that talks HTTP. Adds the token, decodes JSON and turns
/// every failure into an [ApiException].
class ApiClient extends GetxService {
  String? _token;

  /// Called on a 401 (expired token). Set by AuthService.
  void Function()? onUnauthorized;

  void setToken(String? token) => _token = token;

  /// Header needed by every protected endpoint (also for network images).
  Map<String, String> get authHeaders => _token == null
      ? const <String, String>{}
      : <String, String>{'Authorization': 'Bearer $_token'};

  /// Public getter taake Web wala service isay use kar sake
  String get baseUrl => ApiConfig.baseUrl;

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: query);

  Future<dynamic> get(String path, {Map<String, String>? query}) => _send(
    path,
        () => http.get(_uri(path, query), headers: authHeaders),
    ApiConfig.timeout,
  );

  Future<dynamic> post(
      String path, {
        Map<String, dynamic>? body,
      }) {
    return _send(
      path,
          () => http.post(
        _uri(path),
        headers: {
          ...authHeaders,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
      ApiConfig.timeout,
    );
  }

  Future<dynamic> delete(String path) => _send(
    path,
        () => http.delete(_uri(path), headers: authHeaders),
    ApiConfig.timeout,
  );

  /// Uploads one file (multipart/form-data) with extra text fields.
  /// NOTE: Yeh function sirf Mobile (Android/iOS) par kaam karta hai.
  /// Web ke liye `ScanAnalysisService` mein alag logic hai.
  Future<dynamic> postMultipart(
      String path, {
        required String fileField,
        required String filePath,
        Map<String, String> fields = const <String, String>{},
      }) {
    if (kIsWeb) {
      throw const ApiException('postMultipart is not supported on Web. Use bytes instead.');
    }
    return _send(path, () async {
      final http.MultipartRequest request =
      http.MultipartRequest('POST', _uri(path))
        ..headers.addAll(authHeaders)
        ..fields.addAll(fields);
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
      return http.Response.fromStream(await request.send());
    }, ApiConfig.uploadTimeout);
  }

  /// Finds a list inside a response that is either `[...]` or `{"items":[...]}`.
  static List<dynamic> listFrom(dynamic json, [List<String> keys = const <String>[]]) {
    if (json is List) return json;
    if (json is Map) {
      for (final String key in keys) {
        if (json[key] is List) return json[key] as List<dynamic>;
      }
      for (final dynamic value in json.values) {
        if (value is List) return value;
      }
    }
    return const <dynamic>[];
  }

  /// Yeh public methods Web wale `ScanAnalysisService` ko response parse karne mein madad karenge.
  dynamic decodeResponse(http.Response res) => _decode(res);

  String getErrorMessage(http.Response res) {
    final dynamic body = _decode(res);
    return _messageOf(body, res.statusCode);
  }

  Future<dynamic> _send(
      String path,
      Future<http.Response> Function() request,
      Duration timeout,
      ) async {
    try {
      final http.Response res = await request().timeout(timeout);
      final dynamic body = _decode(res);

      if (kDebugMode) {
        final String raw = utf8.decode(res.bodyBytes, allowMalformed: true);
        debugPrint('[API] ${res.statusCode} $path '
            '${raw.length > 700 ? raw.substring(0, 700) : raw}');
      }

      if (res.statusCode >= 200 && res.statusCode < 300) return body;

      if (res.statusCode == 401 && !path.contains('/auth/login')) {
        onUnauthorized?.call();
      }
      throw ApiException(_messageOf(body, res.statusCode),
          statusCode: res.statusCode);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      if (kDebugMode) debugPrint('[API ERROR] Timeout on $path');
      throw const ApiException(ApiStrings.errTimeout);
    } on SocketException catch (e) {
      // Exact network error (Connection refused, No route to host, etc.)
      final String details = e.osError?.message ?? e.message;
      if (kDebugMode) debugPrint('[API ERROR] SocketException on $path: $details');
      throw ApiException('Network Error: $details', statusCode: 0);
    } on http.ClientException catch (e) {
      if (kDebugMode) debugPrint('[API ERROR] ClientException on $path: ${e.message}');
      throw ApiException('Network Error: ${e.message}', statusCode: 0);
    } catch (e) {
      if (kDebugMode) debugPrint('[API ERROR] Unknown Error on $path: $e');
      throw ApiException('Unknown Error: $e', statusCode: 0);
    }
  }

  dynamic _decode(http.Response res) {
    if (res.bodyBytes.isEmpty) return null;
    final String text = utf8.decode(res.bodyBytes, allowMalformed: true);
    try {
      return jsonDecode(text);
    } catch (_) {
      return text;
    }
  }

  /// Reads FastAPI errors: {"detail": "text"} or {"detail": [{"msg": ..}]}.
  String _messageOf(dynamic body, int status) {
    if (body is Map && body['detail'] != null) {
      final dynamic detail = body['detail'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final dynamic first = detail.first;
        if (first is Map && first['msg'] != null) return '${first['msg']}';
      }
    }
    return ApiStrings.errServer(status);
  }
}