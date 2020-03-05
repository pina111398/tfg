import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:game/theme.dart';

class Perfil extends StatefulWidget {
  Perfil({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
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
                padding: const EdgeInsets.only(left: 16.0, right: 8.0,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70.0,
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
                            "Luis Enrique Pina",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "enpihe1997@gmail.com",
                          ),
                          Container(
                              width: 200,
                              child: Text(
                                "Descripcion del usuario",
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(child: Text("4 publicaciones"), onPressed: () {}),
                OutlineButton(child: Text("7 leidos"), onPressed: () {})
              ],
            )
          ],
        ));
  }
}
