import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/components/grid_card.dart';
import 'package:tulisan_awak_app/components/note_card.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';
import 'package:tulisan_awak_app/pages/drawer.dart';
import 'package:tulisan_awak_app/pages/note_page.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

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
      ),
      builder: (context, storeData) {
        ColorStore colorScheme =
            storeData.theme == 'Light' ? ColorStore.light : ColorStore.dark;
        Color lingtOrDark = colorScheme.backgroundColor;
        Color textColor = colorScheme.textColor;
        double fontSize = 18;

        switch (storeData.fontSize) {
          case "Extra Small":
            fontSize = 14;
            break;
          case "Big":
            fontSize = 22;
            break;
          default:
            fontSize = 18;
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
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: fontSize - 2,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer(); // Open the drawer
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          // Update search query
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: TextStyle(
                          color: Colors.white, fontSize: fontSize - 2),
                    ),
                  ),
                ],
              ),
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
                            fontSize: fontSize - 2,
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
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomAppBar(
              color: Colors.lightBlue,
            ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              color: lingtOrDark,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 20, top: 10),
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              onPressed: () {
                Navigator.of(context).push(_createRoute());
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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const NotePage(),
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
