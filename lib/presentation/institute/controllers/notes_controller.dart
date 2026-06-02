import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/note_model.dart';
import 'package:tuoora/data/repositories_impl/notes_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/api/api_exception.dart';

class NotesController extends GetxController {
  final NotesRepositoryImpl _notesRepository = Get.find<NotesRepositoryImpl>();

  final notesList = <Note>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final isBookmarkView = false.obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalItems = 0.obs;

  // Form controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final triedToSave = false.obs;

  final noteCategories = <NoteCategory>[].obs;
  final isCategoriesLoading = false.obs;
  final selectedCategoryName = RxnString();

  final selectedNote = Rxn<Note>();
  final editingNoteId = RxnInt();

  // Field errors
  final titleError = RxnString();
  final contentError = RxnString();
  final categoryError = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
    fetchNoteCategories();

    // Search debouncing
    debounce(
      searchQuery,
      (_) => fetchNotes(page: 1),
      time: const Duration(milliseconds: 500),
    );

    // Clear errors as user types
    titleController.addListener(() => _clearError(titleError));
    contentController.addListener(() => _clearError(contentError));
  }

  void _clearError(RxnString error) {
    if (triedToSave.value && error.value != null) {
      error.value = null;
    }
  }

  Future<void> fetchNoteCategories() async {
    try {
      isCategoriesLoading.value = true;
      final categories = await _notesRepository.getNoteCategories();
      noteCategories.assignAll(categories);
    } catch (e) {
      debugPrint('Error fetching note categories: $e');
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> fetchNotes({int page = 1}) async {
    try {
      if (page == 1) isLoading.value = true;

      final response = await _notesRepository.getNotes(
        page: page,
        isBookmarked: isBookmarkView.value ? true : null,
      );

      if (page == 1) {
        notesList.assignAll(response.data);
      } else {
        notesList.addAll(response.data);
      }

      currentPage.value = response.currentPage;
      lastPage.value = response.lastPage;
      totalItems.value = response.total;
    } catch (e) {
      AppSnackBar.error('Failed to load notes: $e');
    } finally {
      if (page == 1) isLoading.value = false;
    }
  }

  Future<void> loadMoreNotes() async {
    if (currentPage.value < lastPage.value && !isLoading.value) {
      await fetchNotes(page: currentPage.value + 1);
    }
  }

  List<Note> get filteredNotes {
    List<Note> filtered = notesList;

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query) ||
            note.category.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  void toggleBookmarkView() {
    isBookmarkView.value = !isBookmarkView.value;
    fetchNotes(page: 1);
  }

  void prepareForAdd() {
    editingNoteId.value = null;
    selectedNote.value = null;
    _clearForm();
  }

  void prepareForEdit(Note note) {
    editingNoteId.value = note.id;
    selectedNote.value = note;
    titleController.text = note.title;
    contentController.text = note.content;
    selectedCategoryName.value = note.category;
    triedToSave.value = false;
    _resetErrors();
  }

  void _clearForm() {
    titleController.clear();
    contentController.clear();
    selectedCategoryName.value = null;
    triedToSave.value = false;
    _resetErrors();
  }

  void _resetErrors() {
    titleError.value = null;
    contentError.value = null;
    categoryError.value = null;
  }

  Future<void> saveNote() async {
    triedToSave.value = true;
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      final noteData = {
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'category': selectedCategoryName.value,
      };

      if (editingNoteId.value != null) {
        await _notesRepository.updateNote(editingNoteId.value!, noteData);
        Get.back();
        AppSnackBar.success('Note updated successfully');
      } else {
        await _notesRepository.createNote(noteData);
        Get.back();
        AppSnackBar.success('Note created successfully');
      }

      fetchNotes(page: 1);
    } catch (e) {
      if (e is ValidationException) {
        _handleValidationErrors(e.errors);
        AppSnackBar.error(AppStrings.validationErrorsBelow);
      } else {
        AppSnackBar.error('Failed to save note: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _handleValidationErrors(Map<String, dynamic> errors) {
    if (errors.containsKey('title')) {
      titleError.value = (errors['title'] as List).first.toString();
    }
    if (errors.containsKey('content')) {
      contentError.value = (errors['content'] as List).first.toString();
    }
    if (errors.containsKey('category')) {
      categoryError.value = (errors['category'] as List).first.toString();
    }
  }

  bool _validateForm() {
    bool isValid = true;

    final tErr = ValidationUtils.validateRequired(
      titleController.text,
      'Title',
    );
    titleError.value = tErr;
    if (tErr != null) isValid = false;

    final cErr = ValidationUtils.validateRequired(
      contentController.text,
      'Content',
    );
    contentError.value = cErr;
    if (cErr != null) isValid = false;

    final catErr = ValidationUtils.validateCategorySelection(
      selectedCategoryName.value,
    );
    categoryError.value = catErr;
    if (catErr != null) isValid = false;

    return isValid;
  }

  Future<void> deleteNote(int id) async {
    try {
      isLoading.value = true;
      await _notesRepository.deleteNote(id);
      notesList.removeWhere((n) => n.id == id);
      AppSnackBar.success('Note deleted successfully');
    } catch (e) {
      AppSnackBar.error('Failed to delete note: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBookmark(Note note) async {
    try {
      final newStatus = !note.isBookmarked;
      await _notesRepository.toggleBookmark(note.id, newStatus);

      final index = notesList.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        // Use copyWith to preserve categoryRelation and other fields
        notesList[index] = note.copyWith(isBookmarked: newStatus);

        if (isBookmarkView.value && !newStatus) {
          notesList.removeAt(index);
        }
      }
    } catch (e) {
      AppSnackBar.error('Failed to update bookmark: $e');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
