import 'dart:io';

import 'package:blur/blur.dart';
import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:eau_de_vie/states/playing_provider.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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


  // loadSoundInfos() async {
  //   RecordingModel playingSound = Provider.of<AppProvider>(context, listen: false).playingSound;
  //   await Provider.of<PlayingProvider>(context, listen: false).loadSound(playingSound.downloadUrl);
  // }

  @override
  Widget build(BuildContext context) {

    RecordingModel playingSound = ModalRoute.of(context)!.settings.arguments as RecordingModel;

    return Scaffold(
        appBar: AppBar(title: const Text('Eau De Vie'), centerTitle: true),
        body: Consumer<PlayingProvider>(
          builder: (context, playingProvider, child) => Container(
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
                  // Container(
                  //   padding: EdgeInsets.all(20.0),
                  //   width: MediaQuery.of(context).size.width*0.7,
                  //   height: MediaQuery.of(context).size.width*0.7,
                  //   decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Color.fromRGBO(33, 38, 63, 1)
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Icon(Icons.play_arrow, color: const Color.fromRGBO(107, 121, 176, 1), size: MediaQuery.of(context).size.width*0.25),
                  //       Text('00:01', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.15))
                  //     ],
                  //   ),
                  // ),
                  SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      size: MediaQuery.of(context).size.width*0.5
                    ),
                    initialValue: playingProvider.playbackPositionInDouble,
                    min: 0,
                    max: playingProvider.soundDuration.inSeconds.toDouble(),
                    innerWidget: (double value) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.headset, color: Colors.blue, size: MediaQuery.of(context).size.width*0.25),
                        Text(
                          playingProvider.formatDurationToString(playingProvider.playbackPositionInDuration),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.10)
                        )
                      ],
                    ),
                  ),
                  // Slider(
                  //     min: 0,
                  //     max: playingProvider.soundDuration.inSeconds.toDouble(),
                  //     inactiveColor: Colors.white,
                  //     activeColor: Colors.blue,
                  //     value: playingProvider.playbackPositionInDouble,
                  //     onChanged: null
                  // ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Blur(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                            Text(Utils.formatDateToHuman(playingSound.timestamp.toDate()), style: Theme.of(context).textTheme.headline1),
                            Text("Temps d'écoute: ${playingProvider.formatDurationToString(playingProvider.soundDuration)}", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Blur(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(icon: Image.asset(FileAssets.rewind), onPressed: () => playingProvider.onSeekBackward()),
                                    playingProvider.player.playing
                                        ? IconButton(icon: Icon(Icons.pause, color: Colors.white, size: MediaQuery.of(context).size.width*0.12), onPressed: playingProvider.pause)
                                        : IconButton(icon: Icon(Icons.play_arrow, color: Colors.white, size: MediaQuery.of(context).size.width*0.12), onPressed: () => playingProvider.play(playingSound)),
                                    IconButton(icon: Image.asset(FileAssets.forward), onPressed: () => playingProvider.onSeekForward()),
                                    IconButton(
                                        icon: Text(
                                            "${playingProvider.player.speed == 1.5 ? "1.5x" : playingProvider.player.speed.ceil()}x",
                                            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.05)
                                        ),
                                        onPressed: () => playingProvider.onAccelerate()
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}

