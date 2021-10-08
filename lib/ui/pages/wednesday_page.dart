import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/constants/routes.dart';
import 'package:flutter/material.dart';

class WednesdayPage extends StatelessWidget {
  const WednesdayPage({Key? key}) : super(key: key);

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
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 243, 243, 1),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2, offset: Offset(10.0, 6.0))
                        ]
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(FileAssets.wednesday),
                      ),
                      title: Text('Vaincre la peur du péché', style: Theme.of(context).textTheme.bodyText2),
                      trailing: Text('10:35', style: TextStyle(color: Colors.black)),
                      onTap: () => Navigator.of(context).pushNamed(RouteNames.playing_page),
                    ),
                  )
              ),
            )
          ],
        )
    );
  }
}
