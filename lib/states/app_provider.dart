import 'dart:async';
import 'dart:io';

import 'package:eau_de_vie/models/recording_state.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AppProvider extends ChangeNotifier {

  Duration get recordDuration => _recordDuration;
  Duration _recordDuration = const Duration(minutes: 0, seconds: 0);
  Duration get playbackPosition => _playbackPosition;
  Duration get soundDuration => _soundDuration;
  AudioPlayer get player => _player;
  String get recordedPath => _recordedPath;
  ERecordingState get recordingState => _recordingState;
  ERecordingState _recordingState = ERecordingState.init;
  Record get record => _record;
  final Record _record = Record();
  late String _recordedPath = "";
  final _player = AudioPlayer();
  late Duration _soundDuration = const Duration(minutes: 0, seconds: 0);
  late Duration _playbackPosition = const Duration(minutes: 0, seconds: 0);

  void setPlaybackPosition(double newSliderValue) {
    var newPlaybackPositionInSeconds = (newSliderValue * _soundDuration.inSeconds).ceil();
    var newPlaybackPositionInDuration = Duration(seconds: newPlaybackPositionInSeconds);
    _player.seek(newPlaybackPositionInDuration);
    notifyListeners();
  }

  String formatDurationToString(Duration duration) {
    int durationInSeconds = duration.inSeconds;
    if(durationInSeconds <= 60) {
      var seconds = durationInSeconds < 10 ? '0$durationInSeconds' : durationInSeconds;
      return "00:$seconds";
    } else {
      var minutesTemp = (durationInSeconds/60).floor();
      var minutes = minutesTemp < 10 ? '0$minutesTemp' : minutesTemp;
      var seconds = durationInSeconds%60;
      return "$minutes:$seconds";
    }
  }

  void timerForRecording() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordDuration = Duration(seconds: _recordDuration.inSeconds+1);
      if(_recordingState == ERecordingState.stoped || _recordingState == ERecordingState.init) {
        timer.cancel();
        _recordDuration = const Duration(minutes: 0, seconds: 0);
      }
      notifyListeners();
    });
  }

  void recordVoice() async {
    bool result = await _record.hasPermission();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await _record.start(
      path: '${appDocDir.path}/sound.m4a', // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
    timerForRecording();
    _recordingState = ERecordingState.recording;
    notifyListeners();
    _recordedPath = '${appDocDir.path}/sound.m4a';
    Utils.showToast(recordingState.toString());
  }

  void stopRecording() async {
    _record.stop();
    _recordingState = ERecordingState.stoped;
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
    _soundDuration = duration!;
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
    listenPlaybackEvents();
    listenPlaybackPosition();
  }

  listenPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      if(event.processingState == ProcessingState.completed) {
        stop();
        notifyListeners();
      }
    });
  }

  listenPlaybackPosition() {
    _player.positionStream.listen((Duration positionEvent) {
      _playbackPosition = positionEvent;
      notifyListeners();
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

  void accelerate() {
    if(_player.speed == 1.0) {
      _player.setSpeed(1.5);
    } else if(_player.speed == 1.5) {
      _player.setSpeed(2.0);
    } else {
      _player.setSpeed(1.0);
    }
    notifyListeners();
  }

}