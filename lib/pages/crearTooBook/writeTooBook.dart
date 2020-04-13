import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:game/pages/crearTooBook/continueTB.dart';
import 'package:game/pages/crearTooBook/writeChatsTB.dart';
import 'package:game/repositorio.dart' as db;

class WriteTB extends StatefulWidget {
  WriteTB({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _WriteTBState createState() => _WriteTBState();
}

class _WriteTBState extends State<WriteTB> {
  final controladorTitulo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String texto = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Escribe un TooBook"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Empieza por darle un nombre",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 20),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: controladorTitulo,
                  decoration: InputDecoration(
                    hintText: "Titulo del TooBook",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Introduce un titulo antes de continuar';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      texto = val;
                    });
                  },
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  controladorTitulo.clear();
                  db.addTooBook(widget.uid, texto).then((toobook) => {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => WriteChatsTB(
                                      tooBook: toobook,
                                    )))
                      });
                }
              },
              child: Text("Siguiente"),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => ContinuarTB(userId: widget.uid,)));
                },
                child: Text("Continua por donde lo dejaste"))
          ],
        ));
  }

  @override
  void dispose() {
    controladorTitulo.dispose();
    super.dispose();
  }
}
