// actions.dart
import 'package:tulisan_awak_app/models/note.dart';

class AddNoteAction {
  final Note note;

  AddNoteAction(this.note);
}

class UpdateNoteAction {
  final Note updatedNote;
  final int index;

  UpdateNoteAction(this.updatedNote, this.index);
}

class DeleteNoteAction {
  final int index;

  DeleteNoteAction(this.index);
}