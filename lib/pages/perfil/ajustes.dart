import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game/inicioSesion/loginPage.dart';
import 'package:game/inicioSesion/registerPage.dart';
import 'package:game/models/usuario.dart';
import 'package:game/pages/perfil/editarPerfil.dart';
import 'package:game/providers/theme.dart';
import 'package:provider/provider.dart';

class Ajustes extends StatefulWidget {
  final Usuario usuario;

  const Ajustes({Key key, this.usuario}) : super(key: key);

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier provider = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ajustes"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  title: Text("Editar perfil"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EditarInformacionUsuario(usuario: widget.usuario,))).then((_){
                              setState(() {
                                
                              });
                            });
                  },
                ),
                ListTile(
                  title: Text("Modo oscuro"),
                  trailing: Switch(
                    activeColor: Colors.grey,
                    onChanged: (val) {
                      provider.toggleTheme();
                    },
                    value: provider.darkTheme,
                  ),
                )
              ],
            ),
            ListTile(
                title: Text(
                  "Cerrar sesión",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                trailing: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                onTap: () => FirebaseAuth.instance
                    .signOut()
                    .then((result) => Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                            builder: (context) => LoginPage()), (Route<dynamic> route) => false)
                        )
                    .catchError((err) => print(err)))
          ],
        ),
      ),
    );
  }
}
