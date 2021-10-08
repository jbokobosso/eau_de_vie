
import 'package:eau_de_vie/ui/pages/home_page.dart';
import 'package:eau_de_vie/ui/pages/playing_page.dart';
import 'package:eau_de_vie/ui/pages/sunday_page.dart';
import 'package:eau_de_vie/ui/pages/wednesday_page.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static String startup = "/startup";
  static String home = "/home";
  static String sunday = "/sunday";
  static String wednesday = "/wednesday";
  static String playing_page = "/playing_page";
}

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  RouteNames.home: (BuildContext context) => const HomePage(),
  RouteNames.sunday: (BuildContext context) => const SundayPage(),
  RouteNames.wednesday: (BuildContext context) => const WednesdayPage(),
  RouteNames.playing_page: (BuildContext context) => const PlayingPage(),
};