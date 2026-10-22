import 'dart:async';
import '../data/api_client.dart';
import '../data/app_repository.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_controller.dart';

class SupabaseLoginController extends LoginController {
  SupabaseLoginController({required SupabaseClient client, required Uri apiBaseUrl,
    required this.redirectUrl, http.Client? httpClient})
      : _client = client {
    api = ApiClient(baseUrl: apiBaseUrl, userId: () => userId,
      accessToken: () => _client.auth.currentSession?.accessToken,
      refreshSession: () async { await _client.auth.refreshSession(); }, client: httpClient);
    repository = AppRepository(api);
    _subscription = _client.auth.onAuthStateChange.listen((_) {
      _authError = false;
      if (!_disposed) notifyListeners();
    }, onError: (Object error) {
      _authError = true;
      if (!_disposed) notifyListeners();
    });
  }

  final SupabaseClient _client;
  late final ApiClient api;
  @override
  late final AppRepository repository;
  final String redirectUrl;
  late final StreamSubscription<AuthState> _subscription;
  bool _disposed = false;
  bool _authError = false;

  @override
  bool get hasSession => _client.auth.currentSession != null;
  @override
  String? get userId => _client.auth.currentUser?.id;
  @override
  bool get hasAuthError => _authError;

  @override
  Future<void> signInWithGoogle() async {
    _authError = false;
    final launched = await _client.auth.signInWithOAuth(OAuthProvider.google,
      redirectTo: redirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
      queryParams: const {'prompt': 'select_account'},
    );
    if (!launched) throw const LoginFailure();
  }

  @override
  Future<LoginProfile> loadProfile() async {
    final id = userId;
    if (id == null) throw const LoginFailure();
    // Startup restores local credentials before the SDK's asynchronous refresh.
    // Waiting here keeps an expired access token away from the private API.
    if (_client.auth.currentSession?.isExpired ?? false) {
      await _client.auth.refreshSession();
      if (userId != id) throw const LoginFailure();
    }
    final profile = LoginProfile.fromJson(await api.request('GET', '/v1/me') as Map<String, dynamic>);
    if (profile.id != id || userId != id) throw const LoginFailure();
    return profile;
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut(scope: SignOutScope.local);
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription.cancel());
    api.close();
    super.dispose();
  }
}
