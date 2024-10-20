import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/components/grid_card.dart';
import 'package:tulisan_awak_app/components/grid_card_staggered.dart';
import 'package:tulisan_awak_app/components/search_bar.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/actions/notes_actions.dart';
import 'package:tulisan_awak_app/redux/actions/setting_action.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/pages/drawer.dart';
import 'package:tulisan_awak_app/pages/note_page.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageStore>(
      converter: (store) => HomePageStore(
        store.state.notes,
        store.state.fontSize,
        store.state.theme,
        store.state.showGridCount,
      ),
      builder: (context, storeData) {
        ColorStore colorScheme =
            storeData.theme == 'Light' ? ColorStore.light : ColorStore.dark;
        Color lingtOrDark = colorScheme.backgroundColor;
        Color textColor = colorScheme.textColor;
        FontStore fontSize;
        int showGridCount = storeData.showGridCount;
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

        // cari data yang tidak di arsipkan
        final filterDataNotArsip =
            storeData.notes.where((note) => !note.isArsip).toList();
        // cari data yang di pin
        final pinnedNotes =
            filterDataNotArsip.where((note) => note.isPinned).toList();
        // cari data yang tidak di pin
        final unpinnedNotes =
            filterDataNotArsip.where((note) => !note.isPinned).toList();

        var allNotes = [
          ...pinnedNotes,
          ...unpinnedNotes
        ] // Gabungkan catatan yang dipinned dan tidak dipinned
            .where((note) =>
                note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                note.content.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList(); // filter data sesuai dengan query pencarian

        return Scaffold(
          backgroundColor: lingtOrDark,
          appBar: AppBar(
            backgroundColor: lingtOrDark,
            automaticallyImplyLeading: false,
            title: SearchBarCustom(
              backgroundColor: colorScheme.searchColor,
              textColor: textColor,
              fontSize: fontSize.fontHeader,
              gridCount: showGridCount,
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query
                });
              },
              onChangeGridCount: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(ChangeGridViewAction(showGridCount == 1 ? 2 : 1));
              },
            ),
          ),
          drawer: DrawerPage(),
          body: storeData.notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 80, color: textColor),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: Text(
                          'Catatan yang Anda tambahkan muncul di sini',
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
              : Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 25, right: 10, left: 10),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (constraints.maxWidth <= 500) {
                        return GridCardStaggered(
                          allNotes: allNotes,
                          gridCount: showGridCount,
                        );
                      } else if (constraints.maxWidth <= 700) {
                        return GridCard(
                          allNotes: allNotes,
                          gridCount: 2,
                        );
                      } else if (constraints.maxWidth <= 1000) {
                        return GridCard(
                          allNotes: allNotes,
                          gridCount: 3,
                        );
                      } else {
                        return GridCard(
                          allNotes: allNotes,
                          gridCount: 5,
                        );
                      }
                    },
                  ),
                ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              color: lingtOrDark,
              borderRadius: BorderRadius.circular(25),
            ),
            margin: EdgeInsets.only(right: 0, bottom: 30),
            child: FloatingActionButton(
              backgroundColor: colorScheme.buttonPlusColor,
              onPressed: () {
                String keyData = Uuid().v4();
                final note = Note(
                  keyData: keyData,
                  title: "",
                  content: "",
                  updateTime: DateTime.now(),
                );
                StoreProvider.of<AppState>(context)
                    .dispatch(AddNoteAction(note));
                Navigator.of(context).push(_createRoute(note));
              },
              child: Icon(Icons.add, color: colorScheme.iconColor),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
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
