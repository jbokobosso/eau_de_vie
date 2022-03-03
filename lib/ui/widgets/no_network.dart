import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:flutter/material.dart';

class NotNetwork extends StatefulWidget {
  final Function callback;
  const NotNetwork(this.callback, {Key? key}) : super(key: key);

  @override
  _NotNetworkState createState() => _NotNetworkState();
}

class _NotNetworkState extends State<NotNetwork> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(FileAssets.noNetwork, width: MediaQuery.of(context).size.width*0.3,),
            const Text('Impossible de se connecter'),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Recharger'),
              onPressed: () => widget.callback(),
            )
          ],
        )
    );
  }
}
