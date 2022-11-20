import 'package:eau_de_vie/constants/core_constants.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/constants/custom_theme.dart';
import 'package:eau_de_vie/providers/auth_provider.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:eau_de_vie/states/playing_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => PlayingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromRGBO(0, 146, 202, 1),
      title: CoreConstants.appName,
      theme: CustomTheme.lightTheme,
      routes: routes,
      initialRoute: RouteNames.home,
    );
  }
}
