import 'package:flutter/material.dart';
import '../domain/note_model.dart';
import '../data/firestore_service.dart';

class NotesProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Note> notes = [];
  bool isLoading = false;

  Future<void> fetchNotes(String userId) async {
    print('fetchNotes called');
    isLoading = true;
    notifyListeners();
    try {
      notes = await _firestoreService.fetchNotes(userId);
      print('Fetched notes: ${notes.length}');
    } catch (e) {
      notes = [];
      print('Error fetching notes: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      print('notifyListeners called');
    }
  }

  Future<void> addNote(String text, String userId) async {
    print('addNote called');
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );
    await _firestoreService.addNote(note, userId);
    await fetchNotes(userId);
    print('addNote finished');
  }

  Future<void> updateNote(String id, String text, String userId) async {
    final note = notes.firstWhere((n) => n.id == id);
    final updated = Note(id: id, text: text, createdAt: note.createdAt);
    await _firestoreService.updateNote(updated);
    await fetchNotes(userId);
  }

  Future<void> deleteNote(String id, String userId) async {
    await _firestoreService.deleteNote(id);
    await fetchNotes(userId);
  }
}
