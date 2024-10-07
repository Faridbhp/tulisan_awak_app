// note.dart
class Note {
  final String keyData;
  final String title;
  final String content;
  final bool isArsip;
  final bool isPinned;
  final DateTime updateTime;

  Note(
      {required this.keyData,
      required this.title,
      required this.content,
      required this.updateTime,
      this.isArsip = false,
      this.isPinned = false});

  @override
  String toString() {
    return 'Note{key: $keyData, title: $title, content: $content, isArsip: $isArsip isPinned: $isPinned, updateTime: $updateTime}';
  }
}
