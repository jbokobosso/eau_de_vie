import 'dart:io';

import 'package:blur/blur.dart';
import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingPage extends StatefulWidget {
  const PlayingPage({Key? key}) : super(key: key);

  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    RecordingModel playingSound = ModalRoute.of(context)!.settings.arguments as RecordingModel;
    Utils.showToast(playingSound.downloadUrl);

    return Scaffold(
        appBar: AppBar(title: const Text('Eau De Vie'), centerTitle: true),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(FileAssets.background),
                fit: BoxFit.cover
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Dimanches', style: Theme.of(context).textTheme.headline1),
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width*0.7,
                  height: MediaQuery.of(context).size.width*0.7,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(33, 38, 63, 1)
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.play_arrow, color: const Color.fromRGBO(107, 121, 176, 1), size: MediaQuery.of(context).size.width*0.25),
                      Text('00:01', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.15))
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Blur(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        blur: 3,
                        blurColor: Colors.white,
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          height: MediaQuery.of(context).size.height*0.1,
                        )
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(playingSound.timestamp.toDate().toIso8601String(), style: Theme.of(context).textTheme.headline2),
                          Text(Utils.formatDateToHuman(playingSound.timestamp.toDate()), style: Theme.of(context).textTheme.subtitle2),
                        ],
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Blur(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        blur: 3,
                        blurColor: Colors.white,
                        child: Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            height: MediaQuery.of(context).size.height*0.1
                        )
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.1,
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(icon: Image.asset(FileAssets.rewind), onPressed: () { print('Pressed'); }),
                              IconButton(icon: Image.asset(FileAssets.play), onPressed: () { print('Pressed'); }),
                              IconButton(icon: Image.asset(FileAssets.forward), onPressed: () { print('Pressed'); }),
                              IconButton(icon: Image.asset(FileAssets.accelerate), onPressed: () { print('Pressed'); }),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}

