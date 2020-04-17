import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/blocs/bloc_misToobooks/misTB_bloc.dart';
import 'package:game/blocs/bloc_misToobooks/misTB_event.dart';
import 'package:game/blocs/bloc_misToobooks/misTB_state.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/widgets/widgetTooBook.dart';
import 'package:shimmer/shimmer.dart';
import 'package:game/widgets/resumentb.dart';
import 'package:game/repositorio.dart' as db;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid}) : super(key: key);

  final String uid;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MisTBBloc _misTBBloc;
  @override
  void initState() {
    _misTBBloc = MisTBBloc(userId: widget.uid);
    // TODO: implement initState
    _misTBBloc.dispatch(Fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("G.A.M.E"),
      ),
      body: SafeArea(
          child: BlocBuilder(
              bloc: _misTBBloc,
              builder: (BuildContext context, MisTBState state) {
                if (state is MisTBSinInicializar) {
                  return ListView.builder(
                      itemCount: 5,
                      // Important code
                      itemBuilder: (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.white,
                          child: _drawShimmer()));
                }
                if (state is MisTBError) {
                  return Center(
                    child: Text('failed to fetch mensajes'),
                  );
                }
                if (state is MisTBCargado) {
                  return RefreshIndicator(
                    color: Colors.blue,
                    child: _montaItem1(state),
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1, milliseconds: 50));
                      _misTBBloc.dispatch(Refresh());
                    },
                  );
                }
              })),
    );
  }

  _montaItem1(state) {
    return
    ListView.builder(
      itemCount: state.misTB.length,
      itemBuilder: (ctxt, index) {
        return Dismissible(
      key: Key(state.misTB[index].idToobook),
      background: Container(
        width: 0,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[Icon(Icons.delete)],
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async{
        await db.quitarLeyendo(widget.uid, state.misTB[index].idToobook);
        setState(() {
          state.misTB..removeAt(index);
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Borrado")));
      },
      child: 
          /*ResuTB(
            toobook: toobook, 
            uid: widget.uid,
          ),*/
          WidgetTB(
            toobook: state.misTB[index], 
            uid: widget.uid,
          )
    );
      },
    );
  }

  _drawShimmer() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 100,
            height: 10.0,
            margin: EdgeInsets.only(right: 15.0),
            color: Colors.blue,
          ),
          SizedBox(
            height: 5,
          ),
          for (int i = 0; i < 6; i++)
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 8.0,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 30,
                height: 10.0,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
