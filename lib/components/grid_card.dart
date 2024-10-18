import 'package:flutter/material.dart';
import 'package:tulisan_awak_app/components/note_card.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';

class GridCard extends StatelessWidget {
  final List<Note> allNotes; // Change to List<Note>
  final int gridCount;
  const GridCard(
      {super.key,
      required this.allNotes,
      required this.gridCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(scrollbars: false),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount, // Contoh: tiga kartu per baris
            childAspectRatio: 1, // Atur aspek rasio sesuai kebutuhan
            crossAxisSpacing: 10, // Ruang antara kartu
          ),
          itemCount: allNotes.length, // Menggunakan panjang daftar allNotes
          itemBuilder: (context, index) {
            final note = allNotes[index]; // Ambil catatan berdasarkan index
            return NoteCard(
              note: note,
              index: index,
            );
          },
        ),
      ),
    );
  }
}
