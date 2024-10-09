import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tulisan_awak_app/constants/constants.dart';
import 'package:tulisan_awak_app/redux/actions/actions.dart';
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
  bool isArsip = false;
  bool isPinned = false;
  var uuid = Uuid().v4();
  String keyData = '';
  DateTime dateTimeNow = DateTime.now();
  // Format tanggal dan waktu
  String formattedDate = "";
  Color selectedColor = Colors.lightBlue;
  final List<File?> _imageFiles = [];
  final List<String?> _imageBlobUrls = [];

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
    selectedColor = widget.note?.color ?? Colors.lightBlue;
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveData() {
    final note = Note(
      keyData: keyData,
      title: titleController.text,
      content: noteController.text,
      isArsip: isArsip,
      isPinned: isPinned,
      updateTime: dateTimeNow,
      color: selectedColor,
    );

    if (widget.note != null) {
      // Jika keyData ada, update catatan
      StoreProvider.of<AppState>(context).dispatch(UpdateNoteAction(note));
    } else {
      // Jika keyData tidak ada, tambahkan catatan baru
      StoreProvider.of<AppState>(context).dispatch(AddNoteAction(note));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan warna ikon berdasarkan selectedColor
    Color lingtOrDark =
        selectedColor != Colors.white ? Colors.white : Colors.black;

    return StoreConnector<AppState, Settings>(
      converter: (store) => Settings(
        store.state.theme,
        store.state.fontSize,
      ),
      builder: (context, storeData) {
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
          backgroundColor: selectedColor,
          appBar: AppBar(
            backgroundColor: selectedColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: lingtOrDark,
              ),
              onPressed: saveData,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: lingtOrDark,
                ),
                onPressed: () {
                  setState(() {
                    isPinned = !isPinned;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  isArsip ? Icons.unarchive_outlined : Icons.archive_outlined,
                  color: lingtOrDark,
                ),
                // Action for archive icon
                onPressed: () {
                  setState(() {
                    isArsip = !isArsip;
                  });

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
                      color: lingtOrDark,
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding around content
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
                          fontSize: fontSize.fontHeader, color: lingtOrDark),
                    ),
                    style: TextStyle(
                        fontSize: fontSize.fontHeader,
                        fontWeight: FontWeight.bold,
                        color: lingtOrDark),
                    maxLines: null, // Allow multiple lines
                    textAlignVertical:
                        TextAlignVertical.top, // Align text to the top
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: noteController, // Bind to noteController
                    decoration: InputDecoration(
                      hintText: 'Catatan', // Placeholder for note content
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: fontSize.fontContent,
                        color: lingtOrDark,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: fontSize.fontContent,
                      color: lingtOrDark,
                    ),
                    maxLines: null, // Allows multiple lines
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: BottomAppBar(
              color: selectedColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Menjaga jarak antara ikon dan teks
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.palette_outlined,
                            color: lingtOrDark,
                          ),
                          onPressed: () {
                            _showColorPicker(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.image_search,
                            color: lingtOrDark,
                          ),
                          onPressed: () async {
                            // await requestPermissions();
                            _showImageSourceDialog(context);
                          },
                        ),
                      ],
                    ),
                    // Memposisikan teks di tengah
                    Text(
                      'Diedit: $formattedDate',
                      style: TextStyle(
                          color: lingtOrDark,
                          fontSize: fontSize.fontContent - 4),
                    ),
                    SizedBox()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
          backgroundColor: Colors.lightBlue,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              if (imageBlobUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageBlobUrl,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (imageFile != null) {
                      _imageFiles.remove(imageFile); // Hapus gambar dari daftar
                    } else if (imageBlobUrl != null) {
                      _imageBlobUrls
                          .remove(imageBlobUrl); // Hapus blob URL dari daftar
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

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Warna'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Menampilkan color picker
                BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color; // Simpan warna yang dipilih
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Atau pilih warna lain:'),
                SizedBox(height: 20),
                // Menampilkan ColorPicker
                ColorPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color; // Simpan warna yang dipilih
                    });
                  },
                  pickerAreaHeightPercent: 0.8,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Clear'), // Tombol untuk mengatur warna menjadi putih
              onPressed: () {
                setState(() {
                  selectedColor = Colors.white; // Set warna menjadi putih
                });
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text('Default'), // Tombol untuk mengatur warna Default
              onPressed: () {
                setState(() {
                  selectedColor =
                      Colors.lightBlue; // Set warna menjadi lightBlue
                });
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
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
        } else {
          _imageBlobUrls.add(pickedFile.path);
        }
        setState(() {});
        // print("Image selected: ${pickedFile.path}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected: ${pickedFile.path}')),
        );
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
