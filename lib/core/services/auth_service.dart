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

  /// Latest known subscription summary (institute only). Reactive — read inside
  /// an Obx to rebuild when it changes (e.g. the dashboard renewal banner).
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
  }) async {
    _currentUser.value = user;
    _token.value = user.token;
    await _storage.write('user', user.toJson());
    await _storage.write('token', user.token);
    await _storage.write('stay_authenticated', stayAuthenticated);
    await _storage.write('logged_in', loggedIn);
    if (stayAuthenticated) {
      await _storage.write('remembered_email', email ?? user.email);
      if (password != null) {
        await _storage.write('remembered_password', password);
      }
    } else {
      await _storage.remove('remembered_email');
      await _storage.remove('remembered_password');
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

  String? get rememberedEmail => _storage.read('remembered_email');
  String? get rememberedPassword => _storage.read('remembered_password');

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
