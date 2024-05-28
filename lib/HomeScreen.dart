import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class HomeScreen extends StatefulWidget {
  @override
  _TestButton createState() => _TestButton();
}

class _TestButton extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                print('succes');
              });
            },
            child: Text('test'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permission Handler Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PermissionDemo(),
    );
  }
}

class PermissionDemo extends StatefulWidget {
  @override
  _PermissionDemoState createState() => _PermissionDemoState();
}

class _PermissionDemoState extends State<PermissionDemo> {
  @override
  void initState() {
    super.initState();
    _requestStoragePermission(); // 앱이 시작될 때 저장소 접근 권한 요청
  }

  Future<void> _requestStoragePermission() async {
    print('a');
    final status = await Permission.audio.status;
    if (status.isGranted) {
      // 권한이 허용된 경우
      print('저장소 접근 권한이 허용되었습니다.');
    } else {
      // 권한이 거부된 경우
      print('저장소 접근 권한이 거부되었습니다.');
    }
    getMp3FilePath();
  }

  Future<void> getMp3FilePath() async {
    print('b');
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = await getExternalStorageDirectory();
    }
    print('c');
    if (downloadsDirectory != null) {
      print(p.join(downloadsDirectory.path, 'Download', 'test.mp3'));
    }
    print('d');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Handler Demo'),
      ),
      body: Center(
        child: Text('앱이 시작될 때 저장소 접근 권한을 요청합니다.'),
      ),
    );
  }
}