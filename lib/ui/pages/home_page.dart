import 'package:eau_de_vie/constants/custom_theme.dart';
import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  final double iconScale = 0.15;
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eau De Vie', style: TextStyle(fontFamily: 'DAYROM'),), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(FileAssets.menuBanner),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Image.asset(FileAssets.sunday),
                  iconSize: MediaQuery.of(context).size.height*iconScale,
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.sunday),
                ),
                IconButton(
                  icon: Image.asset(FileAssets.wednesday),
                  iconSize: MediaQuery.of(context).size.height*iconScale,
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.wednesday),
                ),
                IconButton(
                  icon: Image.asset(FileAssets.record_icon),
                  iconSize: MediaQuery.of(context).size.height*iconScale,
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.studio_menu),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
