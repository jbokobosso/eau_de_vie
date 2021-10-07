import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eau De Vie'), centerTitle: true),
      body: Container(
        child: Text('Hello world !!!'),
      ),
    );
  }
}
