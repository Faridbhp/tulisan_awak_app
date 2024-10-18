import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tulisan_awak_app/components/note_card.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';

class GridCardStaggered extends StatelessWidget {
  final List<Note> allNotes; // Change to List<Note>
  final int gridCount;
  const GridCardStaggered(
      {super.key, required this.allNotes, required this.gridCount});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(scrollbars: false),
      child: MasonryGridView.builder(
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount, // Jumlah kolom
          ),
          mainAxisSpacing: 0, // Jarak antara item secara vertikal
          crossAxisSpacing: 8, // Jarak antara item secara horizontal
          itemCount: allNotes.length,
          itemBuilder: (context, index) {
            final note = allNotes[index];
            return NoteCard(
              note: note,
              index: index,
            );
          },
        ),
    );
  }
}
