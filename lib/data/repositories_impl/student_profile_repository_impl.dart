import 'dart:io';

import 'package:tuoora/data/models/student_profile_model.dart';

abstract class StudentProfileRepositoryImpl {
  Future<StudentProfileModel> getProfile();
  Future<void> submitFeedback(Map<String, dynamic> data);

  /// Uploads [file] as the student's avatar via multipart/form-data
  /// (field name: `avatar`). Returns the new `avatar_url` from the
  /// response body.
  Future<String> uploadAvatar(File file);
}
