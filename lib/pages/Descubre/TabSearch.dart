import 'package:flutter/material.dart';
import 'package:game/widgets/widgetTooBook.dart';
import 'package:game/repositorio.dart' as db;
import '../../models/tooBook.dart';

class TabSearch extends StatefulWidget {
  final String uid;
  final String titulo;
  final String busqueda;
  const TabSearch({Key key, this.titulo, this.busqueda, this.uid})
      : super(key: key);
  @override
  _TabSearchState createState() => _TabSearchState();
}

class _TabSearchState extends State<TabSearch> {
  List<TooBook> toobooks = [];
  bool cargado;
  int numero = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargado = false;
    _getTooBooks();
  }

  _getTooBooks() async {
    widget.busqueda == "recientes" ?
    db.fetchRecientes().then((recientes) {
      setState(() {
        cargado = true;
        print("Cargado true");
        toobooks = recientes;
      });
    })
    : widget.busqueda == "semanal" ?
    db.fetchTop().then((recientes) {
      setState(() {
        cargado = true;
        print("Cargado true");
        toobooks = recientes;
      });
    }):
    db.fetchRecientes().then((recientes) {
      setState(() {
        cargado = true;
        print("Cargado true");
        toobooks = recientes;
      });
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*Text(
          widget.titulo,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),*/
        if (cargado) _montaItem1(toobooks) else CircularProgressIndicator()
      ],
    );
  }

  _montaItem1(misTB) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: misTB.length,
        itemBuilder: (ctxt, index) {
          return WidgetTB(
            toobook: misTB[index],
            uid: widget.uid,
          );
        });
  }
}
