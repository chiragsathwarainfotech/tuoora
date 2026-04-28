import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';

class StudentRepository implements StudentRepositoryImpl {
  final ApiClient _apiClient;

  StudentRepository(this._apiClient);

  @override
  Future<List<Student>> listStudents({String? search, int? page}) async {
    final Map<String, dynamic> query = {};
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }
    if (page != null) {
      query['page'] = page.toString();
    }

    final response = await _apiClient.get(
      ApiConstants.instituteStudents,
      query: query,
    );
    if (response.status.hasError) {
      throw Exception('Failed to load students: ${response.statusText}');
    }

    final Map<String, dynamic> body = response.body;
    final List<dynamic> items = body['data']?['items'] ?? [];
    return items.map((json) => Student.fromJson(json)).toList();
  }

  @override
  Future<Student> createStudent(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.instituteStudents,
      data,
    );
    if (response.status.hasError) {
      throw Exception('Failed to create student: ${response.statusText}');
    }
    return Student.fromJson(response.body['data']);
  }

  @override
  Future<Student> getStudentById(dynamic id) async {
    final response = await _apiClient.get(
      '${ApiConstants.instituteStudents}/$id',
    );
    if (response.status.hasError) {
      throw Exception('Failed to get student: ${response.statusText}');
    }
    return Student.fromJson(response.body['data']);
  }

  @override
  Future<Student> updateStudent(dynamic id, Map<String, dynamic> data) async {
    final response = await _apiClient.put(
      '${ApiConstants.instituteStudents}/$id',
      data,
    );
    if (response.status.hasError) {
      throw Exception('Failed to update student: ${response.statusText}');
    }
    return Student.fromJson(response.body['data']);
  }

  @override
  Future<bool> deleteStudent(dynamic id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.instituteStudents}/$id',
    );
    if (response.status.hasError) {
      throw Exception('Failed to delete student: ${response.statusText}');
    }
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
