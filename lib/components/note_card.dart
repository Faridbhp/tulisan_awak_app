import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/actions/actions.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/pages/note_page.dart';
import 'package:tulisan_awak_app/state/app_state.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  const NoteCard({super.key, required this.note, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          // Navigate to NotePage with the note data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(
                note: note,
                noteIndex: index,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                // Dispatch aksi untuk menghapus catatan
                StoreProvider.of<AppState>(context)
                    .dispatch(DeleteNoteAction(index));
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
