// note.dart
import 'package:flutter/material.dart';

class Note {
  final String keyData;
  final String title;
  final String content;
  final bool isArsip;
  final bool isPinned;
  final DateTime updateTime;
  final Color color;

  Note({
    required this.keyData,
    required this.title,
    required this.content,
    required this.updateTime,
    this.isArsip = false,
    this.isPinned = false,
    this.color = Colors.white,
  });

  // Method to convert Note object to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'keyData': keyData,
      'title': title,
      'content': content,
      'isArsip': isArsip,
      'isPinned': isPinned,
      'updateTime': updateTime.toIso8601String(),
      'color': color.value,
    };
  }

  // Method to convert JSON (Map) to Note object
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      keyData: json['keyData'],
      title: json['title'],
      content: json['content'],
      isArsip: json['isArsip'],
      isPinned: json['isPinned'],
      updateTime: DateTime.parse(json['updateTime']),
      color: Color(json['color']),
    );
  }

  @override
  String toString() {
    return 'Note{key: $keyData, title: $title, content: $content, isArsip: $isArsip isPinned: $isPinned, updateTime: $updateTime, color: $color}';
  }
}
