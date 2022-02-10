import 'dart:ui';

import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/models/recording_state.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class Recording extends StatelessWidget {
  Recording({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  child: Consumer<AppProvider>(
                    builder: (context, appProvider, child) => Column(
                      children: [
                        Icon(Icons.mic_rounded, color: Color.fromRGBO(107, 121, 176, 1), size: MediaQuery.of(context).size.width*0.25),
                        appProvider.recordingState == ERecordingState.recording
                            ? Text(appProvider.formatDurationToString(appProvider.recordDuration), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.15))
                            : Text("--:--", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.15)),
                        appProvider.recordingState == ERecordingState.init || appProvider.recordingState == ERecordingState.stoped
                            ? Text('Cliquez sur Démarrer', style: TextStyle(color: Color.fromRGBO(100, 113, 150, 1), fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.04))
                            : Container()
                      ],
                    )
                  ),
                ),
                Consumer<AppProvider>(
                  builder: (context, appProvider, child) => Column(
                    children: [
                      appProvider.recordingState == ERecordingState.init || appProvider.recordingState == ERecordingState.stoped ? ElevatedButton(
                        onPressed: () {
                          Provider.of<AppProvider>(context, listen: false).recordVoice();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width*0.5, MediaQuery.of(context).size.height*0.1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)))
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow, color: Color.fromRGBO(253, 120, 150, 1), size: MediaQuery.of(context).size.width*0.12,),
                            Text('Démarrer', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(100, 113, 150, 1)))
                          ],
                        ),
                      ) : Container(),
                      appProvider.recordingState == ERecordingState.recording ? ElevatedButton(
                        onPressed: () => appProvider.stopRecording(),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(253, 120, 150, 1)),
                            fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width*0.5, MediaQuery.of(context).size.height*0.1)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)))
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.stop, color: Colors.white, size: MediaQuery.of(context).size.width*0.12,),
                            Text('Arrêter', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white))
                          ],
                        ),
                      ) : Container(),
                      const SizedBox(height: 20.0),
                      appProvider.recordedPath != "" && appProvider.recordingState != ERecordingState.recording ? Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(31, 31, 31, 1),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            appProvider.player.playing
                                ? IconButton(icon: const Icon(Icons.pause, color: Colors.white), onPressed: () { appProvider.pause(); })
                                : IconButton(icon: const Icon(Icons.play_arrow, color: Colors.white), onPressed: () { appProvider.play(); }),
                            appProvider.player.playing
                                ? Text(appProvider.formatDurationToString(appProvider.playbackPosition), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.03))
                                : Text(appProvider.formatDurationToString(appProvider.soundDuration), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.03)),
                            Expanded(
                              child: Slider(
                                min: 0,
                                max: 1,
                                inactiveColor: Colors.white,
                                activeColor: Colors.blue,
                                value: (appProvider.playbackPosition.inSeconds / appProvider.soundDuration.inSeconds),
                                onChanged: (newValue) => appProvider.setPlaybackPosition(newValue)),
                            ),
                            IconButton(
                              onPressed: appProvider.accelerate,
                              icon: Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(50.0))
                                ),
                                child: Text(
                                  "${appProvider.player.speed == 1.5 ? 1.5 : appProvider.player.speed.ceil()}x",
                                  style: TextStyle(
                                      color: const Color.fromRGBO(31, 31, 31, 1),
                                      fontSize: MediaQuery.of(context).size.width*0.04
                                  )
                                ),
                              )
                            )
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
