import 'package:flutter/material.dart';
import 'package:game/models/mensaje.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class MensajeUI extends StatelessWidget {
  final Mensaje mensaje;
  final bool esGrupo;

  MensajeUI({this.mensaje, this.esGrupo});

  Widget build(BuildContext context) {
    return mensaje.tipo != "referencia"
        ? Container(
            margin: EdgeInsets.all(5),
            padding: mensaje.yo
                ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 4)
                : EdgeInsets.only(right: MediaQuery.of(context).size.width / 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  mainAxisAlignment: mensaje.yo
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: mensaje.yo
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
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
                      child: Column(
                        crossAxisAlignment: mensaje.yo
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          esGrupo && !mensaje.yo
                              ? 
                              Text(
                                  mensaje.nombre,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Container(
                                  width: 0,
                                ),
                          //SI EL MENSAJE ES DE TIPO TEXTO LO MAQUETO COMO TEXTO
                          mensaje.tipo == "texto"
                              ? Text(
                                  mensaje.text,
                                  textAlign: mensaje.yo
                                      ? TextAlign.end
                                      : TextAlign.start,
                                )
                              : mensaje.tipo == "foto"
                                  ? _montaFoto(mensaje)
                                  : mensaje.tipo == "url"
                                    ? _montaUrl(mensaje.text)
                                    : Container()
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : _montaReferencia(mensaje);
  }

  _montaReferencia(Mensaje mensaje) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("${mensaje.text}",style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),)
      ],
    );
  }
  _montaUrl(String url){
    return RaisedButton(
      padding: EdgeInsets.all(0),
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: ()async{
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'No se pudo abrir $url';
      }
    }, child: Text(url,style: TextStyle(color:Colors.blue),));
  }
  _montaFoto(Mensaje mensaje) {
    return Container(
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
