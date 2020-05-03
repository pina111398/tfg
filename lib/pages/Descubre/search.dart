import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/widgets/resumenToobook.dart';
import 'package:game/providers/descubreBuscadorProvider.dart';
import 'package:game/widgets/resumentb.dart';
import 'package:game/widgets/widgetTooBook.dart';
import 'package:provider/provider.dart';

import 'TabSearch.dart';

class Search extends StatefulWidget {
  Search({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    DescubreBuscadorNotifier notifier =
        Provider.of<DescubreBuscadorNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(notifier.appBarForm ? Icons.done : Icons.search),
            onPressed: () {
              if (notifier.estaEscribiendo) {
                notifier.toggleWritting(false);
                notifier.toggleTexto("");
                notifier.toggleAppBarForm(!notifier.appBarForm);
              } else
                notifier.toggleAppBarForm(!notifier.appBarForm);
            },
          ),
        ],
        title: notifier.appBarForm
            ? Form(
                key: _formKey,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: "Titulo, autor, categoria, palabra clave...",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        if (val.length > 0 && val.trim() != "") {
                          notifier.toggleWritting(true);
                          notifier.toggleTexto(val);
                        } else
                          notifier.toggleWritting(false);
                      },
                    ),
                  ),
                ),
              )
            : Text("Descubre"),
      ),
      body: !notifier.estaEscribiendo
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 50,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _selectedPage == 0
                              ? FlatButton(
                                  color: Colors.grey[400],
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 0;
                                    });
                                  },
                                  child: Text('Recientes'))
                              : OutlineButton(
                                  highlightColor: Colors.red,
                                  child: Text("Recientes"),
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 0;
                                    });
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _selectedPage == 1
                              ? FlatButton(
                                  color: Colors.grey[400],
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 1;
                                    });
                                  },
                                  child: Text('Top Semanal'))
                              : OutlineButton(
                                  child: Text("Top Semanal"),
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 1;
                                    });
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _selectedPage == 2
                              ? FlatButton(
                                  color: Colors.grey[400],
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 2;
                                    });
                                  },
                                  child: Text('Humor'))
                              : OutlineButton(
                                  child: Text("Humor"),
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 2;
                                    });
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _selectedPage == 3
                              ? FlatButton(
                                  color: Colors.grey[400],
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 3;
                                    });
                                  },
                                  child: Text('Terror'))
                              : OutlineButton(
                                  child: Text("Terror"),
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 3;
                                    });
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _selectedPage == 4
                              ? FlatButton(
                                  color: Colors.grey[400],
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 4;
                                    });
                                  },
                                  child: Text('Micro Relatos'))
                              : OutlineButton(
                                  child: Text("Micro Relatos"),
                                  onPressed: () {
                                    setState(() {
                                      _selectedPage = 4;
                                    });
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                IndexedStack(
                  index: _selectedPage,
                  children: <Widget>[
                    TabSearch(
                      titulo: "Recientes",
                      busqueda: "recientes",
                      uid: widget.uid,
                    ),
                    TabSearch(
                        titulo: "Top Semanal",
                        busqueda: "semanal",
                        uid: widget.uid),
                    TabSearch(
                        titulo: "Humor", busqueda: "semanal", uid: widget.uid),
                    TabSearch(
                      titulo: "Terror",
                      busqueda: "recientes",
                      uid: widget.uid,
                    ),
                    TabSearch(
                      titulo: "MicroRelatos",
                      busqueda: "recientes",
                      uid: widget.uid,
                    ),
                  ],
                ),
              ],
            )
          : StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("toobooks/")
                  .where("titulo", isGreaterThan: notifier.texo)
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
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Column(
                          children: <Widget>[
                            WidgetTB(
                              toobook: TooBook.fromSnapshot(
                                  snapshot.data.documents[index]),
                              uid: widget.uid,
                            ),
                            Divider()
                          ],
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                }
              },
            ),
    );
  }
}
