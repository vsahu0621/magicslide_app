import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFPreviewPage extends StatelessWidget {
  final String pdfUrl;

  const PDFPreviewPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),
      body: const PDF().cachedFromUrl(
        // Add Dummy PDF for assignment (works without accessId)
        "https://www.africau.edu/images/default/sample.pdf",
        placeholder: (context) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (error) =>
            Center(child: Text("Failed to load PDF: $error")),
      ),
    );
  }
}
