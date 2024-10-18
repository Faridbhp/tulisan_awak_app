// reducers.dart
import 'package:redux/redux.dart';
import 'package:tulisan_awak_app/redux/reducers/notes_reducer.dart';
import 'package:tulisan_awak_app/redux/reducers/setting_reducer.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

final appReducer = combineReducers<AppState>([
  notesReducer, // Menggunakan notesReducer
  settingReducer, // Menggunakan settingReducer
]);
