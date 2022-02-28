import 'package:cloud_firestore/cloud_firestore.dart';

class RecordingModel{
  String? id;
  String soundFile;
  Timestamp timestamp;

  RecordingModel({required this.soundFile, required this.timestamp, this.id});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "soundFile": soundFile,
      "timestamp": timestamp
    };
  }

  RecordingModel fromMap(RecordingModel recordingModel, String id) {
    return RecordingModel(id: id, soundFile: recordingModel.soundFile, timestamp: recordingModel.timestamp);
  }
}