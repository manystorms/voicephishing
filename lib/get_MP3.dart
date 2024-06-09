import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:serious_python/serious_python.dart';
import 'package:external_path/external_path.dart';

class getAudio {
  Future<bool> getAudioPermission() async {
    final status = await Permission.audio.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<String> getFilePath(String FileName) async {
    if(getAudioPermission() == false) return "Permission Denied";

    String mp3FilePath = "NoData";
    if (Platform.isAndroid) {
      final String downloadsDirectoryPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);

      //final String kakaoTalkDirectoryPath = p.join(downloadsDirectoryPath, 'KakaoTalk');

      mp3FilePath = p.join(downloadsDirectoryPath, FileName);
      debugPrint(mp3FilePath);
      debugPrint(File(mp3FilePath!).existsSync().toString());
    }
    return mp3FilePath;
  }

  Future<String> PythonBridge(String WAVFilePath) async {
    String res = "TimeOut";

    Directory tempDir =
    await (await getTemporaryDirectory()).createTemp("python_communication");
    String resultFileName = p.join(tempDir.path, "out.txt");

    await SeriousPython.run("python/test_python.zip",
        appFileName: "test.py",
        environmentVariables: {
          "RESULT_FILENAME": resultFileName,
          "WAV_FILENAME": WAVFilePath
        },
        modulePaths: ["/__pypackages__/speech_recognition/"],
        sync: false);

    var i = 30;
    while (i-- > 0) {
      var out = File(resultFileName);
      if (await out.exists()) {
        var r = await out.readAsString();
        res = r;
        print('aaaa');
        break;
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return res;
  }

  Future<String> STT(String FileName) async {
    String WAVFilePath = await getFilePath(FileName);
    String res = "No data";

    res = await PythonBridge(WAVFilePath);

    return res;
  }
}