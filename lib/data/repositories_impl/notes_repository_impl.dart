import 'package:fee_easy/data/models/note_model.dart';

class NotesRepositoryImpl {
  final List<Note> _mockNotes = [
    Note(
      id: '1',
      title: 'UI Design Principles',
      content: 'Remember to focus on hierarchy, typography, and color harmony in all web projects. Use consistent spacing and accessibility standards.',
      createdAt: 'Oct 24, 2023',
      isBookmarked: true,
      tag: 'DESIGN',
    ),
    Note(
      id: '2',
      title: 'Meeting Notes: Batch A',
      content: 'Discussed the upcoming final exams. Students requested more practice materials for Organic Chemistry.',
      createdAt: 'Oct 23, 2023',
      tag: 'ACADEMIC',
    ),
    Note(
      id: '3',
      title: 'Project Ideas',
      content: '1. Personal Finance Tracker\n2. AI Chatbot for Institutes\n3. Portfolio Website with 3D elements',
      createdAt: 'Oct 22, 2023',
      isBookmarked: true,
      tag: 'IDEAS',
    ),
    Note(
      id: '4',
      title: 'Quick Reminder',
      content: 'Check the attendance logs for last week and send reminders to parents of students with low attendance.',
      createdAt: 'Oct 21, 2023',
      tag: 'ADMIN',
    ),
  ];

  Future<List<Note>> getNotes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockNotes;
  }

  Future<void> createNote(Map<String, dynamic> noteData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: noteData['title'],
      content: noteData['content'],
      tag: noteData['tag'],
      createdAt: 'Oct 25, 2023',
      isBookmarked: false,
    );
    _mockNotes.insert(0, newNote);
  }

  Future<void> updateNote(String id, Map<String, dynamic> noteData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockNotes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotes[index] = _mockNotes[index].copyWith(
        title: noteData['title'],
        content: noteData['content'],
        tag: noteData['tag'],
        isBookmarked: noteData['is_bookmarked'],
      );
    }
  }

  Future<void> deleteNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockNotes.removeWhere((n) => n.id == id);
  }

  Future<void> toggleBookmark(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockNotes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotes[index] = _mockNotes[index].copyWith(
        isBookmarked: !_mockNotes[index].isBookmarked,
      );
    }
  }
}
