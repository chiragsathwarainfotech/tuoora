import 'package:fee_easy/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _currentUser = Rxn<User>();
  final _token = ''.obs;

  User? get currentUser => _currentUser.value;
  String get token => _token.value;
  bool get isAuthenticated => _token.isNotEmpty;

  Future<AuthService> init() async {
    await GetStorage.init();
    _loadSession();
    return this;
  }

  bool get shouldStayAuthenticated => _storage.read('stay_authenticated') ?? false;

  void _loadSession() {
    try {
      final userData = _storage.read('user');
      final savedToken = _storage.read('token');

      print('AuthService: Loading session. Token: $savedToken');

      if (userData != null && savedToken != null) {
        _token.value = savedToken;
        final role = userData['role'] ?? 'INSTITUTE';
        _currentUser.value = User.fromJson(userData, savedToken, role);
        print('AuthService: Session loaded for role: $role');
      } else {
        print('AuthService: No session found.');
      }
    } catch (e) {
      print('AuthService: Error loading session: $e');
    }
  }

  Future<void> saveSession(User user, {bool stayAuthenticated = false, String? email, String? password}) async {
    _currentUser.value = user;
    _token.value = user.token;
    await _storage.write('user', user.toJson());
    await _storage.write('token', user.token);
    await _storage.write('stay_authenticated', stayAuthenticated);
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

  String? get rememberedEmail => _storage.read('remembered_email');
  String? get rememberedPassword => _storage.read('remembered_password');

  Future<void> clearSession() async {
    _currentUser.value = null;
    _token.value = '';
    
    // Selectively remove session data, but preserve preferences like remembered_email
    await _storage.remove('user');
    await _storage.remove('token');
    
    print('AuthService: Session cleared (user and token removed). Preferences preserved.');
  }
}

