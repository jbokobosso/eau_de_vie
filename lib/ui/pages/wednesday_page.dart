import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:eau_de_vie/states/playing_provider.dart';
import 'package:eau_de_vie/ui/widgets/no_network.dart';
import 'package:eau_de_vie/ui/widgets/playing_banner.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WednesdayPage extends StatefulWidget {
  const WednesdayPage({Key? key}) : super(key: key);

  @override
  _WednesdayPageState createState() => _WednesdayPageState();
}

class _WednesdayPageState extends State<WednesdayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Eau De Vie'), centerTitle: true),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(FileAssets.listenBanner),
                Text('Messages Mercredi', style: Theme.of(context).textTheme.headline1)
              ],
            ),
            Expanded(
              child: FutureBuilder<List<RecordingModel>>(
                future: Provider.of<AppProvider>(context, listen: false).getRecordings(ERecordingType.wednesday), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List<RecordingModel>> snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  } else if(snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(243, 243, 243, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2, offset: Offset(10.0, 6.0))
                              ]
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(FileAssets.sunday),
                            ),
                            title: Text( Utils.formatDateToHuman(snapshot.data![index].timestamp.toDate()),style: Theme.of(context).textTheme.bodyText2),
                            trailing: SizedBox(
                              width: MediaQuery.of(context).size.width*0.25,
                              child: Row(
                                children: [
                                  Text(
                                      Provider.of<AppProvider>(context, listen: false).formatDurationToString(Duration(milliseconds: snapshot.data![index].soundDurationInMilliseconds))
                                  ),
                                  snapshot.data![index].isDownloaded
                                      ? const SizedBox(height: 0, width: 0)
                                      : Provider.of<PlayingProvider>(context, listen: true).isDownloading && Provider.of<PlayingProvider>(context, listen: true).downloadingSoundId == snapshot.data![index].id
                                      ? const CircularProgressIndicator()
                                      : IconButton(
                                      icon: const Icon(Icons.download),
                                      onPressed: () async {
                                        await Provider.of<PlayingProvider>(context, listen: false).downloadSound(snapshot.data![index]);
                                        setState(() {

                                        });
                                      }
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              if(snapshot.data![index].isDownloaded) {
                                Provider.of<PlayingProvider>(context, listen: false).setPlayingSound(snapshot.data![index]);
                                Navigator.of(context).pushNamed(RouteNames.playing_page, arguments: snapshot.data![index]);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Veuillez télécharger d'abord"),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              }
                            },
                          ),
                        )
                    );
                  } else if(snapshot.hasError) {
                    throw snapshot.error!;
                    return NotNetwork(() => Utils.showToast("Recharger la page"));
                  }
                  return NotNetwork(() => Utils.showToast("Recharger la page"));
                },
              ),
            ),
            const PlayingBanner()
          ],
        )
    );
  }
}

