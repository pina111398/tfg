import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/widgets/MensajeUI.dart';

class PantallaMensajes extends StatefulWidget {
  final Conversacion conversacion;
  final String idTooBook;
  final String idChat;

  PantallaMensajes({this.conversacion, this.idTooBook, this.idChat});
  @override
  _PantallaMensajesState createState() => _PantallaMensajesState();
}

class _PantallaMensajesState extends State<PantallaMensajes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.conversacion.para),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 40,
                  ),
                  onPressed: () {}),
              VerticalDivider(),
              IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 40,
                  ),
                  onPressed: () {}),
            ],
          ),
          Divider(
            height: 5,
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("toobooks/${widget.idTooBook}/chats/${widget.idChat}/mensajes")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container();
                default:
                  return ListView.builder(
                          itemBuilder: (BuildContext ctx, int index) {
                            return MensajeUI(esGrupo: widget.conversacion.esGrupo,mensaje: Mensaje.fromSnapshot(snapshot.data.documents[index]));
                          },
                          itemCount: snapshot.data.documents.length,
                        );
              }
            },
          ),
          ),
        ],
      ),
    );
  }
}
