class Mensaje{
  final String idConversacion;
  final String quien;
  final String tipo;
  final String text;
  final bool yo;

  Mensaje({this.idConversacion,this.quien,this.tipo,this.text,this.yo});

  Mensaje.fromJson(Map<String, dynamic> m):
    idConversacion = m['idConversacion'],
    quien = m['quien'],
    tipo = m['tipo'],
    text = m['text'],
    yo = m['yo'];
}