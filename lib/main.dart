import 'package:flutter/material.dart';
import 'package:external_path/external_path.dart';
import 'package:voicephishing/HomeScreen.dart';
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
  String _fileContent = 'Loading...';
  PermissionStatus _status = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    readFile();
  }

  Future<void> _requestStoragePermission() async {
    print('a');
    final status = await Permission.audio.request();
    print(status.isGranted);
    if (status.isGranted) {
      // 오디오 파일에 액세스할 수 있습니다.
      //_loadAudioFiles();
    } else if (status.isPermanentlyDenied) {
      // 사용자가 권한을 영구히 거부했습니다.
      openAppSettings();
    } else {
      // 권한 요청을 다시 시도하십시오.
    }
  }

  Future<void> readFile() async {
    if (_status == PermissionStatus.granted) {
      try {
        // Get external storage directory path for downloads
        String downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS,
        );

        // File path for test.mp3
        String filePath = '$downloadPath/test.mp3';

        // Read the file
        File file = File(filePath);
        if (await file.exists()) {
          // Read file content
          List<int> bytes = await file.readAsBytes();
          String fileContent = String.fromCharCodes(bytes);
          setState(() {
            _fileContent = fileContent;
          });
        } else {
          setState(() {
            _fileContent = 'File not found.';
          });
        }
      } catch (error) {
        setState(() {
          _fileContent = 'Error: $error';
        });
      }
    } else {
      setState(() {
        _fileContent = 'Permission denied.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Read MP3 File Example'),
        ),
        body: Center(
          child: Text(_fileContent),
        ),
      ),
    );
  }
}