import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/components/note_card.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/pages/drawer.dart';
import 'package:tulisan_awak_app/state/app_state.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Note>>(
      converter: (store) => store.state.notes, // Get notes from the store
      builder: (context, notes) {
        final filteredNotes = notes.where((note) => note.isArsip).toList();
        stderr.writeln('notelist $notes');
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Open the drawer
                      },
                    );
                  },
                ),
                Text(
                  'Arsip Anda',
                  style: TextStyle(color: Colors.white),
                ),
              ]),
            ),
          ),
          drawer: DrawerPage(),
          body: notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 100, color: Colors.white70),
                      SizedBox(height: 20),
                      Text('Catatan yang Anda tambahkan muncul di sini'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return NoteCard(
                      note: note,
                      index: index,
                    );
                  },
                ),
        );
      },
    );
  }
}
