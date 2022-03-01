import 'package:cloud_firestore/cloud_firestore.dart';

class RecordingModel{
  String? id;
  String soundFile;
  Timestamp timestamp;
  String downloadUrl;

  RecordingModel({required this.soundFile, required this.timestamp, required this.downloadUrl, this.id});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "soundFile": soundFile,
      "timestamp": timestamp,
      "downloadUrl": downloadUrl
    };
  }

  static RecordingModel fromMap(Map<String, dynamic> firebaseData, String id) {
    return RecordingModel(
        id: id,
        soundFile: firebaseData['soundFile'],
        timestamp: firebaseData['timestamp'],
        downloadUrl: firebaseData['downloadUrl']
    );
  }
}