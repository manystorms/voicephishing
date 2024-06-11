import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TextClassifier {
  late Interpreter _interpreter;
  late Map<String, int> _wordIndex;
  static const int _inputLength = 150;
  static const String _modelPath = 'assets/AnalyzeVoice.tflite';
  static const String _tokenizerAssetPath = 'assets/tokenizer.json';

  Future<void> initialize() async {
    await _loadModel();
    await _loadTokenizer();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelPath);
  }

  Future<void> _loadTokenizer() async {
    try {
      final String tokenizerJson = await rootBundle.loadString(_tokenizerAssetPath);
      if (tokenizerJson.isEmpty) {
        throw Exception("Tokenizer JSON file is empty or not loaded properly.");
      }
      final Map<String, dynamic> tokenizerMap = json.decode(tokenizerJson);
      if (!tokenizerMap.containsKey('word_index')) {
        throw Exception("word_index key is missing in the tokenizer JSON data.");
      }
      _wordIndex = Map<String, int>.from(tokenizerMap['word_index']);

      // <OOV> 토큰에 대한 인덱스 보장
      if (!_wordIndex.containsKey('<OOV>')) {
        _wordIndex['<OOV>'] = 1;  // 예시: 1로 설정, 모델에 맞게 조정 필요
      }
    } catch (e) {
      print("Error loading tokenizer: $e");
      rethrow;
    }
  }

  List<int> _tokenize(String text) {
    // 텍스트를 단어로 분할
    List<String> words = text.split(' ');

    // 각 단어를 인덱스로 변환, 최대 인덱스를 넘는 경우 <OOV> 인덱스 사용
    List<int> tokens = words.map((word) {
      int? index = _wordIndex[word];
      if (index == null || index >= 200) {  // 여기서 200은 모델의 최대 인덱스 범위
        return _wordIndex['<OOV>']!;
      }
      return index;
    }).toList();

    // 토큰 배열을 적절한 길이로 조정
    if (tokens.length < _inputLength) {
      tokens.addAll(List<int>.filled(_inputLength - tokens.length, 0));
    } else if (tokens.length > _inputLength) {
      tokens = tokens.sublist(0, _inputLength);
    }

    return tokens;
  }

  Future<double> classifyText(String text) async {
    final input = _tokenize(text);
    final output = List.filled(1, 0.0).reshape([1, 1]);

    _interpreter.run(input.reshape([1, _inputLength]), output);

    return output[0][0];
  }

  void dispose() {
    _interpreter.close();
  }
}
