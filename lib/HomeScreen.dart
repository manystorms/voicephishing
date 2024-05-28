import 'package:flutter/material.dart';

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
