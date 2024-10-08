// reducers.dart
import 'package:tulisan_awak_app/actions/actions.dart';
import 'package:tulisan_awak_app/local_storage/local_storage.dart';
import 'package:tulisan_awak_app/models/note.dart';
import 'package:tulisan_awak_app/state/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is AddNoteAction) {
    // Tambah catatan baru
    List<Note> updatedNotes = List.from(state.notes)..add(action.note);
    saveNotesToLocalStorage(updatedNotes); // Simpan ke localStorage
    return AppState(notes: updatedNotes);
  } else if (action is UpdateNoteAction) {
    List<Note> updatedNotes = List.from(state.notes);

    // Temukan index berdasarkan keyData yang sesuai
    int noteIndex = updatedNotes
        .indexWhere((note) => note.keyData == action.updatedNote.keyData);

    if (noteIndex != -1) {
      // Jika ditemukan, update catatan
      updatedNotes[noteIndex] = action.updatedNote;
    }

    saveNotesToLocalStorage(updatedNotes); // Simpan ke localStorage
    return AppState(notes: updatedNotes);
  } else if (action is DeleteNoteAction) {
    // Salin daftar catatan
    List<Note> updatedNotes = List.from(state.notes);

    // Temukan index catatan yang cocok dengan keyData
    int noteIndex =
        updatedNotes.indexWhere((note) => note.keyData == action.keyData);

    if (noteIndex != -1) {
      // Jika ditemukan, hapus catatan
      updatedNotes.removeAt(noteIndex);
    }

    saveNotesToLocalStorage(updatedNotes); // Simpan ke localStorage
    return AppState(notes: updatedNotes);
  }

  return state; // Return current state if no actions are handled
}
