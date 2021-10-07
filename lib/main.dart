import 'package:eau_de_vie/constants/core_constants.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/constants/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: CoreConstants.appName,
      theme: CustomTheme.lightTheme,
      routes: routes,
      initialRoute: RouteNames.home,
    );
  }
}
