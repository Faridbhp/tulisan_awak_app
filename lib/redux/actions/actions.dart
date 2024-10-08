// actions.dart
import 'package:tulisan_awak_app/redux/models/note.dart';

class AddNoteAction {
  final Note note;

  AddNoteAction(this.note);
}

class UpdateNoteAction {
  final Note updatedNote;

  UpdateNoteAction(this.updatedNote);
}

class DeleteNoteAction {
  final String keyData;

  DeleteNoteAction(this.keyData);
}

class ChangeThemeAction {
  final String theme;

  ChangeThemeAction(this.theme);
}

class ChangeFontSizeAction {
  final String fontSize;

  ChangeFontSizeAction(this.fontSize);
}
