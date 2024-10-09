// note.dart
import 'dart:io';
import 'package:flutter/material.dart';

class Note {
  final String keyData;
  final String title;
  final String content;
  final bool isArsip;
  final bool isPinned;
  final DateTime updateTime;
  final Color color;
  final List<File> imageFiles;
  final List<String> imageBlobUrls;

  Note({
    required this.keyData,
    required this.title,
    required this.content,
    required this.updateTime,
    this.isArsip = false,
    this.isPinned = false,
    this.color = Colors.lightBlue,
    List<File>? imageFiles,
    List<String>? imageBlobUrls,
  })  : imageFiles = imageFiles ?? [],
        imageBlobUrls = imageBlobUrls ?? [];

  // CopyWith method
  Note copyWith({
    String? keyData,
    String? title,
    String? content,
    bool? isArsip,
    bool? isPinned,
    DateTime? updateTime,
    Color? color,
    List<File>? imageFiles,
    List<String>? imageBlobUrls,
  }) {
    return Note(
      keyData: keyData ?? this.keyData,
      title: title ?? this.title,
      content: content ?? this.content,
      updateTime: updateTime ?? this.updateTime,
      isArsip: isArsip ?? this.isArsip,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
      imageFiles: imageFiles ?? this.imageFiles,
      imageBlobUrls: imageBlobUrls ?? this.imageBlobUrls,
    );
  }

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
      'imageFiles': imageFiles
          .map((file) => file.path)
          .toList(), // Convert File to path string
      'imageBlobUrls': imageBlobUrls,
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
      imageFiles: (json['imageFiles'] as List<dynamic>)
          .map((filePath) => File(filePath as String))
          .toList(), // Convert path string back to File
      imageBlobUrls: List<String>.from(json['imageBlobUrls']),
    );
  }

  @override
  String toString() {
    return 'Note{key: $keyData, title: $title, content: $content, isArsip: $isArsip, isPinned: $isPinned, updateTime: $updateTime, color: $color, imageFiles: $imageFiles, imageBlobUrls: $imageBlobUrls}';
  }
}
