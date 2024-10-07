import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:tulisan_awak_app/models/note.dart'; // For encoding/decoding JSON

// Fungsi untuk menyimpan catatan ke SharedPreferences
Future<void> saveNotesToLocalStorage(List<Note> notes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> notesJson = notes.map((note) => jsonEncode(note.toJson())).toList();
  await prefs.setStringList('notes', notesJson);
}

// Fungsi untuk mengambil catatan dari SharedPreferences
Future<List<Note>> loadNotesFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? notesJson = prefs.getStringList('notes');

  if (notesJson != null) {
    return notesJson.map((note) => Note.fromJson(jsonDecode(note))).toList();
  }

  return [];
}