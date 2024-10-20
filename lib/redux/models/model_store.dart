// settings.dart
import 'package:tulisan_awak_app/redux/models/note.dart';

class Settings {
  final String theme;
  final String fontSize;

  Settings(this.theme, this.fontSize);
}

class HomePageStore {
  final List<Note> notes;
  final String theme;
  final String fontSize;
  final int showGridCount;

  HomePageStore(
    this.notes,
    this.fontSize,
    this.theme,
    this.showGridCount,
  );
}
