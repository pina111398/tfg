import 'package:cloud_firestore/cloud_firestore.dart';

class Conversacion{
  final String idConversacion;
  final String para;
  final bool esGrupo;
  final bool inicio;

  Conversacion({this.idConversacion,this.para,this.esGrupo,this.inicio});

  Conversacion.fromSnapshot(DocumentSnapshot snapshot):
      idConversacion = snapshot.documentID,
      para = snapshot['para'],
      esGrupo = snapshot['esGrupo'] == true,
      inicio = snapshot['inicio'];
}