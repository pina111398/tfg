import 'package:flutter/material.dart';

class CreateTB extends StatefulWidget {

  CreateTB({Key key,this.uid}) : super(key: key);

  final String uid;
  @override
  _CreateTBState createState() => _CreateTBState();
}

class _CreateTBState extends State<CreateTB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crea un TooBook"),
      ),
      body: Center(
        child: Text(widget.uid),
      ),
    );
  }
}