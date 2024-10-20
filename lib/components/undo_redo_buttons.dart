import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tulisan_awak_app/function/get_color_scheme.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';

class UndoRedoButtons extends StatelessWidget {
  const UndoRedoButtons({
    super.key,
    required this.undoController,
  });

  final UndoHistoryController undoController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageStore>(
      converter: (store) => HomePageStore(
        store.state.notes,
        store.state.fontSize,
        store.state.theme,
        store.state.showGridCount,
      ),
      builder: (context, storeData) {
        final colorScheme = getColorScheme(context, storeData.theme);
        return ValueListenableBuilder<UndoHistoryValue>(
          valueListenable: undoController,
          builder: (_, value, __) {
            return Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.undo,
                      color:
                          value.canUndo ? colorScheme.iconColor : Colors.grey),
                  onPressed: value.canUndo
                      ? () => undoController.undo()
                      : null, // Disable button if cannot undo
                  tooltip: 'Undo', // Add tooltip
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.redo_rounded,
                    color: value.canRedo
                        ? colorScheme.iconColor
                        : Colors.grey, // Change color if disabled,
                  ),
                  onPressed: value.canRedo
                      ? () => undoController.redo()
                      : null, // Disable button if cannot redo
                  tooltip: 'Redo', // Add tooltip
                ),
              ],
            );
          },
        );
      },
    );
  }
}
