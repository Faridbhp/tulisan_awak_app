// app_state.dart
import 'package:tulisan_awak_app/redux/models/note.dart';

class AppState {
  final List<Note> notes;
  final String theme;
  final String fontSize;
  final int showGridCount;

  AppState({
    this.notes = const [],
    this.theme = 'Light',
    this.fontSize = "Small",
    this.showGridCount = 1,
  });

  AppState copyWith({
    List<Note>? notes,
    String? theme,
    String? fontSize,
    int? showGridCount,
  }) {
    return AppState(
      notes: notes ?? this.notes, // Use new notes or keep the existing ones
      theme: theme ?? this.theme, // Use new theme or keep the existing one
      fontSize: fontSize ??
          this.fontSize, // Use new font size or keep the existing one
      showGridCount: showGridCount ?? this.showGridCount,
    );
  }
}
