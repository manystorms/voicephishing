import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart' as p;

class ManageFilePath {
  static String AudioDirectoryPath = "No Data";

  Future<bool> _getAudioStoragePermission() async {
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

  Future<String> _getAudioDirectoryPath() async {
    if(AudioDirectoryPath != "No Data") {
      return AudioDirectoryPath;
    }else{
      final String downloadsDirectoryPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      //return AudioDirectoryPath = p.join(downloadsDirectoryPath, 'KakaoTalk');
      return downloadsDirectoryPath;
    }
  }

  Future<String> getAudioFilePath(String FileName) async {
    if(await _getAudioStoragePermission() == false) return "Permission Denied";

    String mp3FilePath = "NoData";
    if (Platform.isAndroid) {
      mp3FilePath = p.join(await _getAudioDirectoryPath(), FileName);
      print(mp3FilePath);
      print(File(mp3FilePath!).existsSync().toString());
    }
    return mp3FilePath;
  }

  Future<List<FileSystemEntity>> getFileList() async {
    if(await _getAudioStoragePermission() == false) return [];

    await _getAudioDirectoryPath();
    Directory dir = Directory(AudioDirectoryPath);
    return dir.listSync();
  }
}