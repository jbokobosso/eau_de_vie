import 'dart:io';

import 'package:eau_de_vie/models/recording_state.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AppProvider extends ChangeNotifier {

  AudioPlayer get player => _player;
  String get recordedPath => _recordedPath;
  String get soundDuration => _soundDuration;
  ERecordingState get recordingState => _recordingState;
  ERecordingState _recordingState = ERecordingState.init;
  final Record _record = Record();
  late String _recordedPath = "";
  late String _soundDuration = "";
  final _player = AudioPlayer();

  void recordVoice() async {
    bool result = await _record.hasPermission();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await _record.start(
      path: '${appDocDir.path}/sound.m4a', // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
    _recordingState = ERecordingState.recording;
    notifyListeners();
    _recordedPath = '${appDocDir.path}/sound.m4a';
    Utils.showToast(recordingState.toString());
  }

  void stopRecording() async {
    _record.stop();
    _recordingState = ERecordingState.init;
    notifyListeners();
    Utils.showToast(recordingState.toString());
    getRecordedInfo();
  }

  getPlayerState() {
    Utils.showToast(_player.processingState.toString());
    Utils.showToast(_player.playing.toString());
  }

  Future<String?> getRecordedInfo() async {
    Duration? duration = await _player.setFilePath(_recordedPath);
    String? soundTime = duration?.inSeconds.toString();
    _soundDuration = soundTime!;
    notifyListeners();
    return soundTime;
  }

  void play() {
    if(_player.processingState == ProcessingState.idle && !_player.playing){
      _player.setFilePath(_recordedPath);
      _player.play();
      notifyListeners();
    } else if(_player.processingState == ProcessingState.ready && !_player.playing){
      resume();
      notifyListeners();
    } else if(_player.processingState == ProcessingState.completed) {
      _player.setFilePath(_recordedPath);
      _player.play();
      notifyListeners();
    }
    listen();
  }

  listen() {
    _player.playbackEventStream.listen((event) {
      if(event.processingState == ProcessingState.completed) {
        stop();
        notifyListeners();
      }
    });
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void resume() {
    _player.play();
    notifyListeners();
  }

  void stop() {
    _player.stop();
    notifyListeners();
  }

}