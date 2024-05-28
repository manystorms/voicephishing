import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;

class getAudio {
  Future<void> getAudioPermission() async {
    final status = await Permission.audio.request();
    print(status.isGranted);
    if (status.isGranted) {
      // 오디오 파일에 액세스할 수 있습니다.
      //_loadAudioFiles();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      // 권한 요청을 다시 시도하십시오.
    }
  }

  Future<String> getMp3FilePath(String FileName) async {
    String mp3FilePath = "NoData";
    if (Platform.isAndroid) {
      final Directory downloadsDirectory = Directory('/storage/emulated/0/Download');

      mp3FilePath = p.join(downloadsDirectory.path, FileName);
      debugPrint(mp3FilePath);
      debugPrint(File(mp3FilePath!).existsSync().toString());
    }
    return mp3FilePath;
  }

  Future<String> AnalyzeMp3(String FileName) async {
    String mp3FilePath = await getMp3FilePath(FileName);
    
    return 'a';
  }
}