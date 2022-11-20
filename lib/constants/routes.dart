
import 'package:eau_de_vie/ui/pages/auth/otp_page.dart';
import 'package:eau_de_vie/ui/pages/auth/phone_verification_page.dart';
import 'package:eau_de_vie/ui/pages/home_page.dart';
import 'package:eau_de_vie/ui/pages/playing_page.dart';
import 'package:eau_de_vie/ui/pages/recording_page.dart';
import 'package:eau_de_vie/ui/pages/studio_menu.dart';
import 'package:eau_de_vie/ui/pages/sunday_page.dart';
import 'package:eau_de_vie/ui/pages/wednesday_page.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static String startup = "/startup";
  static String home = "/home";
  static String sunday = "/sunday";
  static String wednesday = "/wednesday";
  static String playing_page = "/playing_page";
  static String studio_menu = "/studio_menu";
  static String recording = "/recording";
  static String otp = "/otp";
  static String phone_verification = "/phone_verification";
}

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  RouteNames.home: (BuildContext context) => const HomePage(),
  RouteNames.sunday: (BuildContext context) => const SundayPage(),
  RouteNames.wednesday: (BuildContext context) => const WednesdayPage(),
  RouteNames.playing_page: (BuildContext context) => const PlayingPage(),
  RouteNames.studio_menu: (BuildContext context) => const StudioMenu(),
  RouteNames.recording: (BuildContext context) => const Recording(),
  RouteNames.otp: (BuildContext context) => const OtpPage(),
  RouteNames.phone_verification: (BuildContext context) => const PhoneVerificationPage()
};