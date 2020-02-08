class Conversacion{
  final String idTooBook;
  final String para;
  final bool esGrupo;

  Conversacion({this.idTooBook,this.para,this.esGrupo});

  Conversacion.fromJson(Map<String, dynamic> m):
    idTooBook = m['idTooBook'],
    para = m['para'],
    esGrupo = m['esGrupo'];
}