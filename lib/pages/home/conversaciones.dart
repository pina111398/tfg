import 'package:flutter/material.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/pages/home/chat.dart';

class Conversaciones extends StatefulWidget {
  final String idConversacion;

  Conversaciones({this.idConversacion});
  @override
  _ConversacionesState createState() => _ConversacionesState();
}

class _ConversacionesState extends State<Conversaciones> {

  String idTooBook = "";
  
  List<Conversacion> conversaciones;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conversaciones = _getConversaciones();
  }
  
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.idConversacion),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.info),
            )
          ],
        ),
        body: 
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
                            Text(conversaciones[index].idTooBook),
                          ],
                        ),
                      ),
                      Divider(height: 5,)
                    ],
                  ),
                );
              },
              itemCount: conversaciones.length,
            ),
      );
  }
  List<Conversacion> _getConversaciones(){
    List<Conversacion> conv = [];
    conv.add(Conversacion(idTooBook: "idTooBook",para: "Pedro",esGrupo: false));
    conv.add(Conversacion(idTooBook: "idTooBook",para: "Pepe",esGrupo: false));
    conv.add(Conversacion(idTooBook: "idTooBook",para: "Grupo de amigos",esGrupo: true));
    return conv;
  }
}