import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/function/get_color_scheme.dart';
import 'package:tulisan_awak_app/function/get_font_size.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';
import 'package:tulisan_awak_app/pages/note_page.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final int index;

  const NoteCard({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Settings>(
      converter: (store) => Settings(
        store.state.theme,
        store.state.fontSize,
      ),
      builder: (context, storeData) {
        final colorScheme =
            getColorScheme(context, storeData.theme, widget.note.color);
        FontStore fontSize = getFontStore(storeData.fontSize);
        Color lingtOrDark = widget.note.color == Colors.white
            ? colorScheme.backgroundColor
            : widget.note.color;
        Color textColor = colorScheme.textColor;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Mengatur sudut kartu
                side: BorderSide(color: colorScheme.sideColor)),
            color: isHovered ? colorScheme.hoverColor : lingtOrDark,
            margin: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: InkWell(
              onTap: () {
                // Navigate to NotePage with the note data
                Navigator.of(context).push(_createRoute(widget.note));
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
                        mainAxisSize: MainAxisSize
                            .min, // Agar tinggi sesuai dengan konten
                        children: [
                          Text(
                            widget.note.title,
                            maxLines: 2, // Batasi jumlah baris jika diperlukan
                            overflow: TextOverflow
                                .ellipsis, // Tambahkan elipsis jika terlalu panjang
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize.fontHeader,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.note.content,
                            maxLines:
                                3, // Membolehkan teks lebih dari satu baris
                            overflow: TextOverflow.ellipsis, // Teks bisa meluap
                            style: TextStyle(
                              color: textColor,
                              fontSize: fontSize.fontContent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.note.isPinned) ...[
                      Transform.translate(
                        offset: Offset(10, -10), // Geser 5 piksel ke atas
                        child: Icon(
                          Icons.push_pin,
                          color: textColor,
                          size: 15,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
