import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game/models/usuario.dart';
import 'package:provider/provider.dart';
import 'package:game/repositorio.dart' as db;
import 'package:game/theme.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNumPublicaciones(widget.uid);
    _getdatosUsuario(widget.uid);
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
                    Navigator.pushNamed(context, '/ajustes');
                  }),
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
                child: 
                cargadoUsuario ? 
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage("https://via.placeholder.com/150"),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${usuario.email}",
                          ),
                          Container(
                              width: 200,
                              child: Text(
                                "${usuario.descripcion} wwwwwwwwwwwww",
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      ),
                    )
                  ],
                )
                :
                Center(child:CircularProgressIndicator())
              ),
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
            )
          ],
        ));
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

  _getdatosUsuario(uid)async{
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
