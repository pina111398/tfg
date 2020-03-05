import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/WrittingMessagesProvider.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/widgets/MensajeUI.dart';
import 'package:provider/provider.dart';
import 'package:game/repositorio.dart' as db;

class PantallaMensajes extends StatefulWidget {
  final Conversacion conversacion;
  final String idTooBook;
  final String idChat;
  final List<String> personajes;

  PantallaMensajes(
      {this.conversacion, this.idTooBook, this.idChat, this.personajes});
  @override
  _PantallaMensajesState createState() => _PantallaMensajesState();
}

class _PantallaMensajesState extends State<PantallaMensajes> {
  ScrollController _listScrollController = ScrollController();
  TextEditingController textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => WrittingNotifierMessages(widget.personajes),
        child: Scaffold(
          appBar: new AppBar(
            title: Text(widget.conversacion.para),
            actions: <Widget>[
              widget.conversacion.esGrupo
                  ? Consumer<WrittingNotifierMessages>(
                      builder: (_, notifier, child) {
                      return IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _anadirPersonajeDialog(
                                    widget.idTooBook,
                                    widget.idChat,
                                  );
                                }).then((nombre) {
                              notifier.togglePersonaje(nombre);
                            });
                          });
                    })
                  : Container()
            ],
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection(
                            "toobooks/${widget.idTooBook}/chats/${widget.idChat}/mensajes")
                        .orderBy("fecha", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container();
                        default:
                          return ListView.builder(
                            controller: _listScrollController,
                            reverse: true,
                            itemBuilder: (BuildContext ctx, int index) {
                              return GestureDetector(
                                key: Key(
                                    snapshot.data.documents[index].documentID),
                                child: MensajeUI(
                                    esGrupo: widget.conversacion.esGrupo,
                                    mensaje: Mensaje.fromSnapshot(
                                        snapshot.data.documents[index])),
                                onLongPress: () {
                                  opcionesModal(
                                      context,
                                      snapshot.data.documents[index].documentID,
                                      widget.idTooBook,
                                      widget.idChat,
                                      Mensaje.fromSnapshot(
                                          snapshot.data.documents[index]));
                                },
                              );
                            },
                            itemCount: snapshot.data.documents.length,
                          );
                      }
                    },
                  ),
                ),
                ControlesChat(
                    idTooBook: widget.idTooBook, idChat: widget.idChat),
              ],
            ),
          ),
        ));
  }

  _anadirPersonajeDialog(idTooBook, idChat) {
    final _formKey = GlobalKey<FormState>();
    final controladorNombre = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 150,
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
                      border: InputBorder.none,
                      hintText: 'Nombre del contacto'),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      db
                          .addPersonajeToGroupChat(
                              controladorNombre.text, idTooBook, idChat)
                          .then((documentId) {
                        Navigator.pop(context, controladorNombre.text);
                      });
                    }
                  },
                  child: Text(
                    "Añadir",
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

  opcionesModal(context, documentID, idTooBook, idChat, Mensaje mensaje) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('Editar mensaje'),
                  leading: Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditaMensaje(
                              mensajeID: documentID,
                              mensaje: mensaje,
                              idTooBook: idTooBook,
                              idChat: idChat);
                        }).then((onValue) {
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: Text('Eliminar mensaje'),
                  leading: Icon(Icons.delete),
                  onTap: () async {
                    await db.eliminaMensaje(documentID, idTooBook, idChat);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}

class ControlesChat extends StatelessWidget {
  final TextEditingController textFieldController = new TextEditingController();
  final String idTooBook;
  final String idChat;
  ControlesChat({
    this.idTooBook,
    this.idChat,
  });

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Herramientas",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('Imagen'),
                      leading: Icon(Icons.image),
                    ),
                    ListTile(
                      title: Text('Video'),
                      leading: Icon(Icons.video_library),
                    ),
                    ListTile(
                      title: Text('Audio'),
                      leading: Icon(Icons.audiotrack),
                    ),
                    ListTile(
                      title: Text('Url'),
                      leading: Icon(Icons.link),
                    ),
                    ListTile(
                      title: Text('TooBook'),
                      leading: Icon(Icons.chat),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    WrittingNotifierMessages notifier =
        Provider.of<WrittingNotifierMessages>(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? notifier.toggleWritting(true)
                    : notifier.toggleWritting(false);
              },
              decoration: InputDecoration(
                hintText: "Escribe un mensaje",
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(50.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          notifier.estaEscribiendo
              ? Container()
              : PopupMenuButton(
                  child: FloatingActionButton.extended(
                    label: Text(notifier.nombre),
                    elevation: 0,
                    backgroundColor: Colors.grey[400],
                  ),
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                        for (String personaje in notifier.personajes)
                          new PopupMenuItem<String>(
                              child: Text(personaje), value: personaje),
                      ],
                  onSelected: (name) {
                    notifier.toggleName(name);
                  }),
          notifier.estaEscribiendo
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[400]),
                  child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 20,
                      ),
                      onPressed: () {
                        db.enviaMensaje(
                            idTooBook,
                            idChat,
                            textFieldController.text.toString(),
                            notifier.nombre);
                        textFieldController.clear();
                        notifier.toggleWritting(false);
                      }))
              : Container()
        ],
      ),
    );
  }
}

class EditaMensaje extends StatefulWidget {
  final Mensaje mensaje;
  final String mensajeID;
  final String idTooBook;
  final String idChat;
  EditaMensaje({this.mensaje, this.mensajeID, this.idTooBook, this.idChat});

  @override
  _EditaMensajeState createState() => _EditaMensajeState();
}

class _EditaMensajeState extends State<EditaMensaje> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController controladorMensaje;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controladorMensaje = TextEditingController(text: widget.mensaje.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: controladorMensaje,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    db
                        .updateMensaje(controladorMensaje.text,
                            widget.idTooBook, widget.idChat, widget.mensajeID)
                        .then((onValue) {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Guardar",
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
