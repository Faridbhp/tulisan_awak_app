import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/actions/actions.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/state/app_state.dart';

class NotePage extends StatefulWidget {
  final Note? note; // Receive Note object from HomePage
  final int? noteIndex;
  const NotePage({super.key, this.note, this.noteIndex});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController titleController;
  late TextEditingController noteController;
  bool isArsip = false;

  @override
  void initState() {
    super.initState();

    // Initialize TextEditingController with the data from widget.note if available
    titleController = TextEditingController(text: widget.note?.title ?? '');
    noteController = TextEditingController(text: widget.note?.content ?? '');
    isArsip = widget.note?.isArsip ?? false;
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            final note = Note(
              title: titleController.text,
              content: noteController.text,
              isArsip: isArsip
            );

            if (widget.noteIndex != null) {
              // Jika noteIndex ada, update catatan
              StoreProvider.of<AppState>(context)
                  .dispatch(UpdateNoteAction(note, widget.noteIndex!));
            } else {
              // Jika noteIndex tidak ada, tambahkan catatan baru
              StoreProvider.of<AppState>(context).dispatch(AddNoteAction(note));
            }

            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.push_pin_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // Action for pin icon
            },
          ),
          IconButton(
            icon: Icon(
              Icons.archive_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isArsip = !isArsip;
              });
              // Action for archive icon
            },
          ),
        ],
      ),
      body: Padding(
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
