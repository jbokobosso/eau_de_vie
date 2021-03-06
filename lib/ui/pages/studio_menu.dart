import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/models/recording_type.dart';
import 'package:flutter/material.dart';

class StudioMenu extends StatelessWidget {
  final double iconScale = 0.15;
  const StudioMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eau De Vie'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(FileAssets.studioBanner),
              Text('STUDIO', style: Theme.of(context).textTheme.headline1)
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Image.asset(FileAssets.sunday),
                  iconSize: MediaQuery.of(context).size.height*iconScale,
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.recording, arguments: ERecordingType.sunday),
                ),
                IconButton(
                  icon: Image.asset(FileAssets.wednesday),
                  iconSize: MediaQuery.of(context).size.height*iconScale,
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.recording, arguments: ERecordingType.wednesday),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
