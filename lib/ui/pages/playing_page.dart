import 'package:eau_de_vie/constants/file_assets.dart';
import 'package:eau_de_vie/utils/utils.dart';
import 'package:flutter/material.dart';

class PlayingPage extends StatelessWidget {
  const PlayingPage({Key? key}) : super(key: key);

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
                  width: MediaQuery.of(context).size.width*0.7,
                  height: MediaQuery.of(context).size.width*0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(33, 38, 63, 1)
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.1,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color.fromRGBO(255, 255, 255, 0.4)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Vaincre la peur du péché', style: Theme.of(context).textTheme.headline2),
                        Text('Pst Marcello TUNASI', style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.1,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Color.fromRGBO(255, 255, 255, 0.5)
                  ),
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
          ),
        )
    );
  }
}
