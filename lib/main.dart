import 'package:flutter/material.dart';
import 'package:external_path/external_path.dart';
import 'package:voicephishing/HomeScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _exPath = [];
  String FileContent = 'a';
  PermissionStatus _status = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    requestPermission();
    getPath();
    getPublicDirectoryPath();
  }

  Future<void> requestPermission() async {
    // 외부 저장소 읽기 권한 요청
    PermissionStatus status = await Permission.storage.request();

    setState(() {
      _status = status;
    });
  }

  // Get storage directory paths
  // Like internal and external (SD card) storage path
  Future<void> getPath() async {
    List<String> paths;
    // getExternalStorageDirectories() will return list containing internal storage directory path
    // And external storage (SD card) directory path (if exists)
    paths = await ExternalPath.getExternalStorageDirectories();

    setState(() {
      _exPath = paths; // [/storage/emulated/0, /storage/B3AE-4D28]
    });
  }

  // To get public storage directory path like Downloads, Picture, Movie etc.
  // Use below code
  Future<void> getPublicDirectoryPath() async {
    String path;

    path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    try {
      String FilePath = '$path/test.txt';
      print(FilePath);
      print('b');

      File file = File(FilePath);
      FileContent = await file.readAsString();
      print(FileContent);
      print('c');
    } catch (error) {
      print('error: $error');
    }

    setState(() {
      print(path); // /storage/emulated/0/Download
      print('a');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView.builder(
              itemCount: _exPath.length,
              itemBuilder: (context, index) {
                return Center(child: Text(FileContent));
              }),
        ));
  }
}