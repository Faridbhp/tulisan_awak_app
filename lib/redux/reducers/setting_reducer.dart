import 'package:tulisan_awak_app/local_storage/local_storage_setting.dart';
import 'package:tulisan_awak_app/redux/actions/setting_action.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

AppState settingReducer(AppState state, dynamic action) {
  if (action is ChangeThemeAction) {
    saveThemeToLocalStorage(action.theme); // Save theme to local storage
    return state.copyWith(theme: action.theme);
  } else if (action is ChangeFontSizeAction) {
    saveFontSizeToLocalStorage(
        action.fontSize); // Save fontSize to local storage
    return state.copyWith(fontSize: action.fontSize);
  } else if (action is ChangeGridViewAction) {
    saveShowGridCountToLocalStorage(action.showGridCount);
    return state.copyWith(showGridCount: action.showGridCount);
  }

  return state;
}
