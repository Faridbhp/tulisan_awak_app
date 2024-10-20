import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

Future<void> createPDF({
  String textTitle = '',
  String textContent = '',
  List<File?> imageFiles = const [],
  List<String?> imageBlobUrls = const [],
}) async {
  // Create a PDF document
  final pdf = pw.Document();

  // Add a page to the document
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                textTitle,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
            // Add space between title and content
            pw.SizedBox(height: 20),
            pw.Text(
              textContent,
              style: pw.TextStyle(fontSize: 18),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 20),
            // Check if there are local images
            if (imageFiles.isNotEmpty) ...[
              _buildImageGrid(imageFiles),
            ],
            // Check if there are image URLs
            if (imageBlobUrls.isNotEmpty) ...[
              _buildImageGridFromUrls(imageBlobUrls),
            ]
          ],
        ); // Title, content, and images are all centered
      },
    ),
  );

  // Get the directory to save the PDF
  final output = await getApplicationDocumentsDirectory();
  final file = File('${output.path}/example.pdf');

  // Write the PDF file
  await file.writeAsBytes(await pdf.save());
  print('PDF saved at ${file.path}');

  // Open the PDF file
  OpenFile.open(file.path);
}

// Helper function to create a grid of images from files
pw.Widget _buildImageGrid(List<File?> imageFiles) {
  return pw.Wrap(
    // Space between cards
    spacing: 10,
    // Space between rows
    runSpacing: 10,
    children: imageFiles
        // Filter out null images
        .where((image) => image != null)
        .map((image) {
      return pw.Container(
        // Set the width for each card
        width: 200,
        child: pw.Image(
          pw.MemoryImage(
            // Convert the image file to bytes
            image!.readAsBytesSync(),
          ),
        ),
      );
    }).toList(),
  );
}

// Helper function to create a grid of images from URLs WEB
pw.Widget _buildImageGridFromUrls(List<String?> imageBlobUrls) {
  return pw.Wrap(
    spacing: 10, // Space between cards
    runSpacing: 10, // Space between rows
    children: imageBlobUrls
        .where((url) =>
            url != null && url.isNotEmpty) // Filter out null and empty URLs
        .map((url) {
      // Fetch and decode image data from the URL
      // This is a placeholder for the actual implementation to load the image from the URL
      // In a real-world scenario, you would download the image data
      // and then use it similarly to the local image case
      return pw.Container(
        // Set the width for each card
        width: 400,
        // Placeholder
        child: pw.Text('Image from URL: $url'),
      );
    }).toList(),
  );
}
