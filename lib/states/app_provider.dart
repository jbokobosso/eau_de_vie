import 'dart:io';

import 'package:eau_de_vie/models/recording_state.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AppProvider extends ChangeNotifier {

  ERecordingState get recordingState => _recordingState;
  ERecordingState _recordingState = ERecordingState.init;
  final Record _record = Record();

  void recordVoice() async {
    bool result = await _record.hasPermission();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await _record.start(
      path: '${appDocDir.path}/sound.m4a', // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
    _recordingState = ERecordingState.init;
    notifyListeners();
    Utils.showToast(recordingState.toString());
  }

  void stopRecording() async {
    _record.stop();
    _recordingState = ERecordingState.stoped;
    notifyListeners();
    Utils.showToast(recordingState.toString());
  }

}