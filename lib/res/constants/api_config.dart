/// Server settings. Change [baseUrl] when the server moves.
class ApiConfig {
  ApiConfig._();

  /// Phone and laptop must be on the same Wi-Fi for this address to work.
  static const String baseUrl = 'http://192.168.1.88:8000';

  /// Normal requests.
  static const Duration timeout = Duration(seconds: 30);

  /// Image upload + AI analysis can take longer.
  static const Duration uploadTimeout = Duration(seconds: 120);
}