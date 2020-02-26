import 'package:cloud_firestore/cloud_firestore.dart';

class Mensaje{
  final String nombre;
  final String tipo;
  final String text;
  final bool yo;

  Mensaje({this.nombre,this.tipo,this.text,this.yo});

  Mensaje.fromJson(Map<String, dynamic> m):
    nombre = m['nombre'],
    tipo = m['tipo'],
    text = m['texto'],
    yo = m['yo'];

  Mensaje.fromSnapshot(DocumentSnapshot snapshot):
    nombre = snapshot['nombre'],
    tipo = snapshot['tipo'],
    text = snapshot['texto'],
    yo = snapshot['yo'] == true;
}