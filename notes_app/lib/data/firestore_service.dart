import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/note_model.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<List<Note>> fetchNotes(String userId) async {
    final snapshot = await _db.collection('notes')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .get();

    return snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
  }

  Future<void> addNote(Note note, String userId) async {
    await _db.collection('notes').doc(note.id).set(note.toMap(userId));
  }

  Future<void> updateNote(Note note) async {
    await _db.collection('notes').doc(note.id).update({
      'text': note.text,
    });
  }

  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }
}
