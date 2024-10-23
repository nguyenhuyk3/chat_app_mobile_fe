import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FileUploadWidget extends StatefulWidget {
  final String fileName;
  // Stream is to get file dowloading progress
  final Stream<double> progressStream;

  const FileUploadWidget({
    super.key,
    required this.fileName,
    required this.progressStream,
  });

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    widget.progressStream.listen((progress) {
      setState(() {
        // Update file downloading progress
        _progress = progress;
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
      title: Text(widget.fileName),
      subtitle: _progress < 1.0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  minHeight: 5,
                ),
                const SizedBox(height: 5),
                Text("${(_progress * 100).toStringAsFixed(0)}%"),
              ],
            )
          : const Text("Upload Complete",
              style: TextStyle(color: Colors.green)),
      trailing: SizedBox(
        width: 30, // Giới hạn kích thước trailing widget
        height: 30,
        child: _progress < 1.0
            ? const SpinKitCircle(color: Colors.blue, size: 30.0)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
