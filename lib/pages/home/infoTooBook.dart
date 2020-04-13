import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';

class InfoTooBook extends StatelessWidget {

  final TooBook toobook;

  InfoTooBook({this.toobook});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toobook.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(toobook.sinopsis)
          ],
        ),
      ),
    );
  }
}