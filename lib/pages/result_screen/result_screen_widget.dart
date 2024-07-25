import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'result_screen_model.dart';
export 'result_screen_model.dart';

import 'package:voicephishing/model/get_FilePath.dart';
import 'package:voicephishing/model/SpeechToText.dart';
import 'package:voicephishing/model/AnalyzeText.dart';

class resultScreenWidget extends StatefulWidget {
  final AudioFile audioFile;
  resultScreenWidget({required this.audioFile});

  @override
  State<resultScreenWidget> createState() => _ResultScreenWidgetState();
}

class _ResultScreenWidgetState extends State<resultScreenWidget>
    with TickerProviderStateMixin {

  bool _isAnalyzing = true;
  String audioText = "";
  List<String> audioSentences = [];
  List<double> audioVoicephishingCheck = [];
  double TotalVoicephishingCheck = 0;
  String VoicePhishingShow = 'waiting';

  Future<void> _getAudioText() async {
    getAudioText speechToTextClass = getAudioText();
    audioText = await speechToTextClass.recognizeAudioFile(widget.audioFile.Path);

    await _getAnalyzeData();

    if(TotalVoicephishingCheck >= 70) {
      VoicePhishingShow = '보이스피싱이 의심됩니다';
    }else{
      VoicePhishingShow = '보이스피싱은 아닌 것으로 확인됩니다';
    }

    _isAnalyzing = false;

    setState(() {});
  }

  Future<void> _getAnalyzeData() async {
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
    } catch (e) {
      print('분류 중 오류가 발생했습니다: $e');
    } finally {
      classifier.dispose();
    }
    print(audioSentences);
    print(audioVoicephishingCheck);
  }


  late ResultScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResultScreenModel());
    _getAudioText();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(-50.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Text(
            widget.audioFile.Name,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  letterSpacing: 0.0,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 6.0),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 1170.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: CircularPercentIndicator(
                                percent: TotalVoicephishingCheck,
                                radius: 90.0,
                                lineWidth: 17.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor:
                                    FlutterFlowTheme.of(context).primary,
                                backgroundColor:
                                    FlutterFlowTheme.of(context).accent4,
                                center: Text(
                                  '${(TotalVoicephishingCheck*100).toStringAsFixed(0)}%',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        fontSize: 35.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                VoicePhishingShow,
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 1170.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: audioSentences.length,  // 리스트 항목 수를 지정, 실제 데이터 크기에 맞게 조정
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(4.0, 12.0, 4.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 2.0,
                                    color: Color(0x520E151B),
                                    offset: Offset(0.0, 1.0),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                                              child: Text(
                                                audioSentences[index],
                                                style: FlutterFlowTheme.of(context).titleLarge.override(
                                                  fontFamily: 'Outfit',
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: const AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                "${(audioVoicephishingCheck[index]*100).toStringAsFixed(0)}%",
                                                textAlign: TextAlign.end,
                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                  fontFamily: 'Outfit',
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
