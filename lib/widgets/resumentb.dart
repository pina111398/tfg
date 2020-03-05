import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/conversaciones.dart';

class ResuTB extends StatelessWidget {
  final TooBook toobook;
  final String uid;

  ResuTB({this.toobook,this.uid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    toobook.titulo,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(toobook.fecha)
                ],
              ),
            ),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.clip,
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: toobook.sinopsis),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[Text(toobook.autor)],
                ),
                Divider(height: 0,)
              ],
            ),
          ),
        ),
      
    );
  }
}
