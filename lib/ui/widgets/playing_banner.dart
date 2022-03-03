import 'package:eau_de_vie/states/playing_provider.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PlayingBanner extends StatefulWidget {
  const PlayingBanner({Key? key}) : super(key: key);

  @override
  _PlayingBannerState createState() => _PlayingBannerState();
}

class _PlayingBannerState extends State<PlayingBanner> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayingProvider>(
      builder: (context, playingProvider, child) =>
      (
          playingProvider.player.processingState == ProcessingState.ready
              && playingProvider.player.processingState != ProcessingState.idle
      )
          ? Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            )
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.1,
        child: ListTile(
          leading: playingProvider.player.playing
              ? IconButton(icon: Icon(Icons.pause, color: Colors.white, size: MediaQuery.of(context).size.width*0.10), onPressed: playingProvider.pause)
              : IconButton(icon: Icon(Icons.play_arrow, color: Colors.white, size: MediaQuery.of(context).size.width*0.12), onPressed: playingProvider.resume),
          title: GestureDetector(
            onTap: () => Utils.showToast(playingProvider.player.processingState.name),
              child: Text(Utils.formatDateToHuman(playingProvider.soundInfos.timestamp.toDate()), style: Theme.of(context).textTheme.headline2)
          ),
          subtitle: Text(Utils.formatDurationToString(playingProvider.playbackPositionInDuration), style: Theme.of(context).textTheme.subtitle1),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width*0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(Utils.formatDurationToString(playingProvider.soundDuration), style: Theme.of(context).textTheme.headline2),
                IconButton(icon: Icon(Icons.stop, color: Colors.white, size: MediaQuery.of(context).size.width*0.10), onPressed: playingProvider.stop)
              ],
            ),
          ),
        ),
      )
          : const SizedBox(height: 0),
    );
  }
}
