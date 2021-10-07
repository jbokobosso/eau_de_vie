
import 'package:eau_de_vie/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static String startup = "/startup";
  static String home = "/home";
}

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder> {
  RouteNames.home: (BuildContext context) => const HomePage(),
};