import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {

  static ERecordingType getRecordingTypeFromDateTime(DateTime datetime) {
    ERecordingType recordingType;
    switch(datetime.weekday) {
      case 3 : recordingType = ERecordingType.wednesday; break;
      case 7 : recordingType = ERecordingType.sunday; break;
      default:
        recordingType = datetime.weekday > 3 ? ERecordingType.wednesday : ERecordingType.sunday;
      break;
    }
    return recordingType;
  }

  static DateTime checkRecordingTypeWasAdjusted(DateTime datetime) {
    DateTime result = datetime; // if date must not be adjusted, return the correct date that would be the active day
    if(datetime.weekday != 3 && datetime.weekday != 7) {
      if(datetime.weekday > 3) {
        int daysDifference = datetime.weekday-3;
        result = datetime.subtract(Duration(days: daysDifference));
      } else {
        int daysDifference = datetime.weekday;
        result = datetime.subtract(Duration(days: daysDifference));
      }
    }
    return result;
  }

  static void testCheckRecordingTypeWasAdjusted(DateTime datetime) {
    DateTime result = datetime; // if date must not be adjusted, return the correct date that would be the active day
    if(datetime.weekday != 3 && datetime.weekday != 7) {
      if(datetime.weekday > 3) {
        int daysDifference = datetime.weekday-3;
        result = datetime.subtract(Duration(days: daysDifference));
      } else {
        int daysDifference = datetime.weekday;
        result = datetime.subtract(Duration(days: daysDifference));
      }
    }
    Utils.showToast(formatDateToHuman(result));
  }

  static String formatDurationToString(Duration duration) {
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

  static timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static int getAgeFromBirthdate(DateTime birthdate) {
    Duration timeDifference = DateTime.now().difference(birthdate);
    return (timeDifference.inDays/365).ceil();
  }

  static String formatDateToHuman(DateTime datetime) {
    String result;
    String yearmonth = "";
    String weekday = "";
    if(datetime == null) return "";
    switch(datetime.weekday) {
      case 1 : weekday = "Lundi";break;
      case 2 : weekday = "Mardi";break;
      case 3 : weekday = "Mercredi";break;
      case 4 : weekday = "Jeudi";break;
      case 5 : weekday = "Vendredi";break;
      case 6 : weekday = "Samedi";break;
      case 7 : weekday = "Dimanche";break;
    }
    switch(datetime.month) {
      case 1: yearmonth = "Janvier";break;
      case 2: yearmonth = "Février";break;
      case 3: yearmonth = "Mars";break;
      case 4: yearmonth = "Avril";break;
      case 5: yearmonth = "Mai";break;
      case 6: yearmonth = "Juin";break;
      case 7: yearmonth = "Juillet";break;
      case 8: yearmonth = "Août";break;
      case 9: yearmonth = "Septembre";break;
      case 10: yearmonth = "Octobre";break;
      case 11: yearmonth = "Novembre";break;
      case 12: yearmonth = "Decembre";break;
    }
    result = "$weekday ${datetime.day.toString()} $yearmonth ${datetime.year.toString()}";
    return result;
  }

  static String formatTimeToHuman(TimeOfDay time) {
    if(time == null) return "";
    return "${time.hour}:${time.minute}";
  }

  // static showRichTextDialog(String title, RichText richText) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: navigatorKey.currentContext,
  //       builder: (_) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
  //         ),
  //         titlePadding: EdgeInsets.all(0.0),
  //         title: Container(
  //           decoration: BoxDecoration(
  //               color: Colors.red,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
  //           ),
  //           width: double.infinity,
  //           height: 30.0,
  //           child: Align(child: Text(title, style: TextStyle(color: Colors.white)), alignment: Alignment.center),
  //         ),
  //         content: SizedBox(
  //             child: richText
  //         ),
  //         actions: [
  //           TextButton(child: Text("D'accord"), onPressed: () => navigatorKey.currentState.pop()),
  //         ],
  //       )
  //   );
  // }

  // static showDialogBox(String title, String content, {EDialogType dialogType, String animationAsset}) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: navigatorKey.currentContext,
  //       builder: (_) => SizedBox(
  //         child: AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
  //           ),
  //           titlePadding: EdgeInsets.all(0.0),
  //           title: Container(
  //             decoration: BoxDecoration(
  //                 color: dialogType == EDialogType.info ? Colors.blue : dialogType == EDialogType.error ? Colors.red : Colors.amberAccent,
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
  //             ),
  //             width: double.infinity,
  //             height: 30.0,
  //             child: Align(child: Text(title, style: TextStyle(color: Colors.white)), alignment: Alignment.center),
  //           ),
  //           content: SizedBox(
  //             height: deviceHeight*0.3,
  //             child: Column(
  //               children: [
  //                 animationAsset != null ? Expanded(child: Lottie.asset(animationAsset)) : Container(),
  //                 SizedBox(
  //                     child: Text(content, textAlign: TextAlign.center)
  //                 )
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(child: Text("D'accord"), onPressed: () => navigatorKey.currentState.pop()),
  //           ],
  //         ),
  //       )
  //   );
  // }

  static bool validatePhoneNumber(String phoneNumber) {
    if(phoneNumber.characters.length != 12)
      return false;
    else
      return true;
  }

  static bool validateEmail(String email) {
    if(!email.contains("@"))
      return false;
    else
      return true;
  }

  // static double deviceWidth = MediaQuery.of(navigatorKey.currentState!.context).size.width;
  //
  // static double deviceHeight = MediaQuery.of(navigatorKey.currentState!.context).size.height;

}