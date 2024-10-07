import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/components/note_card.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/pages/drawer.dart';
import 'package:tulisan_awak_app/pages/note_page.dart';
import 'package:tulisan_awak_app/state/app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Note>>(
      converter: (store) => store.state.notes, // Get notes from the store
      builder: (context, notes) {
        final filteredNotes = notes.where((note) => !note.isArsip).toList();
        stderr.writeln('notelist $notes');
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
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
                    'Telusuri catatan Anda',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
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
          bottomNavigationBar: BottomAppBar(
            color: Colors.lightBlue,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.check_box_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.brush_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.mic_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.image_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 20),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotePage();
                  }),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
        );
      },
    );
  }
}
