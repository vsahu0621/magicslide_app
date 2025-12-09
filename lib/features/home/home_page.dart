import 'package:flutter/material.dart';
import 'package:magicslide_app/features/ppt/api_service.dart';
import 'package:magicslide_app/features/ppt/result_page.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final topicController = TextEditingController();
  int slides = 10;
  String template = "bullet-point1";
  String model = "gpt-4";
  bool aiImages = false;
  bool googleImg = false;
  bool googleText = false;
  bool imageEach = true;

  final templates = [
    "bullet-point1",
    "bullet-point2",
    "bullet-point4",
    "bullet-point5",
    "ed-bullet-point1",
    "ed-bullet-point4",
    "pitch-deck-3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MagicSlides PPT Maker"),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.sunny : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Enter Topic",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                hintText: "Your topic...",
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Select Template",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              isExpanded: true,
              value: template,
              items: templates.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(t),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  template = v!;
                });
              },
            ),

            const SizedBox(height: 20),
            const Text(
              "Number of Slides",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: slides.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              label: "$slides",
              onChanged: (v) {
                setState(() {
                  slides = v.toInt();
                });
              },
            ),

            SwitchListTile(
              value: aiImages,
              title: const Text("AI Images"),
              onChanged: (v) {
                setState(() => aiImages = v);
              },
            ),
            SwitchListTile(
              value: imageEach,
              title: const Text("Image on Each Slide"),
              onChanged: (v) {
                setState(() => imageEach = v);
              },
            ),
            SwitchListTile(
              value: googleImg,
              title: const Text("Google Images"),
              onChanged: (v) {
                setState(() => googleImg = v);
              },
            ),
            SwitchListTile(
              value: googleText,
              title: const Text("Google Text"),
              onChanged: (v) {
                setState(() => googleText = v);
              },
            ),

            const SizedBox(height: 20),
            const Text(
              "Model",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              value: model,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "gpt-4", child: Text("GPT-4")),
                DropdownMenuItem(value: "gpt-3.5", child: Text("GPT-3.5")),
              ],
              onChanged: (v) {
                setState(() => model = v!);
              },
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (topicController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter topic first")),
                    );
                    return;
                  }

                  final url = await MagicSlidesApi.generatePPT(
                    topic: topicController.text.trim(),
                    template: template,
                    language: "en",
                    slideCount: slides,
                    aiImages: aiImages,
                    imageForEachSlide: imageEach,
                    googleImage: googleImg,
                    googleText: googleText,
                    model: model,
                  );

                  if (url == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to generate PPT")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultPage(url: url),
                    ),
                  );
                },
                child: const Text("Generate Presentation"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
