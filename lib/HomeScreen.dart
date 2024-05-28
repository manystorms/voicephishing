import 'package:flutter/material.dart';
import 'package:voicephishing/get_MP3.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Button App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getAudio MP3 = getAudio();
  String _message = 'hello';

  void _changeMessage() async {
    _message = await MP3.STT("test.wav");

    setState(() {});
  }

  @override
  void initstate() {
    MP3.getAudioPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Button App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _changeMessage,
              child: Text('버튼을 누르세요'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}