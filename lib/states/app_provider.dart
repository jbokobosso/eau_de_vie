import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eau_de_vie/constants/core_constants.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:eau_de_vie/models/recording_state.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nanoid/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
  late Duration _soundDuration = const Duration(seconds: 117); // initializing with arbitrary duration for first render before initState is fired
  late Duration _playbackPosition = const Duration(minutes: 0, seconds: 0);
  double get uploadPercentage => _uploadPercentage;
  double _uploadPercentage = 0.0;
  bool get isUploading => _isUploading;
  bool _isUploading = false;
  RecordingModel get playingSound => _playingSound;
  late RecordingModel _playingSound;






  /* **************************************************** */
  /* *************          UTILS         ************* */
  /* **************************************************** */
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

  Future<String?> getRecordedFileDuration() async {
    Duration? duration = await _player.setFilePath(_recordedPath);
    String? soundTime = duration?.inSeconds.toString();
    _soundDuration = duration!;
    notifyListeners();
    return soundTime;
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






  /* **************************************************** */
  /* *************     RECORD SOUND         ************* */
  /* **************************************************** */
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

  Future<void> loadLastRecordIfExists() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String lastRecordedPath = '${appDocDir.path}/sound.${CoreConstants.recording_files_extension}';
    if(File(lastRecordedPath).existsSync()) {
      _recordedPath = '${appDocDir.path}/sound.${CoreConstants.recording_files_extension}';
      getRecordedFileDuration();
      notifyListeners();
    } else {
      Utils.showToast("Aucun enregistrement trouvé !");
    }
  }

  void recordVoice() async {
    bool result = await _record.hasPermission();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await _record.start(
      path: '${appDocDir.path}/sound.${CoreConstants.recording_files_extension}', // required
      encoder: AudioEncoder.AAC, // by default
      bitRate: 128000, // by default
      samplingRate: 44100, // by default
    );
    timerForRecording();
    _recordingState = ERecordingState.recording;
    notifyListeners();
    _recordedPath = '${appDocDir.path}/sound.${CoreConstants.recording_files_extension}';
  }

  void stopRecording() async {
    _record.stop();
    _recordingState = ERecordingState.stoped;
    notifyListeners();
    getRecordedFileDuration();
  }




  /* **************************************************** */
  /* *************     PLAYBACK CODE       ************* */
  /* **************************************************** */
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

  void onSliderChange(double newSliderValue) {
    var newPlaybackPositionInSeconds = (newSliderValue * _soundDuration.inSeconds).ceil();
    var newPlaybackPositionInDuration = Duration(seconds: newPlaybackPositionInSeconds);
    _player.seek(newPlaybackPositionInDuration);
    notifyListeners();
  }






  /* ************************************************************** */
  /* *************     SEND RECORDING TO CLOUD       ************* */
  /* ************************************************************ */

  void deleteRecordedFile() {
    File recordedFile = File(_recordedPath);
    if(recordedFile.existsSync()) {
      recordedFile.deleteSync();
    }
    notifyListeners();
  }

  Future<dynamic> addRecordingToFirebase(RecordingModel recordingModel) async {
    CollectionReference recordings = FirebaseFirestore.instance.collection(CoreConstants.FCN_recordings);
    return await recordings.doc(recordingModel.id).set(recordingModel.toMap());
  }

  Future<void> sendFileOnCloud() async {
    _isUploading = true;
    notifyListeners();
    File recordedFile = File(_recordedPath);

    try {
      String id = await customAlphabet('23456789abcdef', CoreConstants.recording_files_name_id_length);

      firebase_storage.FirebaseStorage.instance
          .ref('${CoreConstants.FS_recordings}/$id.${CoreConstants.recording_files_extension}')
          .putFile(recordedFile)
          .snapshotEvents.listen((event) async {
        _uploadPercentage = (event.bytesTransferred * 100) / event.totalBytes;
        if(event.totalBytes == event.bytesTransferred) { // for some reason i do not guess yet, this is executing two times. So the second condition is to ensure it do not
          String downloadUrl = await event.ref.getDownloadURL();
          RecordingModel recordingModel = RecordingModel(
            soundDurationInMilliseconds: _soundDuration.inMilliseconds,
            soundFile: "$id.${CoreConstants.recording_files_extension}",
            timestamp: Timestamp.fromDate(DateTime.now()),
            id: id,
            downloadUrl: downloadUrl
          );
          await addRecordingToFirebase(recordingModel);
          _isUploading = false;
          deleteRecordedFile();
          notifyListeners();
        }
      });
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getLocalDownloadedSoundIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> oldRecordedIds = prefs.getStringList(CoreConstants.S_downloaded_sounds) ?? [];
    return oldRecordedIds;
  }

  Future<List<RecordingModel>>  getRecordings() async {
    List<String> downloadedSoundIds = await getLocalDownloadedSoundIds();
    List<RecordingModel> recordingsList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(CoreConstants.FCN_recordings).get();
    querySnapshot.docs.forEach((doc) {
      late RecordingModel recordingModel;
      if(downloadedSoundIds.contains(doc['id'])) {
        recordingModel = RecordingModel(
          id: doc['id'],
          soundFile: doc['soundFile'],
          soundDurationInMilliseconds: doc['soundDurationInMilliseconds'],
          timestamp: doc['timestamp'],
          downloadUrl: doc['downloadUrl'],
          isDownloaded: true
        );
      } else {
        recordingModel = RecordingModel(
            id: doc['id'],
            soundFile: doc['soundFile'],
            soundDurationInMilliseconds: doc['soundDurationInMilliseconds'],
            timestamp: doc['timestamp'],
            downloadUrl: doc['downloadUrl'],
            isDownloaded: false
        );
      }
      recordingsList.add(recordingModel);
    });
    return recordingsList;
  }

}