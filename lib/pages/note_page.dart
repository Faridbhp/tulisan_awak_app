import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/actions/actions.dart';
import 'package:tulisan_awak_app/components/alert_dialog.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/state/app_state.dart';
import 'package:uuid/uuid.dart';

class NotePage extends StatefulWidget {
  final Note? note;
  const NotePage({super.key, this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController titleController;
  late TextEditingController noteController;
  bool isArsip = false;
  bool isPinned = false;
  var uuid = Uuid().v4();
  String keyData = '';

  @override
  void initState() {
    super.initState();

    // Initialize TextEditingController with the data from widget.note if available
    titleController = TextEditingController(text: widget.note?.title ?? '');
    noteController = TextEditingController(text: widget.note?.content ?? '');
    isArsip = widget.note?.isArsip ?? false;
    isPinned = widget.note?.isPinned ?? false;
    keyData = widget.note?.keyData ?? Uuid().v4();
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveData() {
    final note = Note(
      keyData: keyData,
      title: titleController.text,
      content: noteController.text,
      isArsip: isArsip,
      isPinned: isPinned,
    );

    if (widget.note != null) {
      // Jika keyData ada, update catatan
      StoreProvider.of<AppState>(context).dispatch(UpdateNoteAction(note));
    } else {
      // Jika keyData tidak ada, tambahkan catatan baru
      StoreProvider.of<AppState>(context).dispatch(AddNoteAction(note));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    stderr.writeln('notess data $uuid');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: saveData,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isPinned = !isPinned;
              });
            },
          ),
          IconButton(
            icon: Icon(
              isArsip ? Icons.unarchive_outlined : Icons.archive_outlined,
              color: Colors.white,
            ),
            // Action for archive icon
            onPressed: () {
              setState(() {
                isArsip = !isArsip;
              });

              // Show dialog
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  });

                  return CustomAlertDialog(
                    title: isArsip ? "Berhasil!" : "Dibatalkan",
                    message: isArsip
                        ? "Catatan berhasil diarsipkan"
                        : "Pengarsipan catatan dibatalkan",
                    icon: isArsip ? Icons.check_circle : Icons.cancel,
                    iconColor: isArsip ? Colors.green : Colors.red,
                  );
                },
              );
            },
          ),
          if (widget.note != null) ...[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Dispatch aksi untuk menghapus catatan
                  StoreProvider.of<AppState>(context)
                      .dispatch(DeleteNoteAction(widget.note!.keyData));
                  Navigator.pop(context); // Tutup dialog setelah menghapus
                }),
          ]
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController, // Bind to titleController
                decoration: InputDecoration(
                  hintText: 'Judul', // Placeholder for title
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 28),
                ),
                style: TextStyle(fontSize: 28),
                maxLines: null, // Allow multiple lines
                textAlignVertical: TextAlignVertical.top, // Align text to the top
              ),
              SizedBox(height: 10),
              TextField(
                controller: noteController, // Bind to noteController
                decoration: InputDecoration(
                  hintText: 'Catatan', // Placeholder for note content
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 18),
                ),
                style: TextStyle(fontSize: 18),
                maxLines: null, // Allows multiple lines
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_box_outlined, color: Colors.white),
                    onPressed: () {
                      // Action for add icon
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.palette_outlined, color: Colors.white),
                    onPressed: () {
                      // Action for palette icon
                    },
                  ),
                ],
              ),
              Text('Diedit 11.46', style: TextStyle(color: Colors.white54)),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // Action for more options
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
