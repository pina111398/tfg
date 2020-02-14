import 'package:flutter/material.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/chat.dart';
import 'package:game/repositorio.dart' as db;

class Conversaciones extends StatefulWidget {
  final TooBook tooBook;

  Conversaciones({this.tooBook});
  @override
  _ConversacionesState createState() => _ConversacionesState();
}

class _ConversacionesState extends State<Conversaciones> {
  
  List<Conversacion> conversaciones = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getConversaciones();
  }
  
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.tooBook.titulo),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.info),
            )
          ],
        ),
        body: conversaciones.length != 0 ?
            ListView.builder(
              itemBuilder: (BuildContext ctx, int index){
                return InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chat(conversacion: conversaciones[index])),
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
                            Text(conversaciones[index].para,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(conversaciones[index].esGrupo.toString()),
                          ],
                        ),
                      ),
                      Divider(height: 5,)
                    ],
                  ),
                );
              },
              itemCount: conversaciones.length,
            )
            :
            Center(child: Text("Vacio"),),
      );
  }
  _getConversaciones() async{
    List<Conversacion> conv = await db.fetchChats(widget.tooBook.idToobook);
    setState(() {
      conversaciones = conv;
    });
  }
}