import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';

class getAudioText {
  Future<String> recognizeAudioFile(String audioFilePath) async {
    // 서비스 계정 파일 로드
    final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString('assets/google_cloud_account.json'));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig(); // 구성 가져오기
    final audio = await _getAudioContent(audioFilePath); // 오디오 파일에서 오디오 콘텐츠를 읽음

    try {
      // Speech-to-Text API를 호출하여 결과를 받음
      final response = await speechToText.recognize(config, audio);
      // 결과를 모두 문자열로 결합하여 반환
      return response.results
          .map((result) => result.alternatives.first.transcript)
          .join("\n");
    } catch (e) {
      print('Error recognizing audio: $e');
      return 'Error recognizing audio: $e';
    }
  }

  RecognitionConfig _getConfig() {
    return RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 8000,
      languageCode: 'ko-KR',
    );
  }

  Future<List<int>> _getAudioContent(String filePath) async {
    return File(filePath).readAsBytesSync().toList();
  }
}