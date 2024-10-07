import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/components/grid_card.dart';
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
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10)),
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
                Expanded(
                  // Membungkus Text dalam Expanded
                  child: Text(
                    'Arsip',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
          ),
          drawer: DrawerPage(),
          body: filteredNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 80, color: Colors.black),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: Text(
                          'Arsip yang Anda tambahkan akan muncul di sini',
                          textAlign: TextAlign.center,
                          softWrap: true, // Memungkinkan teks membungkus
                        ),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth <= 500) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: ListView.builder(
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
                    } else if (constraints.maxWidth <= 700) {
                      return GridCard(
                        allNotes: filteredNotes,
                        gridCount: 2,
                      );
                    } else if (constraints.maxWidth <= 1000) {
                      return GridCard(
                        allNotes: filteredNotes,
                        gridCount: 3,
                      );
                    } else {
                      return GridCard(
                        allNotes: filteredNotes,
                        gridCount: 5,
                      );
                    }
                  },
                ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomAppBar(
              color: Colors.lightBlue,
            ),
          ),
        );
      },
    );
  }
}
