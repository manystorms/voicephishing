import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;
import 'package:serious_python/serious_python.dart';

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

  Future<String> getFilePath(String FileName) async {
    String mp3FilePath = "NoData";
    if (Platform.isAndroid) {
      final Directory downloadsDirectory = Directory('/storage/emulated/0/Download');

      mp3FilePath = p.join(downloadsDirectory.path, FileName);
      debugPrint(mp3FilePath);
      debugPrint(File(mp3FilePath!).existsSync().toString());
    }
    return mp3FilePath;
  }

  /*Future<String> PythonBridge(String FilePath) {
    String temp = "a";
    return temp;
  }*/

  Future<String> STT(String FileName) async {
    String WAVFilePath = await getFilePath(FileName);
    String res = "No data";

    Directory tempDir =
    await (await getTemporaryDirectory()).createTemp("python_communication");
    String resultFileName = p.join(tempDir.path, "out.txt");
    String FilePath = p.join(tempDir.path, "ReadTxtTest.txt");
    File file = File(FilePath);
    await file.writeAsString("asdfAsㅁㅁㅁ");
    WAVFilePath = FilePath;

    await SeriousPython.run("python/test.py",
        environmentVariables: {
          "RESULT_FILENAME": resultFileName,
          "WAV_FILENAME": WAVFilePath
        },
        sync: false);

    var i = 30;
    while (i-- > 0) {
      var out = File(resultFileName);
      if (await out.exists()) {
        var r = await out.readAsString();
        res = r;
        break;
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return res;
  }
}