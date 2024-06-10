import 'dart:io';
import 'dart:typed_data';
import 'package:vosk_flutter_2/vosk_flutter_2.dart';

Future<String> SpeechToText(String audioFilePath) async {
  final vosk = VoskFlutterPlugin.instance();
  final ModelPath = await ModelLoader()
      .loadFromAssets('assets/vosk-model-small-ko-0.22.zip');
  final model = await vosk.createModel(ModelPath);

  final recognizer = await vosk.createRecognizer(
    model: model,
    sampleRate: 10000,
  );

  File audioFile = File(audioFilePath);
  Uint8List audioBytes = await audioFile.readAsBytes();

  String result = "";

  int pos = 0;
  int chunkSize = 1500; // 처리할 데이터 덩어리의 크기를 정의합니다.
  while (pos + chunkSize < audioBytes.length) {
    bool isFinal = await recognizer.acceptWaveformBytes(
        audioBytes.sublist(pos, pos + chunkSize));
    if (isFinal) {
      final res = await recognizer.getResult();
      result += res;
    }
    pos += chunkSize;
  }

  // 마지막 덩어리의 데이터를 처리합니다.
  bool isFinal = await recognizer.acceptWaveformBytes(
      audioBytes.sublist(pos, audioBytes.length));
  if (isFinal) {
    final res = await recognizer.getResult();
    result += res;
  } else {
    final res = await recognizer.getFinalResult();
    result += res;
  }

  // 인식 결과를 반환합니다.
  return result;
}