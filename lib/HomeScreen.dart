import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:voicephishing/model/get_MP3.dart';
import 'package:voicephishing/model/get_FilePath.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoicePhishingDetector(),
    );
  }
}

class VoicePhishingDetector extends StatefulWidget {
  @override
  _VoicePhishingDetectorState createState() => _VoicePhishingDetectorState();
}

class _VoicePhishingDetectorState extends State<VoicePhishingDetector> {
  String? _filePath;
  String _analysisResult = '';
  bool _isAnalyzing = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> analyzeFile() async {
    if (_filePath == null) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = ''; // 분석 중에 이전 결과를 지웁니다.
    });

    ManageFilePath a = ManageFilePath();
    List<FileSystemEntity> b = await a.getFileList();
    print(b);

    // 분석 결과를 받아서 상태를 업데이트합니다.
    setState(() {
      _isAnalyzing = false;
      _analysisResult = "이 파일은 보이스피싱입니다!"; // 예시 결과
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD2BD),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: <Widget>[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickFile,
                child: Text('음성 파일 선택'),
              ),
              SizedBox(height: 20),
              Text(_filePath ?? '파일을 선택해주세요.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: analyzeFile,
                child: Text('분석 시작'),
              ),
              SizedBox(height: 20),
              _isAnalyzing ? CircularProgressIndicator() : Container(),
              SizedBox(height: 20),
              if (_analysisResult.isNotEmpty)
                Text(_analysisResult, style: TextStyle(fontSize: 18, color: Colors.red)),
            ],
          ),
        ),
      )
    );
  }
}
