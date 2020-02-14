import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/home/conversaciones.dart';

class ResuTB extends StatelessWidget {

  final TooBook toobook;
  String firstHalf;

  ResuTB({this.toobook}){
    if (toobook.sinopsis.length > 150) {
      firstHalf = toobook.sinopsis.substring(0, 150) + "...";
    } else {
      firstHalf = toobook.sinopsis;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Conversaciones(tooBook: toobook,)
      ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
        child: 
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(toobook.titulo,style: TextStyle(fontWeight: FontWeight.bold),),
                Text(toobook.fecha)  
              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Text(toobook.sinopsis),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(toobook.autor)
                  ],
                )
              ],
            )

          ),
        ),
    );
  }
}