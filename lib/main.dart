import 'package:eau_de_vie/constants/core_constants.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/constants/custom_theme.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
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
      color: const Color.fromRGBO(98, 0, 238, 1),
      title: CoreConstants.appName,
      theme: CustomTheme.lightTheme,
      routes: routes,
      initialRoute: RouteNames.home,
    );
  }
}
