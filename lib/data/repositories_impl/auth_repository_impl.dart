import 'package:fee_easy/data/models/user_model.dart';

abstract class AuthRepositoryImpl {
  Future<User> loginInstitute(String email, String password);
  Future<User> loginStudent(String email, String password);
  Future<User> loginParent(String email, String password);
  Future<User> getInstituteProfile();
}
