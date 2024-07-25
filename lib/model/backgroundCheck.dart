import 'dart:async';
import 'dart:ui';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicephishing/model/alert.dart';
import 'package:voicephishing/model/get_FilePath.dart';
import 'package:voicephishing/model/SpeechToText.dart';
import 'package:voicephishing/model/AnalyzeText.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final socket = io.io("your-server-url", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
  socket.onConnect((_) {
    print('Connected. Socket ID: ${socket.id}');
    // Implement your socket logic here
    // For example, you can listen for events or send data
  });

  socket.onDisconnect((_) {
    print('Disconnected');
  });
  socket.on("event-name", (data) {
    //do something here like pushing a notification
  });
  service.on("stop").listen((event) {
    service.stopSelf();
    print("background process is now stopped");
  });

  service.on("start").listen((event) {});

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if(backgroundWorking == false) {
      backgroundWorking = true;
      socket.emit("event-name", "your-message");

      backgroundProcess();

      backgroundWorking = false;
    }
  });
}

bool backgroundWorking = false;

void backgroundProcess() async{
  final lastCheckTime = await getLastCheckTime();
  storeLastCheckTime();

  List<AudioFile> AudioFileList = [];
  List<String> audioSentences = [];
  List<double> audioVoicephishingCheck = [];
  double TotalVoicephishingCheck = 0;
  ManageFilePath a = ManageFilePath();
  AudioFileList = await a.getFileList(true);

  for (AudioFile file in AudioFileList) {
    if(lastCheckTime.isBefore(file.Date)) {
      showPushAlarm('확인중', '통화가 끝난 것이 감지되었습니다: ${file.Name}');

      getAudioText speechToTextClass = getAudioText();
      final audioText = await speechToTextClass.recognizeAudioFile(file.Path);

      audioSentences = audioText.split(RegExp(r'\.\s+'));
      audioVoicephishingCheck.clear();

      final classifier = TextClassifier();

      await classifier.initialize();

      try {
        int TotalAudioTextLen = 0;
        double TotalRes = 0;
        for (String text in audioSentences) {
          double result = await classifier.classifyText(text);
          audioVoicephishingCheck.add(result);
          print("문자: $text, 예측 결과: $result");

          TotalAudioTextLen = TotalAudioTextLen+text.length;
          TotalRes = TotalRes+text.length*result;
        }
        TotalVoicephishingCheck = TotalRes/TotalAudioTextLen.toDouble();

        if(TotalVoicephishingCheck*100 >= 70) {
          showPushAlarm(
              '보이스피싱 의심',
              '해당 통화가 보이스피싱일 가능성이 $TotalVoicephishingCheck% 입니다(파일명: ${file.Name})'
          );
        }else{
          showPushAlarm(
              '보이스피싱 의심',
              '해당 통화는 보이스피싱이 아닙니다(파일명: ${file.Name})'
          );
        }
      } catch (e) {
        print('분류 중 오류가 발생했습니다: $e');
      } finally {
        classifier.dispose();
      }
    }
  }
  print("백그라운드 실행: $lastCheckTime");
}


void storeLastCheckTime() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('time', DateTime.now().toString());
}

Future<DateTime> getLastCheckTime() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  final storedData = pref.getString('time');
  if(storedData == null) {
    return DateTime(1970, 1, 1);
  }else{
    return DateTime.parse(storedData);
  }
}