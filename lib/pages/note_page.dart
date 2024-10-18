// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tulisan_awak_app/components/color_picker.dart';
import 'package:tulisan_awak_app/components/custom_bottom_app_bar.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/actions/notes_actions.dart';
import 'package:tulisan_awak_app/components/alert_dialog.dart';
import 'package:tulisan_awak_app/redux/models/model_store.dart';
import 'package:tulisan_awak_app/redux/models/note.dart';
import 'package:tulisan_awak_app/redux/state/app_state.dart';
import 'package:uuid/uuid.dart';

class NotePage extends StatefulWidget {
  final Note? note;
  const NotePage({super.key, this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController titleController;
  late TextEditingController noteController;
  final UndoHistoryController _undoNoteController = UndoHistoryController();
  bool isArsip = false;
  bool isPinned = false;
  var uuid = Uuid().v4();
  String keyData = '';
  DateTime dateTimeNow = DateTime.now();
  // Format tanggal dan waktu
  String formattedDate = "";
  Color selectedColor = Colors.white;
  late List<File?> _imageFiles = [];
  late List<String?> _imageBlobUrls = [];

  @override
  void initState() {
    super.initState();

    // Initialize TextEditingController with the data from widget.note if available
    titleController = TextEditingController(text: widget.note?.title ?? '');
    noteController = TextEditingController(text: widget.note?.content ?? '');
    isArsip = widget.note?.isArsip ?? false;
    isPinned = widget.note?.isPinned ?? false;
    keyData = widget.note?.keyData ?? Uuid().v4();
    formattedDate = DateFormat('dd MMM yyyy HH:mm')
        .format(widget.note?.updateTime ?? DateTime.now());
    selectedColor = widget.note?.color ?? Colors.white;
    _imageBlobUrls = widget.note?.imageBlobUrls ?? [];
    _imageFiles = widget.note?.imageFiles ?? [];
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    titleController.dispose();
    noteController.dispose();
    _undoNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageStore>(
      converter: (store) => HomePageStore(
        store.state.notes,
        store.state.fontSize,
        store.state.theme,
      ),
      builder: (context, storeData) {
        ColorStore colorScheme =
            (selectedColor == Colors.white) && (storeData.theme == 'Light')
                ? ColorStore.light
                : ColorStore.dark;
        Color lingtOrDark = selectedColor == Colors.white
            ? colorScheme.backgroundColor
            : selectedColor;
        Color textColor = colorScheme.textColor;

        FontStore fontSize;

        switch (storeData.fontSize) {
          case "Extra Small":
            fontSize = FontStore.exstraSmall;
            break;
          case "Big":
            fontSize = FontStore.big;
            break;
          default:
            fontSize = FontStore.small;
        }

        return Scaffold(
          backgroundColor: lingtOrDark,
          appBar: AppBar(
            backgroundColor: lingtOrDark,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
              ),
              onPressed: () {
                if ((titleController.text == "" && noteController.text == "") &&
                    storeData.notes[storeData.notes.length - 1].keyData ==
                        widget.note?.keyData) {
                  StoreProvider.of<AppState>(context)
                      .dispatch(DeleteNoteAction(widget.note!.keyData));
                }
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: colorScheme.iconColor,
                ),
                onPressed: () {
                  setState(() {
                    isPinned = !isPinned;
                  });

                  updateDataNote((note) => note.copyWith(isPinned: isPinned));
                },
              ),
              IconButton(
                icon: Icon(
                  isArsip ? Icons.unarchive_outlined : Icons.archive_outlined,
                  color: colorScheme.iconColor,
                ),
                // Action for archive icon
                onPressed: () {
                  setState(() {
                    isArsip = !isArsip;
                  });
                  // update to reducer
                  updateDataNote((note) => note.copyWith(isArsip: isArsip));

                  // Show dialog
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      });

                      return CustomAlertDialog(
                        title: isArsip ? "Berhasil!" : "Dibatalkan",
                        message: isArsip
                            ? "Catatan berhasil diarsipkan"
                            : "Pengarsipan catatan dibatalkan",
                        icon: isArsip ? Icons.check_circle : Icons.cancel,
                        iconColor: isArsip ? Colors.green : Colors.red,
                      );
                    },
                  );
                },
              ),
              if (widget.note != null) ...[
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: textColor,
                    ),
                    onPressed: () {
                      // Dispatch aksi untuk menghapus catatan
                      StoreProvider.of<AppState>(context)
                          .dispatch(DeleteNoteAction(widget.note!.keyData));
                      Navigator.pop(context); // Tutup dialog setelah menghapus
                    }),
              ]
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around content
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImages(),
                  TextField(
                    controller: titleController, // Bind to titleController
                    decoration: InputDecoration(
                      hintText: 'Judul', // Placeholder for title
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: fontSize.fontHeader, color: textColor),
                    ),
                    style: TextStyle(
                        fontSize: fontSize.fontHeader,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                    maxLines: null, // Allow multiple lines
                    textAlignVertical:
                        TextAlignVertical.top, // Align text to the top
                    onChanged: (value) {
                      updateDataNote((note) => note.copyWith(title: value));
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: TextField(
                      controller: noteController, // Bind to noteController
                      undoController: _undoNoteController,
                      decoration: InputDecoration(
                        hintText: 'Catatan', // Placeholder for note content
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: fontSize.fontContent,
                          color: textColor,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: fontSize.fontContent,
                        color: textColor,
                      ),
                      maxLines: null, // Allows multiple lines
                      onChanged: (value) {
                        updateDataNote((note) => note.copyWith(content: value));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomAppBar(
            undoController: _undoNoteController,
            backgroundColor: lingtOrDark,
            formattedDate: formattedDate,
            iconColor: colorScheme.iconColor,
            onColorPickerPressed: () {
              _showColorPicker(context);
            },
            onImageSourcePressed: () async {
              // await requestPermissions();
              _showImageSourceDialog(context);
            },
          ),
        );
      },
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerCustom(
            selectedColor: selectedColor,
            onColorChanged: onColorSelected,
            onClearColor: onClearColor,
            onClose: onClosePopUp);
      },
    );
  }

  void onColorSelected(Color color) {
    setState(() {
      selectedColor = color; // Simpan warna yang dipilih
      updateDataNote((note) => note.copyWith(color: selectedColor));
    });
  }

  void onClearColor() {
    setState(() {
      selectedColor = Colors.white; // Set warna menjadi putih
      updateDataNote((note) => note.copyWith(color: selectedColor));
    });
    Navigator.of(context).pop(); // Tutup dialog
  }

  void onClosePopUp() {
    Navigator.of(context).pop(); // Tutup dialog
  }

  void updateDataNote(Function(Note) updateFunc) {
    if (widget.note != null) {
      final updatedNote = updateFunc(widget.note!.copyWith(
        title: titleController
            .text, // Menggunakan nilai dari TextEditingController
        content:
            noteController.text, // Menggunakan nilai dari TextEditingController
        isArsip: isArsip, // Menggunakan nilai dari variabel isArsip
        isPinned: isPinned, // Menggunakan nilai dari variabel isPinned
        color: selectedColor, // Menggunakan nilai dari selectedColor
        imageFiles: _imageFiles
            .where((file) => file != null)
            .cast<File>()
            .toList(), // Menggunakan nilai dari _imageFiles
        imageBlobUrls: _imageBlobUrls
            .where((url) => url != null)
            .cast<String>()
            .toList(), // Menggunakan nilai dari _imageBlobUrls
        updateTime: DateTime.now(), // Memperbarui updateTime
        keyData: keyData, // Menggunakan nilai dari keyData
      ));
      // final updatedNote = updateFunc(widget.note!.copyWith(
      //   updateTime: DateTime.now(), // Update the updateTime to the current time
      // )); // Pass the current note to the update function
      print("Update data: $updatedNote");
      StoreProvider.of<AppState>(context)
          .dispatch(UpdateNoteAction(updatedNote));
    }
  }

  Widget _buildImages() {
    // Gabungkan kedua list _imageFiles dan _imageBlobUrls
    List<Widget> imageWidgets = [
      ..._imageFiles.map((imageFile) {
        if (imageFile != null) {
          return GestureDetector(
            onTap: () {
              _showImageDialog(imageFile: imageFile);
            },
            child: Card(
              elevation: 4,
              // Menggunakan Card untuk memberikan efek
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  child: Image.file(imageFile,
                      fit: BoxFit.cover), // Menyesuaikan gambar
                ),
              ),
            ),
          );
        }
        return SizedBox
            .shrink(); // Kembalikan widget kosong jika imageFile null
      }),
      ..._imageBlobUrls.map((imageBlobUrl) {
        if (imageBlobUrl != null) {
          return GestureDetector(
            onTap: () {
              _showImageDialog(imageBlobUrl: imageBlobUrl);
            },
            child: Card(
              // Menggunakan Card untuk memberikan efek
              elevation: 4, // Menambahkan bayangan
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  child: Image.network(imageBlobUrl,
                      fit: BoxFit.cover), // Menyesuaikan gambar
                ),
              ),
            ),
          );
        }
        return SizedBox
            .shrink(); // Kembalikan widget kosong jika imageBlobUrl null
      }),
    ];

    // Cek apakah imageWidgets tidak kosong
    if (imageWidgets.isNotEmpty) {
      return SizedBox(
        height: 150, // Atur tinggi sesuai kebutuhan
        child: ListView(
          scrollDirection:
              Axis.horizontal, // Menampilkan daftar secara horizontal
          children: imageWidgets,
        ),
      );
    }

    return Container(); // Tampilkan Container kosong jika tidak ada gambar
  }

  void _showImageDialog({File? imageFile, String? imageBlobUrl}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: double.infinity, // Set width to full
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                ),
              if (imageBlobUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: double.infinity, // Set width to full
                    child: Image.network(
                      imageBlobUrl,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (!kIsWeb) {
                      _imageFiles.remove(imageFile); // Hapus gambar dari daftar
                      updateDataNote((note) => note.copyWith(
                          imageFiles: _imageFiles
                              .where((file) => file != null)
                              .cast<File>()
                              .toList()));
                    } else {
                      _imageBlobUrls
                          .remove(imageBlobUrl); // Hapus blob URL dari daftar
                      updateDataNote((note) => note.copyWith(
                          imageBlobUrls: _imageBlobUrls
                              .where((url) => url != null)
                              .map((url) => url!)
                              .toList()));
                    }
                  });
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: Text('Delete Image'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              if (!kIsWeb && !Platform.isWindows) ...[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop(); // Menutup dialog
                    _pickImage(ImageSource.camera); // Buka kamera
                  },
                ),
              ],
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(); // Menutup dialog
                  _pickImage(ImageSource.gallery); // Buka galeri
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Memastikan widget masih terpasang sebelum memanggil setState
      if (mounted) {
        if (!kIsWeb) {
          _imageFiles.add(File(pickedFile.path)); // Simpan gambar yang dipilih
          updateDataNote((note) => note.copyWith(
              imageFiles: _imageFiles
                  .where((file) => file != null)
                  .cast<File>()
                  .toList()));
        } else {
          _imageBlobUrls.add(pickedFile.path);
          updateDataNote((note) => note.copyWith(
              imageBlobUrls: _imageBlobUrls
                  .where((url) => url != null)
                  .map((url) => url!)
                  .toList()));
        }
        setState(() {});

        // print("Image selected: ${pickedFile.path}");
        // untuk menampilkan message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Image selected: ${pickedFile.path}')),
        // );
      }
    } else {
      // Jika tidak ada gambar yang dipilih, pastikan widget masih terpasang
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected')),
        );
      }
    }
  }
}
