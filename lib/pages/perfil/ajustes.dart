import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game/providers/theme.dart';
import 'package:provider/provider.dart';

class Ajustes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ajustes"),
      ),
      body: Column(
        children: <Widget>[
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Switch(
              activeColor: Colors.grey,
              onChanged: (val) {
                notifier.toggleTheme();
              },
              value: notifier.darkTheme,
            ),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false))
                  .catchError((err) => print(err));
            },
          )
        ],
      ),
    );
  }
}
