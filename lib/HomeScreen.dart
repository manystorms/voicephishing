import 'package:flutter/material.dart';
import 'package:voicephishing/model/get_FilePath.dart';
import 'package:voicephishing/ResultScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoicePhishingDetector(),
    );
  }
}

class VoicePhishingDetector extends StatefulWidget {
  @override
  _VoicePhishingDetectorState createState() => _VoicePhishingDetectorState();
}

class _VoicePhishingDetectorState extends State<VoicePhishingDetector> {
  List<AudioFile> AudioFileList = [];
  bool _isAnalyzing = false;

  Future<void> _updateAudioFileList() async {
    setState(() {
      _isAnalyzing = true;
    });

    ManageFilePath a = ManageFilePath();
    AudioFileList = await a.getFileList();

    print('aaaa');
    for (AudioFile file in AudioFileList) {
      print("Path: ${file.Path}, Name: ${file.Name}, Date: ${file.ShowingDate}");
    }

    setState(() {
      _isAnalyzing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateAudioFileList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: <Widget>[
              _isAnalyzing ? CircularProgressIndicator() : Container(),
              Expanded(child:
                RefreshIndicator(
                  onRefresh: _updateAudioFileList,
                  child: ListView.builder(
                    itemCount: AudioFileList.length,
                    itemBuilder: (context, index) {
                      AudioFile file = AudioFileList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResultScreen(audioFile: file)),
                          );
                        },
                          child: Container(
                            margin: EdgeInsets.all(5), // 각 아이템 간의 간격
                            decoration: BoxDecoration(
                              color: Colors.white, // 배경색
                              border: Border.all(
                                color: Colors.blue, // 테두리 색상
                                width: 1, // 테두리 두께
                              ),
                              borderRadius: BorderRadius.circular(10), // 테두리 둥글게
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(file.Name,
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 25,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      Text(file.ShowingDate),
                                    ],
                                  ),
                                  Icon(
                                    Icons.file_open_rounded,
                                    color: Colors.black,
                                    size: 24.0, // 원하는 크기로 설정 가능
                                  )
                                ],
                              ),
                            ),
                          ),
                      );
                    },
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
