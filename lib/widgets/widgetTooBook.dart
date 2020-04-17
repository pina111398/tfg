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
                          NetworkImage("http://mbdentalhome.com/wp-content/uploads/2018/07/man.png"),
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