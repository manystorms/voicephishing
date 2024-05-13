import 'package:flutter/material.dart';
import 'package:external_path/external_path.dart';
import 'package:voicephishing/HomeScreen.dart';
import 'package:path_provider/path_provider.dart';
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
  String _fileContents = '';

  @override
  void initState() {
    super.initState();
    readFileFromExternalStorage();
  }

  Future<void> readFileFromExternalStorage() async {
    try {
      // 플랫폼별로 파일 시스템의 디렉토리 경로 가져오기
      Directory? directory = await getExternalStorageDirectory();
      String? rootPath = directory?.path;

      // 외부 저장소에 있는 텍스트 파일 경로 설정 (예시: 'myfile.txt')
      String filePath = '$rootPath/test.txt';

      // 파일 읽기
      File file = File(filePath);
      String contents = await file.readAsString();

      // 파일 내용 출력
      setState(() {
        _fileContents = contents;
      });
    } catch (e) {
      print('파일 읽기 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('외부 저장소의 텍스트 파일 읽기'),
        ),
        body: Center(
          child: Text(_fileContents),
        ),
      ),
    );
  }
}