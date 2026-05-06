import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/data/models/note_model.dart';
import 'package:fee_easy/data/repositories_impl/notes_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesController extends GetxController {
  final NotesRepositoryImpl _notesRepository = Get.find<NotesRepositoryImpl>();

  final notesList = <Note>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final isBookmarkView = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final triedToSave = false.obs;

  final availableTags = ['PERSONAL', 'WORK', 'FAMILY', 'IMPORTANT', 'TODO'].obs;
  final selectedTag = RxnString();

  final selectedNote = Rxn<Note>();
  final editingNoteId = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      isLoading.value = true;
      final notes = await _notesRepository.getNotes();
      notesList.assignAll(notes);
    } catch (e) {
      AppSnackbar.error('Failed to load notes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Note> get filteredNotes {
    List<Note> filtered = notesList;

    if (isBookmarkView.value) {
      filtered = filtered.where((n) => n.isBookmarked).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query) ||
            (note.tag?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  void toggleBookmarkView() {
    isBookmarkView.value = !isBookmarkView.value;
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
    selectedTag.value = note.tag;
    triedToSave.value = false;
  }

  void _clearForm() {
    titleController.clear();
    contentController.clear();
    selectedTag.value = null;
    triedToSave.value = false;
  }

  Future<void> saveNote() async {
    triedToSave.value = true;
    if (titleController.text.trim().isEmpty) return;

    try {
      isLoading.value = true;
      final noteData = {
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'tag': selectedTag.value,
        'is_bookmarked': selectedNote.value?.isBookmarked ?? false,
      };

      if (editingNoteId.value != null) {
        await _notesRepository.updateNote(editingNoteId.value!, noteData);
        AppSnackbar.success('Note updated successfully');
      } else {
        await _notesRepository.createNote(noteData);
        AppSnackbar.success('Note created successfully');
      }

      fetchNotes();
      Get.back();
    } catch (e) {
      AppSnackbar.error('Failed to save note: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesRepository.deleteNote(id);
      notesList.removeWhere((n) => n.id == id);
      AppSnackbar.success('Note deleted successfully');
    } catch (e) {
      AppSnackbar.error('Failed to delete note: $e');
    }
  }

  Future<void> toggleBookmark(Note note) async {
    try {
      await _notesRepository.toggleBookmark(note.id);
      final index = notesList.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        notesList[index] = notesList[index].copyWith(
          isBookmarked: !notesList[index].isBookmarked,
        );
      }
    } catch (e) {
      AppSnackbar.error('Failed to update bookmark: $e');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
