import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:eau_de_vie/models/recording_model.dart';
import 'package:eau_de_vie/states/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SundayPage extends StatefulWidget {
  const SundayPage({Key? key}) : super(key: key);

  @override
  _SundayPageState createState() => _SundayPageState();
}

class _SundayPageState extends State<SundayPage> {

  @override
  initState() {
    super.initState();
  }

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
                Text('Messages Dimanche', style: Theme.of(context).textTheme.headline1)
              ],
            ),
            Expanded(
              child: FutureBuilder<List<RecordingModel>>(
                future: Provider.of<AppProvider>(context, listen: false).getRecordings(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List<RecordingModel>> snapshot) {
                  if(snapshot.hasData) {
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
                            title: Text(
                                "${snapshot.data![index].timestamp.toDate().day.toString()}/"
                                    "${snapshot.data![index].timestamp.toDate().month.toString()}/"
                                    "${snapshot.data![index].timestamp.toDate().year.toString()}",
                                style: Theme.of(context).textTheme.bodyText2
                            ),
                            // trailing: Text('10:35', style: TextStyle(color: Colors.black)),
                            onTap: () => Navigator.of(context).pushNamed(RouteNames.playing_page),
                          ),
                        )
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        )
    );
  }
}

