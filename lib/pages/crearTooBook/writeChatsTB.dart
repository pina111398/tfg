import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/editTooBookProvider.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/crearTooBook/WriteMessages.dart';
import 'package:game/pages/crearTooBook/editarTituloSinopsis.dart';
import 'package:game/repositorio.dart' as db;
import 'package:provider/provider.dart';

class WriteChatsTB extends StatefulWidget {
  final TooBook tooBook;
  WriteChatsTB({this.tooBook});
  @override
  _WriteChatsTBState createState() => _WriteChatsTBState();
}

class _WriteChatsTBState extends State<WriteChatsTB> {
  bool _esGrupo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _esGrupo = false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditTooBookProvider(widget.tooBook.titulo,widget.tooBook.sinopsis),
      child: Scaffold(
          appBar: AppBar(
            title: Consumer<EditTooBookProvider>(builder: (_, notifier, child) {
              return Text(notifier.titulo);
            }),
            actions: <Widget>[
              Consumer<EditTooBookProvider>(builder: (_, notifier, child) {
                return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => EditarTooBook(provider: notifier,tooBook: widget.tooBook,)))
                        });
              })
            ],
          ),
          body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("toobooks/${widget.tooBook.idToobook}/chats")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    if (snapshot.data.documents.length != 0) {
                      return ListView.builder(
                        itemBuilder: (BuildContext ctx, int index) {
                          Conversacion documento = Conversacion.fromSnapshot(
                              snapshot.data.documents[index]);
                          return Dismissible(
                            key: Key(snapshot.data.documents[index].documentID),
                            background: widgetDelete(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              await db.eliminaChat(
                                  snapshot.data.documents[index].documentID,
                                  widget.tooBook.idToobook);
                            },
                            child: InkWell(
                              onTap: () {
                                !documento.esGrupo
                                    ? Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                PantallaMensajes(
                                                    conversacion: documento,
                                                    idTooBook: widget.tooBook.idToobook,
                                                    idChat: documento
                                                        .idConversacion,
                                                    personajes: [
                                                      "Yo",
                                                      documento.para
                                                    ])))
                                    : db
                                        .fetchPersonajes(widget.tooBook.idToobook,
                                            documento.idConversacion)
                                        .then((listaPersonajes) {
                                        listaPersonajes.add("Yo");
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    PantallaMensajes(
                                                        conversacion: documento,
                                                        idTooBook:
                                                            widget.tooBook.idToobook,
                                                        idChat: documento
                                                            .idConversacion,
                                                        personajes:
                                                            listaPersonajes)));
                                      });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          documento.para,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    } else
                      return Center(
                          child: Text("No has escrito ningun chat todavia"));
                }
              },
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _ChatDialog(
                          grupo: _esGrupo, tooBookId: widget.tooBook.idToobook,);
                    });
              },
              icon: Icon(Icons.add),
              label: Text("Crear chat"),
            ),
          )),
    );
  }

  Widget widgetDelete() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Eliminar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}

class _ChatDialog extends StatefulWidget {
  final bool grupo;
  final String tooBookId;
  _ChatDialog({this.grupo, this.tooBookId});
  @override
  __ChatDialogState createState() => __ChatDialogState();
}

class __ChatDialogState extends State<_ChatDialog> {
  bool grupo;
  final _formKey = GlobalKey<FormState>();
  final controladorNombre = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    grupo = widget.grupo;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: controladorNombre,
                  validator: (value) {
                    if (value.length > 20) {
                      return 'El nombre no puede ser tan largo';
                    } else
                      return null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Nombre del chat'),
                ),
              ),
              Row(
                children: <Widget>[
                  Text("Es grupo"),
                  Checkbox(
                    activeColor: Colors.blue,
                    value: grupo,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        grupo = value;
                      });
                    },
                  ),
                ],
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      db
                          .addChatToTooBook(
                              grupo, controladorNombre.text, widget.tooBookId)
                          .then((documentId) => {Navigator.pop(context)});
                    }
                  },
                  child: Text(
                    "Siguiente",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
