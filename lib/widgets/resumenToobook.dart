import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/conversaciones.dart';

class ResumenTBCard extends StatelessWidget {
  final TooBook toobook;
  final String uid;

  ResumenTBCard({this.toobook,this.uid});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 100,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Conversaciones(
                    tooBook: toobook,
                    uid: uid,
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          toobook.titulo,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(toobook.fecha.substring(0,10))
                      ],
                    ),
                    Container(
                      height: 3,
                    ),
                    Expanded(child: Text(toobook.sinopsis)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Text(toobook.autor)],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
