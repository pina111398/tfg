import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/blocs/bloc_misToobooks/misTB_bloc.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/chat.dart';
import 'package:game/pages/home/infoTooBook.dart';
import 'package:game/repositorio.dart' as db;

class Conversaciones extends StatefulWidget {
  final TooBook tooBook;
  final String uid;

  Conversaciones({this.tooBook, this.uid});
  @override
  _ConversacionesState createState() => _ConversacionesState();
}

class _ConversacionesState extends State<Conversaciones> {
  List<Conversacion> conversaciones = [];

  bool estaLeyendo = false;
  bool cargandoLeyendo = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getConversaciones();
    _getLeyendo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tooBook.titulo),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: cargandoLeyendo
                      ? Container(
                          height: 12,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        )
                      : estaLeyendo
                          ? IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _quitarLeyendo();
                              })
                          : IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {
                                _anadirLeyendo();
                              })),
              Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoTooBook(
                                    toobook: widget.tooBook,
                                  )),
                        );
                      })),
            ],
          ),
        ],
      ),
      body: conversaciones.length != 0
          ? ListView.builder(
              itemBuilder: (BuildContext ctx, int index) {
                return InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chat(
                              toobookId: widget.tooBook.idToobook,
                              conversacion: conversaciones[index])),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              conversaciones[index].para,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5,
                      )
                    ],
                  ),
                );
              },
              itemCount: conversaciones.length,
            )
          : Center(
              child: Text("Vacio"),
            ),
    );
  }

  _quitarLeyendo() async {
    await db.quitarLeyendo(widget.uid, widget.tooBook.idToobook);
    setState(() {
      estaLeyendo = false;
    });
  }

  _anadirLeyendo() async {
    await db.anadirLeyendo(widget.uid, widget.tooBook.idToobook);
    setState(() {
      estaLeyendo = true;
    });
  }

  _getConversaciones() async {
    List<Conversacion> conv = await db.fetchChats(widget.tooBook.idToobook);
    setState(() {
      conversaciones = conv;
    });
  }

  _getLeyendo() async {
    bool leyendo =
        await db.usuarioLeyendoTooBook(widget.uid, widget.tooBook.idToobook);
    setState(() {
      cargandoLeyendo = false;
      estaLeyendo = leyendo;
    });
  }
}
