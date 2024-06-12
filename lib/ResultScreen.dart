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

class _ResultScreenState extends State<ResultScreen> {
  bool _isAnalyzing = true;
  String audioText = "";
  List<String> audioSentences = [];
  List<double> audioVoicephishingCheck = [];

  Future<void> _getAudioText() async {
    getAudioText speechToTextClass = getAudioText();
    audioText = await speechToTextClass.recognizeAudioFile(widget.audioFile.Path);
    _isAnalyzing = false;
    setState(() {});

    await _getAnalyzeData();
  }

  Future<void> _getAnalyzeData() async {
    audioSentences = audioText.split(RegExp(r'\.\s+'));
    audioVoicephishingCheck.clear();

    final classifier = TextClassifier();

    await classifier.initialize();

    try {
      for (String text in audioSentences) {
        double result = await classifier.classifyText(text);
        audioVoicephishingCheck.add(result);
        print("문자: $text, 예측 결과: $result");
      }
    } catch (e) {
      print('분류 중 오류가 발생했습니다: $e');
    } finally {
      classifier.dispose();
    }
    print(audioSentences);
    print(audioVoicephishingCheck);
  }

  @override
  void initState() {
    super.initState();
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
          children: [
            Text("녹음 텍스트", style: TextStyle(fontSize: 24)),
            _isAnalyzing
                ? Center(child: CircularProgressIndicator())
                : Flexible(
              child: Text(audioText, style: TextStyle(fontSize: 18)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: audioSentences.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  (0.1 * 100).toString(),
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 17,
                                    letterSpacing: 0,
                                  ),
                                ),
                                Text(audioSentences[index]),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.file_open_rounded,
                            color: Colors.black,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}