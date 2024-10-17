import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/components/grid_card.dart';
import 'package:tulisan_awak_app/components/header.dart';
import 'package:tulisan_awak_app/components/note_card.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/pages/drawer.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageStore>(
      converter: (store) => HomePageStore(
        store.state.notes,
        store.state.fontSize,
        store.state.theme,
      ), // Get notes from the store
      builder: (context, storeData) {
        ColorStore colorScheme =
            storeData.theme == 'Light' ? ColorStore.light : ColorStore.dark;
        Color lingtOrDark = colorScheme.backgroundColor;
        Color textColor = colorScheme.textColor;
        FontStore fontSize;

        switch (storeData.fontSize) {
          case "Extra Small":
            fontSize = FontStore.exstraSmall;
            break;
          case "Big":
            fontSize = FontStore.big;
            break;
          default:
            fontSize = FontStore.small;
        }

        final filteredNotes =
            storeData.notes.where((note) => note.isArsip).toList();
        return Scaffold(
          backgroundColor: lingtOrDark,
          appBar: AppBar(
              backgroundColor: lingtOrDark,
              automaticallyImplyLeading: false,
              title: Header(
                searchColor: colorScheme.searchColor,
                textColor: textColor,
                fontSize: fontSize.fontHeader,
              )),
          drawer: DrawerPage(),
          body: filteredNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 80, color: textColor),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: Text(
                          'Arsip yang Anda tambahkan akan muncul di sini',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: fontSize.fontHeader,
                            color: textColor,
                          ),
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
              color: colorScheme.bottomColor,
            ),
          ),
        );
      },
    );
  }
}
