import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/conversaciones.dart';

class WidgetTB extends StatelessWidget {
  final TooBook toobook;
  final String uid;

  const WidgetTB({Key key, this.toobook, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://images.assetsdelivery.com/compings_v2/gmast3r/gmast3r1511/gmast3r151100776.jpg"),
                      backgroundColor: Colors.transparent,
                    ),
      title: Text(toobook.titulo,style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text(toobook.autor),
      trailing: Text(toobook.fecha.substring(0,10)),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Conversaciones(
                  tooBook: toobook,
                  uid: uid,
                )))
    );
  }
}