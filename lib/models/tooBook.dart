import 'package:cloud_firestore/cloud_firestore.dart';

class TooBook{
  final String idToobook;
  final String titulo;
  final String fecha;
  final String sinopsis;
  final String autor;

  TooBook({this.idToobook,this.titulo,this.fecha,this.sinopsis,this.autor});

  TooBook.fromJson(Map<String, dynamic> m):
    idToobook = m['idToobook'],
    titulo = m['titulo'],
    fecha = m['fecha'],
    sinopsis = m['sinopsis'],
    autor = m['autor'];

  TooBook.fromSnapshot(DocumentSnapshot snapshot):
        idToobook = snapshot.documentID,
        titulo = snapshot['titulo'],
        fecha = snapshot['fecha'],
        sinopsis = snapshot['sinopsis'],
        autor = snapshot['autor'];
}