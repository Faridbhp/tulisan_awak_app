// actions.dart
import 'package:tulisan_awak_app/models/note.dart';

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
