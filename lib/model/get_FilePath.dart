import 'dart:io';
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
      return AudioDirectoryPath = downloadsDirectoryPath;
    }
  }

  Future<List<AudioFile>> getFileList() async {
    if(await _getAudioStoragePermission() == false) return [];

    await _getAudioDirectoryPath();
    Directory dir = Directory(AudioDirectoryPath);
    List<FileSystemEntity> FileEntity = dir.listSync();

    List<AudioFile> res = [];

    for (FileSystemEntity file in FileEntity) {
      FileStat stats = await file.stat();
      res.add(AudioFile(Path: file.path, Date: stats.modified));
    }
    return res;
  }
}

class AudioFile{
  String Path;
  String Name;
  DateTime Date;
  String ShowingDate;

  AudioFile({required Path, required Date})
      : this.Path = Path,
        this.Date = Date,
        this.Name = _ExtractFileName(Path),
        this.ShowingDate = _formatDateTime(Date);

  static String _ExtractFileName(String FilePath) {
    int lastSeparator = FilePath.lastIndexOf('/'); // 마지막 '/'의 위치
    int lastDot = FilePath.substring(lastSeparator + 1).lastIndexOf('.'); // 마지막 '.'의 위치

    // 확장자가 없는 경우, 전체 파일 이름을 반환
    if (lastDot == -1) {
      return FilePath.substring(lastSeparator + 1);
    }

    // 확장자가 있는 경우, 파일 이름만 추출
    return FilePath.substring(lastSeparator + 1, lastSeparator + 1 + lastDot);
  }

  static String _formatDateTime(DateTime dateTime) {
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return "$month-$day $hour:$minute";
  }
}