import '/flutter_flow/flutter_flow_util.dart';
import 'result_screen_widget.dart' show ResultScreenWidget;
import 'package:flutter/material.dart';

class ResultScreenModel extends FlutterFlowModel<ResultScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
