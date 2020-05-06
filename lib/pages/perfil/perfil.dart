import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/models/usuario.dart';
import 'package:game/pages/perfil/ajustes.dart';
import 'package:provider/provider.dart';
import 'package:game/repositorio.dart' as db;
import 'package:game/providers/theme.dart';

class Perfil extends StatefulWidget {
  Perfil({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  int numPublicaciones;
  bool cargadoNumPublicaciones;
  Usuario usuario;
  bool cargadoUsuario;
  bool publicos = true;
  Future _publicos;
  Future _privados;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNumPublicaciones(widget.uid);
    _getdatosUsuario(widget.uid);
    _publicos = _getPublicos(widget.uid);
    _privados = _getPrivados(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    cargadoUsuario ?
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Ajustes(usuario: usuario,)))
                    : null;
                  },
                ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8),
                  child: cargadoUsuario
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage("${usuario.fotoPerfil}"),
                              backgroundColor: Colors.transparent,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${usuario.nombre} ${usuario.apellido}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${usuario.email}",
                                  ),
                                  Container(
                                      width: 200,
                                      child: Text(
                                        "${usuario.descripcion}",
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ))
                                ],
                              ),
                            )
                          ],
                        )
                      : Center(child: CircularProgressIndicator())),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(
                    child: cargadoNumPublicaciones
                        ? Text("$numPublicaciones publicaciones")
                        : CircularProgressIndicator(),
                    onPressed: () {}),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: ()=>
                  setState((){
                    publicos = true;
                  }),
                  child: Row(
                    children: <Widget>[
                      Text("Publicos "),
                      Icon(Icons.check_circle,color: Colors.green,)
                    ],
                  ),
                ),
                VerticalDivider(color: Colors.red,width: 4,),
                GestureDetector(
                  onTap: ()=>
                  setState((){
                    publicos = false;
                  }),
                  child: Row(
                    children: <Widget>[
                      Text("Privados "),
                      Icon(Icons.do_not_disturb_on,color: Colors.red,)
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            publicos ? 
              FutureBuilder(
                future: _publicos,
                builder: (BuildContext context,snapshot) {
                if (snapshot.hasData){
                  return Expanded(
                    child: snapshot.data.length > 0?
                      ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return Column(
                            children: <Widget>[
                              ListTile(title:Text(snapshot.data[index].titulo)),
                              Divider()
                            ],
                          );
                      }): Center(child: Text("No tienes TooBooks públicos"))
                  );
                }else if (snapshot.hasError){
                  return new Text('Error: ${snapshot.error}');
                }else{
                  return CircularProgressIndicator();
                }
                }
              )
            :
            FutureBuilder(
                future: _privados,
                builder: (BuildContext context,snapshot) {
                if (snapshot.hasData){
                  return Expanded(
                    child: 
                    snapshot.data.length > 0?
                      ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return Column(
                            children: <Widget>[
                              ListTile(title:Text(snapshot.data[index].titulo)),
                              Divider()
                            ],
                          );
                      }): Center(child: Text("No tienes TooBooks privados"))
                  );
                }else if (snapshot.hasError){
                  return new Text('Error: ${snapshot.error}');
                }else{
                  return CircularProgressIndicator();
                }
                }
              ),
          ],
        ));
  }
  _getPublicos(uid)async {
    return db.getPublicTooBooksFromIdUser(uid);
  }
  _getPrivados(uid)async {
    return db.getPrivateTooBooksFromIdUser(uid);
  }
  _getNumPublicaciones(uid) async {
    setState(() {
      cargadoNumPublicaciones = false;
    });
    int numero = await db.getNumPublicaciones(uid);
    setState(() {
      cargadoNumPublicaciones = true;
      numPublicaciones = numero;
    });
  }

  _getdatosUsuario(uid) async {
    setState(() {
      cargadoUsuario = false;
    });
    Usuario user = await db.fetchdatosUsuario(uid);
    setState(() {
      cargadoUsuario = true;
      usuario = user;
    });
  }
}
