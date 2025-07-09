import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notes_provider.dart';
import '../../providers/auth_provider.dart';
import '../../domain/note_model.dart';

class AddNoteDialog extends StatefulWidget {
  final Note? editingNote;
  const AddNoteDialog({super.key, this.editingNote});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.editingNote?.text ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return AlertDialog(
      title: Text(widget.editingNote != null ? "Edit Note" : "Add Note"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Enter your note"),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            final noteText = controller.text.trim();
            if (noteText.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Note cannot be empty")),
              );
              return;
            }
            if (widget.editingNote == null) {
              await notesProvider.addNote(noteText, authProvider.user!.uid);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note added")));
            } else {
              await notesProvider.updateNote(widget.editingNote!.id, noteText, authProvider.user!.uid);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note updated")));
            }
            Navigator.pop(context);
          },
          child: const Text("Save"),
        )
      ],
    );
  }
}
