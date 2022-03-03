import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eau_de_vie/constants/core_constants.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingProvider extends ChangeNotifier {

  AudioPlayer get player => _player;
  final AudioPlayer _player = AudioPlayer();

  double get playbackPositionInDouble => _playbackPositionInDouble;
  double _playbackPositionInDouble = 0;

  Duration get playbackPositionInDuration => _playbackPositionInDuration;
  Duration _playbackPositionInDuration = const Duration(seconds: 0);

  Duration get soundDuration => _soundDuration;
  Duration _soundDuration = const Duration(seconds: 86400); // default huge sound duration to prevent first render errors

  String playingSoundFullPath = "";

  bool isDownloading = false;
  String downloadingSoundId = "";



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

  loadSound(String soundUrl) async {
    await _player.setUrl(soundUrl);
    _soundDuration = _player.duration!;
    notifyListeners();
  }

  listenPlaybackPosition() {
    _player.positionStream.listen((Duration positionEvent) {
      _playbackPositionInDouble = positionEvent.inSeconds.toDouble();
      _playbackPositionInDuration = positionEvent;
      notifyListeners();
    });
  }

  listenPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      if(event.processingState == ProcessingState.completed) {
        stop();
        notifyListeners();
      }
    });
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadSound(RecordingModel recordingModel) async {
    isDownloading = true; notifyListeners();
    downloadingSoundId = recordingModel.id!;
    // First check if already downloaded
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> oldRecordedIds = prefs.getStringList(CoreConstants.S_downloaded_sounds) ?? [];
    if(oldRecordedIds.contains(recordingModel.id)) {
      return;
    }
    // Then if not yet downloaded, download sound to local
    await _requestPermission(Permission.storage);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Dio dio = Dio();
    try {
      var result = await dio.download(recordingModel.downloadUrl, appDocDir.path+"/"+recordingModel.soundFile);
      if(result.statusCode == 200) {
        playingSoundFullPath = appDocDir.path+"/"+recordingModel.soundFile;
        // Finally update local database for the downloaded file
        oldRecordedIds.add(recordingModel.id!);
        prefs.setStringList(CoreConstants.S_downloaded_sounds, oldRecordedIds);
        Utils.showSuccessToast("Succès !");
      }
    } catch(e) {
      if (kDebugMode) {
        Utils.showErrorToast("Erreur, veuillez reéssayer");
        print(e.toString());
      }
    } finally {
      isDownloading = false; notifyListeners();
    }
  }

  play(RecordingModel recordingModel) async {
    // check if downloaded and download it
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocDir.listSync().forEach((element) async {
      if(element.path.contains(recordingModel.soundFile)) {
        await downloadSound(recordingModel);
      }
    });
    // check if is the one playing and pause player
    if(playingSoundFullPath.contains(recordingModel.soundFile)) {
      _player.pause();
      notifyListeners();
    }

    if(_player.processingState == ProcessingState.idle && !_player.playing){
      await _player.setFilePath(playingSoundFullPath);
      await _player.play();
      notifyListeners();
    } else if(_player.processingState == ProcessingState.ready && !_player.playing){
      resume();
      notifyListeners();
    } else if(_player.processingState == ProcessingState.completed) {
      await _player.setFilePath(playingSoundFullPath);
      await _player.play();
      notifyListeners();
    }
    else {
      Utils.showToast(EnumToString.convertToString(_player.processingState));
    }
    listenPlaybackPosition();
    listenPlaybackEvents();
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

  changeSlider(double newSliderValue) {}
}