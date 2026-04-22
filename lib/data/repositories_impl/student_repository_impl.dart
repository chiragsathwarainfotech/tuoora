import 'package:fee_easy/data/models/student_model.dart';

abstract class StudentRepositoryImpl {
  Future<List<Student>> listStudents();
  Future<Student> createStudent(Map<String, dynamic> data);
  Future<Student> getStudentById(String id);
  Future<Student> updateStudent(String id, Map<String, dynamic> data);
  Future<bool> deleteStudent(String id);
}
