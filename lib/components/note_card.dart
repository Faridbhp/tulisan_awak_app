import 'package:flutter/material.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';
import 'package:tulisan_awak_app/pages/note_page.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;

  const NoteCard({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    Color lingtOrDark =
        note.color != Colors.white ? Colors.white : Colors.black;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Mengatur sudut kartu
      ),
      color: note.color,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          // Navigate to NotePage with the note data
          Navigator.of(context).push(_createRoute(note));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Agar tinggi sesuai dengan konten
                  children: [
                    Text(
                      note.title,
                      maxLines: 2, // Batasi jumlah baris jika diperlukan
                      overflow: TextOverflow
                          .ellipsis, // Tambahkan elipsis jika terlalu panjang
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: lingtOrDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.content,
                      maxLines: 3, // Membolehkan teks lebih dari satu baris
                      overflow: TextOverflow.ellipsis, // Teks bisa meluap
                      style: TextStyle(
                        color: lingtOrDark,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (note.isPinned) ...[
                Transform.translate(
                  offset: Offset(10, -10), // Geser 5 piksel ke atas
                  child: Icon(
                    Icons.push_pin,
                    color: Colors.black,
                    size: 15,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Note note) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        NotePage(note: note),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
