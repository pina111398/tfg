import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class Perfil extends StatefulWidget {

  Perfil({Key key,this.uid}) : super(key: key);

  final String uid;
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Column(
        children: <Widget>[
          Consumer<ThemeNotifier>(
              builder: (context,notifier,child) => Switch(
                activeColor: Colors.grey,
                onChanged: (val){
                  notifier.toggleTheme();
                },
                value: notifier.darkTheme ,
              ),
            ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance
                    .signOut()
                    .then((result) =>
                        Navigator.pushReplacementNamed(context, "/login"))
                    .catchError((err) => print(err));
            },
          )
        ],
      ),
    );
  }
}