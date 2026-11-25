import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _onboardingKey = 'has_seen_onboarding'; // Naya Key

  final ApiClient _api = Get.find<ApiClient>();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  bool get isLoggedIn => currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _api.onUnauthorized = () {
      if (currentUser.value == null) return;
      _clearLocal();
      Get.offAllNamed(AppRoutes.login);
    };
  }

  /// Splash screen par check hoga
  Future<bool> restoreSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(_tokenKey);
    if (token == null) return false;

    _api.setToken(token);
    try {
      currentUser.value = await _fetchMe();
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 401) await prefs.remove(_tokenKey);
      _api.setToken(null);
      return false;
    }
  }

  // Onboarding check ke liye helper methods
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<UserModel> login({required String email, required String password}) async {
    final dynamic res = await _api.post(
      '/api/v1/auth/login',
      body: <String, dynamic>{'email': email, 'password': password},
    );

    final String? token = _tokenFrom(res);
    if (token == null) throw const ApiException(ApiStrings.errUnexpected);

    _api.setToken(token);
    try {
      final UserModel user = await _fetchMe();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token); // Save Token
      currentUser.value = user;
      return user;
    } catch (_) {
      _api.setToken(null);
      rethrow;
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String specialty = '',
  }) async {
    await _api.post(
      '/api/v1/auth/register',
      body: <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'role': role.name,
        'specialty': role == UserRole.doctor ? specialty : '',
      },
    );
    return login(email: email, password: password);
  }

  Future<void> logout() async {
    try {
      await _api.post('/api/v1/auth/logout');
    } catch (_) {}
    await _clearLocal();
  }

  Future<void> _clearLocal() async {
    _api.setToken(null);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    currentUser.value = null;
  }

  Future<UserModel> _fetchMe() async {
    final dynamic res = await _api.get('/api/v1/auth/me');
    if (res is! Map) throw const ApiException(ApiStrings.errUnexpected);
    try {
      return UserModel.fromJson(Map<String, dynamic>.from(res));
    } on FormatException {
      throw const ApiException(ApiStrings.errUnsupportedRole);
    }
  }

  String? _tokenFrom(dynamic res) {
    if (res is! Map) return null;
    for (final String key in <String>['access_token', 'token', 'jwt']) {
      if (res[key] is String) return res[key] as String;
    }
    if (res['data'] is Map) return _tokenFrom(res['data']);
    return null;
  }
}