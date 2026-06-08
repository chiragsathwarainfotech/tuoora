import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/api/api_exception.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/note_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

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
      throw Exception(
        'Failed to fetch note categories: ${response.statusText}',
      );
    }

    final List<dynamic> data = response.body['data'] ?? [];
    return data.map((json) => NoteCategory.fromJson(json)).toList();
  }

  Future<void> createNote(dynamic noteData) async {
    final response = await _apiClient.post(
      ApiConstants.instituteNotes,
      noteData,
    );

    if (response.status.hasError) {
      _handleError(response, 'Failed to create note');
    }
  }

  Future<void> updateNote(int id, dynamic noteData) async {
    final isFormData = noteData is FormData;
    final response = await (isFormData ? _apiClient.post : _apiClient.put)(
      '${ApiConstants.instituteNotes}/$id',
      noteData,
    );

    if (response.status.hasError) {
      _handleError(response, 'Failed to update note');
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

  void _handleError(Response response, String defaultMessage) {
    if (response.statusCode == 422 && response.body?['errors'] != null) {
      throw ValidationException(response.body['errors']);
    }
    final message = response.body?['message'] ?? defaultMessage;
    throw Exception(message);
  }
}
