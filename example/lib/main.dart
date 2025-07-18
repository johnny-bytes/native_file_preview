import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_file_preview/native_file_preview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native File Preview Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const FilePreviewDemo(),
    );
  }
}

class FilePreviewDemo extends StatefulWidget {
  const FilePreviewDemo({super.key});

  @override
  State<FilePreviewDemo> createState() => _FilePreviewDemoState();
}

class _FilePreviewDemoState extends State<FilePreviewDemo> {
  final _nativeFilePreviewPlugin = NativeFilePreview();
  List<FileItem> sampleFiles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _createSampleFiles();
  }

  Future<void> _createSampleFiles() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();

      final imageFile = File('${directory.path}/sample.png');
      final base64Image =
          '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';
      final imageBytes = base64Decode(base64Image);
      await imageFile.writeAsBytes(imageBytes);

      // Create sample text file
      final textFile = File('${directory.path}/sample.txt');
      await textFile.writeAsString('''
This is a sample text file created by the Native File Preview example app.

You can preview various file types using this plugin:
- Text files (.txt)
- PDF documents (.pdf)
- Images (.jpg, .png, .gif)
- Microsoft Office documents (.doc, .xls, .ppt)
- And many more!

The plugin uses native viewers on each platform:
- iOS: QuickLook framework
- Android: Intent system with ACTION_VIEW

Enjoy exploring the native file preview functionality!
      ''');

      // Create sample HTML file
      final htmlFile = File('${directory.path}/sample.html');
      await htmlFile.writeAsString('''
<!DOCTYPE html>
<html>
<head>
    <title>Sample HTML File</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h1 { color: #333; }
        .highlight { background-color: #ffeb3b; padding: 10px; }
    </style>
</head>
<body>
    <h1>Native File Preview Demo</h1>
    <p>This is a sample HTML file that demonstrates the file preview functionality.</p>
    <div class="highlight">
        <p><strong>Features:</strong></p>
        <ul>
            <li>Cross-platform file preview</li>
            <li>Native viewing experience</li>
            <li>Support for multiple file formats</li>
        </ul>
    </div>
</body>
</html>
      ''');

      // Create sample CSV file
      final csvFile = File('${directory.path}/sample.csv');
      await csvFile.writeAsString('''
Name,Age,City,Occupation
John Doe,30,New York,Software Engineer
Jane Smith,25,San Francisco,Designer
Bob Johnson,35,Chicago,Product Manager
Alice Brown,28,Seattle,Data Scientist
Charlie Wilson,32,Boston,Marketing Manager
      ''');

      // Create sample JSON file
      final jsonFile = File('${directory.path}/sample.json');
      await jsonFile.writeAsString('''
{
  "app": "Native File Preview Demo",
  "version": "1.0.0",
  "description": "A Flutter plugin for native file preview",
  "platforms": ["iOS", "Android"],
  "features": [
    "QuickLook integration on iOS",
    "Intent system on Android",
    "Multiple file format support",
    "Cross-platform compatibility"
  ],
  "sampleData": {
    "users": [
      {"id": 1, "name": "John", "role": "Developer"},
      {"id": 2, "name": "Jane", "role": "Designer"},
      {"id": 3, "name": "Bob", "role": "Manager"}
    ]
  }
}
      ''');

      sampleFiles = [
        FileItem(
          name: 'Sample Image File',
          description: 'A simple image file.',
          file: imageFile,
          icon: Icons.image,
          color: Colors.red,
        ),
        FileItem(
          name: 'Sample Text File',
          description:
              'A simple text document with information about the plugin',
          file: textFile,
          icon: Icons.description,
          color: Colors.blue,
        ),
        FileItem(
          name: 'Sample HTML File',
          description: 'An HTML document with styled content',
          file: htmlFile,
          icon: Icons.web,
          color: Colors.orange,
        ),
        FileItem(
          name: 'Sample CSV File',
          description: 'A comma-separated values file with sample data',
          file: csvFile,
          icon: Icons.table_chart,
          color: Colors.green,
        ),
        FileItem(
          name: 'Sample JSON File',
          description: 'A JSON file with structured data',
          file: jsonFile,
          icon: Icons.code,
          color: Colors.purple,
        ),
      ];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create sample files: $e';
      });
    }
  }

  Future<void> _previewFile(FileItem fileItem) async {
    try {
      await _nativeFilePreviewPlugin.previewFile(fileItem.file.path);
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error previewing file: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native File Preview Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Creating sample files...'),
                ],
              ),
            )
          : errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _createSampleFiles,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[600]),
                              const SizedBox(width: 8),
                              Text(
                                'About this demo',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This demo showcases the native file preview functionality. '
                            'Tap on any file below to preview it using your device\'s native viewer.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sample Files',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sampleFiles.length,
                      itemBuilder: (context, index) {
                        final fileItem = sampleFiles[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: fileItem.color.withOpacity(0.1),
                              child: Icon(fileItem.icon, color: fileItem.color),
                            ),
                            title: Text(
                              fileItem.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fileItem.description),
                                const SizedBox(height: 4),
                                Text(
                                  'File: ${fileItem.file.path.split('/').last}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => _previewFile(fileItem),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createSampleFiles,
        tooltip: 'Refresh sample files',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class FileItem {
  final String name;
  final String description;
  final File file;
  final IconData icon;
  final Color color;

  FileItem({
    required this.name,
    required this.description,
    required this.file,
    required this.icon,
    required this.color,
  });
}
