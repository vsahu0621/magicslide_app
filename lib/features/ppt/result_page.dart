import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ResultPage extends StatefulWidget {
  final String url;

  const ResultPage({super.key, required this.url});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool downloading = false;

  Future<void> downloadFile() async {
    try {
      setState(() => downloading = true);

      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/GeneratedSlides.pptx";

      await Dio().download(widget.url, filePath);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Downloaded: $filePath")));

      OpenFilex.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Download failed: $e")));
    }

    setState(() => downloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Presentation Ready")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Your PPT is generated successfully!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(widget.url, maxLines: 2, overflow: TextOverflow.ellipsis),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: downloading ? null : downloadFile,
              icon: downloading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.download),
              label: Text(downloading ? "Downloading..." : "Download PPT"),
            ),
          ],
        ),
      ),
    );
  }
}
