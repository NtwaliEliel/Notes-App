import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notes_provider.dart';
import '../../providers/auth_provider.dart';
import 'add_note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule fetchNotes to run after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      notesProvider.fetchNotes(authProvider.user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('NotesScreen build called');
    final notesProvider = Provider.of<NotesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          )
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notesProvider.notes.isEmpty) {
            return const Center(child: Text("Nothing here yet—tap ➕ to add a note."));
          }
          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return Card(
                child: ListTile(
                  title: Text(note.text),
                  subtitle: Text(note.createdAt.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AddNoteDialog(editingNote: note),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text("Are you sure?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await notesProvider.deleteNote(note.id, authProvider.user!.uid);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted")));
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (_) => const AddNoteDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
