// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tulisan_awak_app/local_storage/local_storage.dart';
import 'package:tulisan_awak_app/redux/reducers/reducers.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';
import 'pages/home_page.dart';

Future<Store<AppState>> createStore() async {
  final savedNotes = await loadNotesFromLocalStorage();
  final savedTheme = await loadThemeFromLocalStorage();
  final savedFontSize = await loadFontSizeFromLocalStorage();

  // Load other state, like notes
  final initialState = AppState(
    notes: savedNotes,
    theme: savedTheme,
    fontSize: savedFontSize,
  );

  return Store<AppState>(appReducer, initialState: initialState);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await createStore();

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tulisan Awak',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
