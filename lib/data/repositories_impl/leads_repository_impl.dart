import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/data/models/lead_model.dart';

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
}
