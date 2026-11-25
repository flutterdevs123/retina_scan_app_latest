import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // File type batane ke liye
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/services/api_client.dart';

/// Uploads a retina image to the AI model. The server saves it as a DRAFT
/// scan and returns the result immediately.
class ScanAnalysisService extends GetxService {
  final ApiClient _api = Get.find<ApiClient>();

  /// [source] is "camera" or "upload".
  Future<ReportModel> analyze(String imagePath, {String source = 'upload'}) async {
    // Web aur Mobile ke liye alag alag upload logic
    if (kIsWeb) {
      return _analyzeWeb(imagePath, source: source);
    } else {
      return _analyzeMobile(imagePath, source: source);
    }
  }

  /// Mobile (Android/iOS) ke liye purana tareeqa (Path se file uthana)
  Future<ReportModel> _analyzeMobile(String imagePath, {required String source}) async {
    final dynamic res = await _api.postMultipart(
      '/api/v1/scans/analyze',
      fileField: 'file',
      filePath: imagePath,
      fields: <String, String>{'source': source, 'eye': 'unknown'},
    );
    if (res is! Map) throw const ApiException(ApiStrings.errUnexpected);
    return ReportModel.fromJson(Map<String, dynamic>.from(res));
  }

  /// Web ke liye naya tareeqa (Bytes se file uthana)
  Future<ReportModel> _analyzeWeb(String blobUrl, {required String source}) async {
    // Web par image_picker ek Blob URL deta hai, usay fetch karke bytes mein badalna padta hai
    final http.Response imageResponse = await http.get(Uri.parse(blobUrl));
    final List<int> bytes = imageResponse.bodyBytes;

    // MultipartRequest manually banayenge
    final Uri uri = Uri.parse('${_api.baseUrl}/api/v1/scans/analyze');
    final http.MultipartRequest request = http.MultipartRequest('POST', uri);

    // Token add karein
    request.headers.addAll(_api.authHeaders);

    // Extra fields add karein
    request.fields.addAll({'source': source, 'eye': 'unknown'});

    // File ko Bytes se add karein (Web compatible)
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: 'retina_scan.jpg', // Web par filename zaroori hai
      contentType: MediaType('image', 'jpeg'),
    ));

    // Request send karein
    final http.StreamedResponse streamedResponse = await request.send();
    final http.Response response = await http.Response.fromStream(streamedResponse);

    // Response handle karein (ApiClient wala logic yahan manually apply karenge)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic body = _api.decodeResponse(response); // ApiClient mein helper banayenge
      if (body is! Map) throw const ApiException(ApiStrings.errUnexpected);
      return ReportModel.fromJson(Map<String, dynamic>.from(body));
    } else {
      // Agar error aaya toh ApiClient ka error message nikalne wala function call karein
      throw ApiException(_api.getErrorMessage(response), statusCode: response.statusCode);
    }
  }
}