import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/data/models/note_model.dart';

class NotesRepositoryImpl {
  final ApiClient _apiClient;

  NotesRepositoryImpl(this._apiClient);

  Future<NoteListResponse> getNotes({int page = 1, bool? isBookmarked}) async {
    final query = {
      'page': page.toString(),
      if (isBookmarked != null) 'is_bookmarked': isBookmarked.toString(),
    };

    final response = await _apiClient.get(
      ApiConstants.instituteNotes,
      query: query,
    );

    if (response.status.hasError) {
      throw Exception('Failed to fetch notes: ${response.statusText}');
    }

    return NoteListResponse.fromJson(response.body);
  }

  Future<List<NoteCategory>> getNoteCategories() async {
    final response = await _apiClient.get(ApiConstants.instituteNoteCategories);

    if (response.status.hasError) {
      throw Exception('Failed to fetch note categories: ${response.statusText}');
    }

    final List<dynamic> data = response.body['data'] ?? [];
    return data.map((json) => NoteCategory.fromJson(json)).toList();
  }

  Future<void> createNote(Map<String, dynamic> noteData) async {
    final response = await _apiClient.post(
      ApiConstants.instituteNotes,
      noteData,
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to create note';
      throw Exception(message);
    }
  }

  Future<void> updateNote(int id, Map<String, dynamic> noteData) async {
    final response = await _apiClient.put(
      '${ApiConstants.instituteNotes}/$id',
      noteData,
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to update note';
      throw Exception(message);
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.instituteNotes}/$id',
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to delete note';
      throw Exception(message);
    }
  }

  Future<void> toggleBookmark(int id, bool isBookmarked) async {
    final response = await _apiClient.post(
      '${ApiConstants.instituteNotes}/$id/bookmark',
      {'is_bookmarked': isBookmarked},
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to update bookmark';
      throw Exception(message);
    }
  }
}
