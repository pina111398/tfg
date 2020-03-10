import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/blocs/bloc_descrubre/descubre_bloc.dart';
import 'package:game/blocs/bloc_descrubre/descubre_event.dart';
import 'package:game/blocs/bloc_descrubre/descubre_state.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/widgets/resumenToobook.dart';
import 'package:game/descubreBuscadorProvider.dart';
import 'package:game/widgets/resumentb.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  Search({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final DescubreBloc _descubreBloc = DescubreBloc();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _descubreBloc.dispatch(Fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Descubre"),
        ),
        body: ChangeNotifierProvider(
            create: (_) => DescubreBuscadorNotifier(),
            child: Consumer<DescubreBuscadorNotifier>(
                builder: (_, notifier, child) {
              return SingleChildScrollView(
                  child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText:
                                "Titulo, autor, categoria, palabra clave...",
                            prefixIcon: Icon(Icons.search),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            if (val.length > 0 && val.trim() != ""){
                                 notifier.toggleWritting(true);
                                 notifier.toggleTexto(val);
                            }
                                else notifier.toggleWritting(false);
                          },
                        ),
                      ),
                    ),
                    !notifier.estaEscribiendo
                        ? BlocBuilder(
                            bloc: _descubreBloc,
                            builder:
                                (BuildContext context, DescubreState state) {
                              if (state is DescubreSinInicializar) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is DescubreError) {
                                return Center(
                                  child: Text('failed to fetch posts'),
                                );
                              }
                              if (state is DescubreCargado) {
                                return _montaUI(
                                    state.top, state.recientes);
                              }
                            },
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection("toobooks/")
                                .where("titulo",isGreaterThan: notifier.texo)
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
                                          ResuTB(toobook: TooBook.fromSnapshot(snapshot.data.documents[index]),uid: widget.uid,),
                                          Divider()
                                        ],
                                      );
                                    },
                                    itemCount: snapshot.data.documents.length,
                                  );
                              }
                            },
                          ),
                  ],
                ),
              ));
            })));
  }

  _montaUI(List<TooBook> top, List<TooBook> recientes) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 50.0,
            child: ListView(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: "hero1",
                  backgroundColor: Colors.grey[300],
                  onPressed: () {},
                  label: Text(
                    "Terror",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton.extended(
                  heroTag: "hero2",
                  backgroundColor: Colors.grey[300],
                  onPressed: () {},
                  label: Text(
                    "Romanticismo",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton.extended(
                  heroTag: "hero3",
                  backgroundColor: Colors.grey[300],
                  onPressed: () {},
                  label: Text(
                    "Informatica",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton.extended(
                  heroTag: "hero4",
                  backgroundColor: Colors.grey[300],
                  onPressed: () {},
                  label: Text(
                    "MicroRelatos",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          Text(
            "Mas recientes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 6),
          Container(
            height: 140,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return ResumenTBCard(
                  toobook: recientes[index],
                  uid: widget.uid,
                );
              },
              itemCount: recientes.length,
            ),
          ),
          Text(
            "Top Semanal",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 6),
          Container(
            height: 140,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return ResumenTBCard(
                  toobook: top[index],
                  uid: widget.uid,
                );
              },
              itemCount: recientes.length,
            ),
          ),
        ],
      ),
    );
  }
}
