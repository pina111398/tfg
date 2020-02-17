import 'package:flutter/material.dart';

class PantallaMensajes extends StatefulWidget {
  final String nombre;
  final String idTooBook;
  final String idChat;

  PantallaMensajes({this.nombre, this.idTooBook, this.idChat});
  @override
  _PantallaMensajesState createState() => _PantallaMensajesState();
}

class _PantallaMensajesState extends State<PantallaMensajes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.nombre),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add,size: 40,),
                onPressed: (){}),
              VerticalDivider(),
              IconButton(
                icon: Icon(Icons.add,size: 40,),
                onPressed: (){}),
            ],
          ),
          Divider(
            height: 5,
          ),
        ],
      ),
    );
  }
}
