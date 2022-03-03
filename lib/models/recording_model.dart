import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum ERecordingType {
  wednesday,
  sunday,
  test
}

class RecordingModel{
  String? id;
  String soundFile;
  Timestamp timestamp;
  String downloadUrl;
  bool isDownloaded;
  int soundDurationInMilliseconds;
  ERecordingType recordingType;


  RecordingModel({
    required this.soundDurationInMilliseconds,
    required this.soundFile,
    required this.timestamp,
    required this.downloadUrl,
    required this.recordingType,
    this.id,
    this.isDownloaded = false
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "soundFile": soundFile,
      "timestamp": timestamp,
      "downloadUrl": downloadUrl,
      "soundDurationInMilliseconds": soundDurationInMilliseconds,
      "recordingType": EnumToString.convertToString(recordingType)
    };
  }

  static RecordingModel fromMap(Map<String, dynamic> firebaseData, String id) {
    return RecordingModel(
      id: id,
      soundFile: firebaseData['soundFile'],
      timestamp: firebaseData['timestamp'],
      downloadUrl: firebaseData['downloadUrl'],
      soundDurationInMilliseconds: firebaseData['soundDurationInMilliseconds'],
      recordingType: EnumToString.fromString([ERecordingType.wednesday, ERecordingType.sunday, ERecordingType.test], firebaseData['recordingType'])!
    );
  }
}