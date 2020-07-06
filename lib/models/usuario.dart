import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{
  final String uid;
  String nombre;
  String apellido;
  String descripcion;
  final String email;
  String fotoPerfil;

  Usuario({this.uid,this.nombre,this.apellido,this.descripcion,this.email,this.fotoPerfil});

  Usuario.fromSnapshot(DocumentSnapshot snapshot):
        uid = snapshot.documentID,
        nombre = snapshot['nombre'],
        apellido = snapshot['apellido'],
        descripcion = snapshot['descripcion'],
        email = snapshot['email'],
        fotoPerfil = snapshot['fotoPerfil'];
}