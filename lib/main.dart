// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';
import 'package:tulisan_awak_app/redux/store/store.dart';
import 'pages/home_page.dart';

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
      child: StoreConnector<AppState, String>(
        converter: (store) => store.state.theme,
        builder: (context, theme) {
          ColorStore colorScheme =
              theme == 'Light' ? ColorStore.light : ColorStore.dark;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tulisan Awak',
            theme: ThemeData(
              // primarySwatch: Colors.blueGrey,
              scaffoldBackgroundColor: colorScheme.backgroundColor,
            ),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
