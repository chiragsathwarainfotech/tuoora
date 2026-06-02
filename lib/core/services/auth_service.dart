import 'package:tuoora/data/models/user_model.dart';
import 'package:tuoora/data/models/subscription_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _currentUser = Rxn<User>();
  final _token = ''.obs;
  final _subscription = Rxn<Subscription>();

  User? get currentUser => _currentUser.value;
  String get token => _token.value;
  bool get isAuthenticated => _token.isNotEmpty;

  Subscription? get subscription => _subscription.value;

  Future<AuthService> init() async {
    await GetStorage.init();
    _loadSession();
    return this;
  }

  bool get shouldStayAuthenticated =>
      _storage.read('stay_authenticated') ?? false;
  bool get isLoggedIn => _storage.read('logged_in') ?? false;

  void _loadSession() {
    try {
      final userData = _storage.read('user');
      final savedToken = _storage.read('token');

      print('AuthService: Loading session. Token: $savedToken');

      if (userData != null && savedToken != null) {
        _token.value = savedToken;
        final role = userData['role'] ?? 'INSTITUTE';
        _currentUser.value = User.fromJson(userData, savedToken, role);
        final subData = _storage.read('subscription');
        if (subData != null) {
          _subscription.value = Subscription.fromJson(
            Map<String, dynamic>.from(subData),
          );
        }
        print('AuthService: Session loaded for role: $role');
      } else {
        print('AuthService: No session found.');
      }
    } catch (e) {
      print('AuthService: Error loading session: $e');
    }
  }

  Future<void> saveSession(
    User user, {
    bool stayAuthenticated = false,
    bool loggedIn = false,
    String? email,
    String? password,
    String? role,
  }) async {
    _currentUser.value = user;
    _token.value = user.token;
    await _storage.write('user', user.toJson());
    await _storage.write('token', user.token);
    await _storage.write('stay_authenticated', stayAuthenticated);
    await _storage.write('logged_in', loggedIn);

    // Remembered credentials are scoped per-role so the Institute login
    // screen never auto-fills a Student's email (and vice versa).
    final effectiveRole = role ?? user.role;
    final emailKey = _emailKey(effectiveRole);
    final passwordKey = _passwordKey(effectiveRole);
    if (stayAuthenticated) {
      await _storage.write(emailKey, email ?? user.email);
      if (password != null) {
        await _storage.write(passwordKey, password);
      } else {
        await _storage.remove(passwordKey);
      }
    } else {
      await _storage.remove(emailKey);
      await _storage.remove(passwordKey);
    }
  }

  Future<void> setSubscription(Subscription? subscription) async {
    _subscription.value = subscription;
    if (subscription == null) {
      await _storage.remove('subscription');
    } else {
      await _storage.write('subscription', subscription.toJson());
    }
  }

  /// Reads the remembered email saved for [role] (e.g. "INSTITUTE" /
  /// "STUDENT"). Returns null if the user never ticked Remember Me for
  /// that specific role.
  String? rememberedEmailFor(String role) => _storage.read(_emailKey(role));
  String? rememberedPasswordFor(String role) =>
      _storage.read(_passwordKey(role));

  String _emailKey(String role) => 'remembered_email_${role.toUpperCase()}';
  String _passwordKey(String role) =>
      'remembered_password_${role.toUpperCase()}';

  Future<void> clearSession() async {
    _currentUser.value = null;
    _token.value = '';
    _subscription.value = null;

    await _storage.remove('user');
    await _storage.remove('token');
    await _storage.remove('logged_in');
    await _storage.remove('subscription');

    print(
      'AuthService: Session cleared (user and token removed). Preferences preserved.',
    );
  }
}
