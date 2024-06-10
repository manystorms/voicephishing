import 'package:flutter/material.dart';
import 'package:voicephishing/model/get_FilePath.dart';

class ResultScreen extends StatelessWidget{
  final AudioFile audioFile;

  ResultScreen({required this.audioFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(audioFile.Name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Path: ${audioFile.Path}", style: TextStyle(fontSize: 18)),
            Text("Date: ${audioFile.Date.toString()}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}