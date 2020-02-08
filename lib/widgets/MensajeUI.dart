import 'package:flutter/material.dart';
import 'package:game/models/mensaje.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MensajeUI extends StatelessWidget {

  final Mensaje mensaje;
  final bool esGrupo;

  MensajeUI({this.mensaje,this.esGrupo});

  Widget build(BuildContext context) {
    return mensaje.tipo != "referencia" ? 
      Container(
        margin: EdgeInsets.all(5),
        padding: mensaje.yo ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 4) : EdgeInsets.only(right: MediaQuery.of(context).size.width / 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment:
                  mensaje.yo ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment:
                  mensaje.yo ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: mensaje.yo
                        ? BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(15),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                          ),
                  ),
                  child: 
                    Column(
                      crossAxisAlignment:
                          mensaje.yo ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        esGrupo ? Text(mensaje.quien,style: TextStyle(fontWeight: FontWeight.bold),) : Container(width: 0,),
                        //SI EL MENSAJE ES DE TIPO TEXTO LO MAQUETO COMO TEXTO
                        mensaje.tipo == "texto" ?
                          Text(
                            mensaje.text,
                            textAlign: mensaje.yo ? TextAlign.end : TextAlign.start,
                          )
                        : mensaje.tipo == "foto" ?
                          _montaFoto(mensaje)
                        : Container()
                      ],
                    ),
                ),
              ],
            )
          ],
        ),
      )
      :
      _montaReferencia(mensaje);
  }
  _montaReferencia(Mensaje mensaje){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.notification_important,color: Colors.red,),
        Text("Te ha hablado ${mensaje.text}")
      ],
    );
  }
  _montaFoto(Mensaje mensaje){
    return
    Container(
      child: FlatButton(
        child: Material(
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(),
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Material(
              child: Image.asset(
                'images/img_not_available.jpeg',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: mensaje.text,
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {},
        padding: EdgeInsets.all(0),
      ),
    );
  }
}