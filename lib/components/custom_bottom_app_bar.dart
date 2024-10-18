import 'package:flutter/material.dart';
import 'package:tulisan_awak_app/components/undo_redo_buttons.dart';

class CustomBottomAppBar extends StatefulWidget {
  final Color backgroundColor;
  final String formattedDate;
  final Color textColor;
  final Function onColorPickerPressed;
  final Function onImageSourcePressed;
  final UndoHistoryController undoController;

  const CustomBottomAppBar({
    super.key,
    required this.backgroundColor,
    required this.formattedDate,
    required this.textColor,
    required this.onColorPickerPressed,
    required this.onImageSourcePressed,
    required this.undoController,
  });

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  bool isShowUndoRedo = false;

  @override
  void initState() {
    super.initState();
    _loadListenerUndo();
  }

  void _loadListenerUndo() {
    widget.undoController.addListener(() {
      setState(() {
        isShowUndoRedo =
            true; // Show undo/redo buttons when there's a state change
      });
    });
  }

  @override
  void dispose() {
    widget.undoController.removeListener(() {
      setState(() {
        isShowUndoRedo = true; // Update this state
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: BottomAppBar(
        color: widget.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.palette_outlined,
                    color: widget.textColor,
                  ),
                  onPressed: () {
                    widget.onColorPickerPressed();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.image_search,
                    color: widget.textColor,
                  ),
                  onPressed: () async {
                    widget.onImageSourcePressed();
                  },
                ),
              ],
            ),
            // Centered text
            isShowUndoRedo
                ? UndoRedoButtons(undoController: widget.undoController)
                : Text(
                    'Diedit: ${widget.formattedDate}',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 16, // Adjust as necessary
                    ),
                  ),
            SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
