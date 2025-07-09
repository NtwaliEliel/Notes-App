import 'package:flutter/material.dart';
import '../domain/note_model.dart';
import '../data/firestore_service.dart';

class NotesProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Note> notes = [];
  bool isLoading = false;

  Future<void> fetchNotes(String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      notes = await _firestoreService.fetchNotes(userId);
    } catch (e) {
      notes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String text, String userId) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );
    await _firestoreService.addNote(note, userId);
    await fetchNotes(userId);
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
