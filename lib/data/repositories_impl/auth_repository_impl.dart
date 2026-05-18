import 'package:tuoora/data/models/user_model.dart';

abstract class AuthRepositoryImpl {
  Future<User> loginInstitute(String email, String password);
  Future<User> loginStudent(String email, String password);
  Future<User> loginParent(String email, String password);
  
  // Forgot Password
  Future<String> forgotPassword(String email);
  Future<String> resetPassword(Map<String, dynamic> data);
}

