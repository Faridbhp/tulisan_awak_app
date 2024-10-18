import 'package:flutter/material.dart';

class UndoRedoButtons extends StatelessWidget {
  const UndoRedoButtons({
    super.key,
    required this.undoController,
  });

  final UndoHistoryController undoController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UndoHistoryValue>(
      valueListenable: undoController,
      builder: (_, value, __) {
        return Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.undo),
              onPressed: value.canUndo
                  ? () => undoController.undo()
                  : null, // Disable button if cannot undo
              tooltip: 'Undo', // Add tooltip
              color: value.canUndo ? null : Colors.grey, // Change color if disabled
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.redo_rounded),
              onPressed: value.canRedo
                  ? () => undoController.redo()
                  : null, // Disable button if cannot redo
              tooltip: 'Redo', // Add tooltip
              color: value.canRedo ? null : Colors.grey, // Change color if disabled
            ),
          ],
        );
      },
    );
  }
}
