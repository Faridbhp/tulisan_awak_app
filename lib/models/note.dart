// note.dart
class Note {
  final String title;
  final String content;
  final bool isArsip;

  Note({required this.title, required this.content, this.isArsip = false});

  @override
  String toString() {
    return 'Note{title: $title, content: $content, isArsip: $isArsip}';
  }
}
