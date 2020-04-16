import 'package:flutter/material.dart';
import 'package:game/models/mensaje.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:game/pages/home/conversaciones.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:audioplayers/audioplayers.dart';
import 'player_widget.dart';
import 'package:game/repositorio.dart' as db;

class MensajeUI extends StatefulWidget {
  final Mensaje mensaje;
  final bool esGrupo;

  MensajeUI({this.mensaje, this.esGrupo});

  @override
  _MensajeUIState createState() => _MensajeUIState();
}

class _MensajeUIState extends State<MensajeUI> {
  Widget build(BuildContext context) {
    return widget.mensaje.tipo != "referencia"
        ? Container(
            margin: EdgeInsets.all(5),
            padding: widget.mensaje.yo
                ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 4)
                : EdgeInsets.only(right: MediaQuery.of(context).size.width / 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  mainAxisAlignment: widget.mensaje.yo
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: widget.mensaje.yo
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: widget.mensaje.yo
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
                        crossAxisAlignment: widget.mensaje.yo
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[
                          widget.esGrupo && !widget.mensaje.yo
                              ? Text(
                                  widget.mensaje.nombre,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Container(
                                  width: 0,
                                ),
                          //SI EL MENSAJE ES DE TIPO TEXTO LO MAQUETO COMO TEXTO
                          widget.mensaje.tipo == "texto"
                              ? Linkify(
                                  onOpen: (link) async {
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      throw 'Could not launch $link';
                                    }
                                  },
                                  text: widget.mensaje.text,
                                  textAlign: TextAlign.start,
                                  linkStyle: TextStyle(color: Colors.blue),
                                )
                              : widget.mensaje.tipo == "foto"
                                  //SI EL MENSAJE ES DE TIPO FOTO LO MAQUETO COMO FOTO
                                  ? _montaFoto(widget.mensaje)
                                  : widget.mensaje.tipo == "audio"
                                      ? _montaAudio(widget.mensaje)
                                      : _montaToobook(widget.mensaje)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : _montaReferencia(widget.mensaje);
  }

  _montaReferencia(Mensaje mensaje) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "${mensaje.text}",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  _montaToobook(Mensaje mensaje) {
    return GestureDetector(
        child: Text(
      "TooBook",
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    ),
    onTap: ()=> db.getTooBookFromId(mensaje.text).then((tooBook){
      Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Conversaciones(
                  tooBook: tooBook,
                  uid: null,
                )));
    })
    );
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

  _montaAudio(Mensaje mensaje) {
    return SingleChildScrollView(
      child: PlayerWidget(url: mensaje.text),
    );
  }
}
