import 'package:redux/redux.dart';
import 'package:tulisan_awak_app/local_storage/local_storage.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';
import 'package:tulisan_awak_app/redux/reducers/reducers.dart'; 

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
