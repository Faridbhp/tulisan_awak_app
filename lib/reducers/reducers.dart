// reducers.dart
import 'package:tulisan_awak_app/actions/actions.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is AddNoteAction) {
    // Tambah catatan baru
    return AppState(notes: List.from(state.notes)..add(action.note));
  } else if (action is UpdateNoteAction) {
    // Update catatan berdasarkan index
    List<Note> updatedNotes = List.from(state.notes);
    updatedNotes[action.index] = action.updatedNote;
    return AppState(notes: updatedNotes);
  } else if (action is DeleteNoteAction) {
    // Hapus catatan berdasarkan index
    List<Note> updatedNotes = List.from(state.notes);
    updatedNotes.removeAt(action.index);
    return AppState(notes: updatedNotes);
  }

  return state; // Return current state if no actions are handled
}
