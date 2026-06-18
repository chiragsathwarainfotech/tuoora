import 'dart:io';

import 'package:tuoora/data/models/student_profile_model.dart';

abstract class StudentProfileRepositoryImpl {
  Future<StudentProfileModel> getProfile();
  Future<void> submitFeedback(Map<String, dynamic> data);
  Future<void> deleteAccount();
  Future<String> uploadAvatar(File file);
}
