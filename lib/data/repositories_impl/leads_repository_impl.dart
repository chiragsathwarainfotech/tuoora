import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/core/api/api_exception.dart';
import 'package:tuoora/data/models/lead_model.dart';

class LeadsRepositoryImpl {
  final ApiClient _apiClient;

  LeadsRepositoryImpl(this._apiClient);

  Future<LeadListResponse> getLeads({int page = 1, String? search}) async {
    final query = {
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _apiClient.get(
      ApiConstants.instituteLeads,
      query: query,
    );

    if (response.status.hasError) {
      throw Exception('Failed to fetch leads: ${response.statusText}');
    }

    return LeadListResponse.fromJson(response.body);
  }

  Future<void> createLead(Map<String, dynamic> leadData) async {
    final response = await _apiClient.post(
      ApiConstants.instituteLeads,
      leadData,
    );

    if (response.status.hasError) {
      if (response.statusCode == 422 && response.body?['errors'] != null) {
        throw ValidationException(response.body['errors']);
      }
      final message = response.body?['message'] ?? 'Failed to create lead';
      throw Exception(message);
    }
  }

  Future<void> updateLead(int id, Map<String, dynamic> leadData) async {
    final response = await _apiClient.put(
      '${ApiConstants.instituteLeads}/$id',
      leadData,
    );

    if (response.status.hasError) {
      if (response.statusCode == 422 && response.body?['errors'] != null) {
        throw ValidationException(response.body['errors']);
      }
      final message = response.body?['message'] ?? 'Failed to update lead';
      throw Exception(message);
    }
  }

  Future<void> deleteLead(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.instituteLeads}/$id',
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to delete lead';
      throw Exception(message);
    }
  }

  Future<LeadNote> addLeadNote(int leadId, Map<String, dynamic> noteData) async {
    final response = await _apiClient.post(
      '${ApiConstants.instituteLeads}/$leadId/notes',
      noteData,
    );

    if (response.status.hasError) {
      if (response.statusCode == 422 && response.body?['errors'] != null) {
        throw ValidationException(response.body['errors']);
      }
      final message =
          response.body?['message'] ?? 'Failed to add interaction note';
      throw Exception(message);
    }

    return LeadNote.fromJson(response.body['data']);
  }
}

