// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:tulisan_awak_app/redux/models/note.dart'; // For encoding/decoding JSON

// Fungsi untuk menyimpan catatan ke SharedPreferences
Future<void> saveNotesToLocalStorage(List<Note> notes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> notesJson =
      notes.map((note) => jsonEncode(note.toJson())).toList();
  await prefs.setStringList('notes', notesJson);
}

// Fungsi untuk mengambil catatan dari SharedPreferences
Future<List<Note>> loadNotesFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? notesJson = prefs.getStringList('notes');

  if (notesJson != null) {
    try {
      // Attempt to decode each note JSON, handling errors gracefully
      return notesJson
          .map((note) {
            try {
              return Note.fromJson(
                  jsonDecode(note)); // Decode JSON and convert to Note
            } catch (e) {
              print("Error decoding note: $e");
              return []; // Return empty list if there's an issue decoding a note
            }
          })
          .whereType<Note>()
          .toList(); // Filter out nulls
    } catch (e) {
      print("Error loading notes from SharedPreferences: $e");
      return []; // Return empty list
    }
  }

  return []; // Return an empty list if no notes found or if there's an error
}
