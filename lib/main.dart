// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tulisan_awak_app/local_storage/local_storage.dart';
import 'package:tulisan_awak_app/reducers/reducers.dart';
import 'package:tulisan_awak_app/state/app_state.dart';
import 'pages/home_page.dart';

void main() async {
  // Pastikan untuk menjalankan FlutterBinding sebelum menggunakan async
  WidgetsFlutterBinding.ensureInitialized();

  final store = Store<AppState>(appReducer,
      initialState: AppState(notes: await loadNotesFromLocalStorage()));

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
