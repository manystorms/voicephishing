import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class getAudio {
  Future<void> getAudioPermission() async {
    final status = await Permission.audio.request();
    print(status.isGranted);
    if (status.isGranted) {
      // 오디오 파일에 액세스할 수 있습니다.
      //_loadAudioFiles();
    } else if (status.isPermanentlyDenied) {
      // 사용자가 권한을 영구히 거부했습니다.
      openAppSettings();
    } else {
      // 권한 요청을 다시 시도하십시오.
    }
  }

  Future<String> getFilePath() async {
    String path = '';

    try {
      path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      print('path-->$path');
    } catch (error) {
      print('error--> $error');
    }

    return path;
  }
}