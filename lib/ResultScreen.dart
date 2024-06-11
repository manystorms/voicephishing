import 'package:flutter/material.dart';
import 'package:voicephishing/model/get_FilePath.dart';
import 'package:voicephishing/model/SpeechToText.dart';
import 'package:voicephishing/model/AnalyzeText.dart';

class ResultScreen extends StatefulWidget {
  final AudioFile audioFile;
  ResultScreen({required this.audioFile});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>{
  bool _isAnalyzing = true;

  String AudioText = "";
  Future<void> _getAudioText() async {
    await _getAnalyzeData();
    getAudioText SpeechToTextClass = getAudioText();
    AudioText = await SpeechToTextClass.recognizeAudioFile(widget.audioFile.Path);
    _isAnalyzing = false;
    setState(() {});
  }

  Future<void> _getAnalyzeData() async {
    WidgetsFlutterBinding.ensureInitialized();
    final classifier = TextClassifier();

    // 모델과 토크나이저 초기화를 기다립니다.
    await classifier.initialize();

    String text = "네 체크카드 제가 지금 현재 이렇게 약간 사용하고 있는 건 그거 하나밖에 없어요.";
    try {
      double result = await classifier.classifyText(text);
      print("예측 결과: $result");
    } catch (e) {
      print('분류 중 오류가 발생했습니다: $e');
    } finally {
      // 리소스 정리
      classifier.dispose();
    }
  }


  @override
  void initState() {
    _getAudioText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audioFile.Name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("녹음 텍스트", style: TextStyle(fontSize: 24)),
            _isAnalyzing
                ? Center(child: CircularProgressIndicator()) // 중앙 정렬
                : Container(),
            Text(AudioText, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}