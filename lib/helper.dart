import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showAutoDismissDialog(BuildContext context, String message) async {
  final completer = Completer<void>();

  final dialog = AlertDialog(
    title: const Text("تنويه"),
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
          Navigator.of(context).pop();
        },
        child: const Text("إغلاق"),
      ),
    ],
  );

  // Show dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  // Auto dismiss after 5 seconds
  Future.delayed(const Duration(seconds: 5), () {
    if (!completer.isCompleted) {
      completer.complete();
      Navigator.of(context).pop();
    }
  });

  return completer.future;
}

String serializeFileObject(File file) {
  List<int> imageBytes = file.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

Future<File> getFileObjectFromString(String file) async {
  Uint8List imageBytes = base64Decode(file);
  final Directory tempDir = Directory.systemTemp;

    final File tempFile = File('${tempDir.path}/temp_image.jpg');

    await tempFile.writeAsBytes(imageBytes);
  return tempFile;
}

Map<String, String> getAllStrings(SharedPreferences prefs) {
  Map<String, String> stringMap = {};

  prefs.getKeys().forEach((key) {
    var value = prefs.get(key);
    if (value is String) {
      stringMap[key] = value;
    }
  });

  return stringMap;
}