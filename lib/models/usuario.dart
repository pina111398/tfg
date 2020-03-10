import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{
  final String uid;
  final String nombre;
  final String apellido;
  final String descripcion;
  final String email;

  Usuario({this.uid,this.nombre,this.apellido,this.descripcion,this.email});

  Usuario.fromSnapshot(DocumentSnapshot snapshot):
        uid = snapshot.documentID,
        nombre = snapshot['nombre'],
        apellido = snapshot['apellido'],
        descripcion = snapshot['descripcion'],
        email = snapshot['email'];
}