import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/conversaciones.dart';

class ResuTB extends StatelessWidget {
  final TooBook toobook;
  final String uid;

  ResuTB({this.toobook,this.uid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Conversaciones(
                  tooBook: toobook,
                  uid: uid,
                )));
      },
      child: ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 10.0,
            maxHeight: 150.0,
          ),
          child: Column(
            children: <Widget>[
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    toobook.titulo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(toobook.fecha.substring(0,10))
                ],
              ),
            ),

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      overflow: TextOverflow.fade,
                      strutStyle: StrutStyle(fontSize: 12.0),
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: toobook.sinopsis),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[Text(toobook.autor)],
                  ),
                ),
                Divider(height: 0,)]
          ),
        ),
      
    );
  }
}
