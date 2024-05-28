import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:voicephishing/HomeScreen.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MP3 Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  String? mp3FilePath;

  @override
  void initState() {
    super.initState();
    requestPermissions().then((_) {
      getMp3FilePath();
    });
  }

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      debugPrint("Storage permission granted");
    } else {
      debugPrint("Storage permission denied");
    }
  }

  Future<void> getMp3FilePath() async {
    if (Platform.isAndroid) {
      final Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
      setState(() {
        mp3FilePath = p.join(downloadsDirectory.path, 'test.mp3');
        print(mp3FilePath);
        print(File(mp3FilePath!).existsSync());
      });
    }
  }

  Future<void> playMP3() async {
    if (mp3FilePath != null && File(mp3FilePath!).existsSync()) {
      await audioPlayer.play(DeviceFileSource(mp3FilePath!));
      setState(() {
        _mp3Result = "Playing...";
      });
    } else {
      setState(() {
        _mp3Result = "File not found";
      });
    }
  }

  String _mp3Result = "Waiting to play...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MP3 Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: playMP3,
              child: const Text('Play MP3'),
            ),
            SizedBox(height: 20),
            Text(_mp3Result),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
