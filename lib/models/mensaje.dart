import 'package:cloud_firestore/cloud_firestore.dart';

class Mensaje{
  final String idConversacion;
  final String nombre;
  final String tipo;
  final String text;
  final bool yo;

  Mensaje({this.idConversacion,this.nombre,this.tipo,this.text,this.yo});

  Mensaje.fromJson(Map<String, dynamic> m):
    idConversacion = m['idConversacion'],
    nombre = m['nombre'],
    tipo = m['tipo'],
    text = m['texto'],
    yo = m['yo'];

  Mensaje.fromSnapshot(DocumentSnapshot snapshot):
    idConversacion = snapshot['idConversacion'],
    nombre = snapshot['nombre'],
    tipo = snapshot['tipo'],
    text = snapshot['texto'],
    yo = snapshot['yo'];
}