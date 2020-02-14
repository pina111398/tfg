import 'package:cloud_firestore/cloud_firestore.dart';

class Conversacion{
  final String idConversacion;
  final String para;
  final bool esGrupo;

  Conversacion({this.idConversacion,this.para,this.esGrupo});

  Conversacion.fromSnapshot(DocumentSnapshot snapshot):
      idConversacion = snapshot.documentID,
      para = snapshot['para'],
      esGrupo = snapshot['esGrupo'];
}