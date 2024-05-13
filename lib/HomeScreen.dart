import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
    final status = await Permission.storage.status;
    if (status.isGranted) {
      // 권한이 허용된 경우
      print('저장소 접근 권한이 허용되었습니다.');
    } else {
      // 권한이 거부된 경우
      print('저장소 접근 권한이 거부되었습니다.');
    }
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