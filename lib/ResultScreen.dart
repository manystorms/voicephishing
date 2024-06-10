import 'package:flutter/material.dart';
import 'package:voicephishing/model/get_FilePath.dart';
import 'package:voicephishing/model/SpeechToText.dart';

class ResultScreen extends StatefulWidget {
  final AudioFile audioFile;
  ResultScreen({required this.audioFile});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>{
  String AudioText = "변환중입니다";
  Future<void> _getAudioText() async {
    getAudioText SpeechToTextClass = getAudioText();
    AudioText = await SpeechToTextClass.recognizeAudioFile(widget.audioFile.Path);
    setState(() {});
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
            Text("Date: ${widget.audioFile.ShowingDate}", style: TextStyle(fontSize: 12)),
            Text(AudioText, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}