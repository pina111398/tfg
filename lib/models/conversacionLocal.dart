class ConversacionLocal{
  final String nombre;
  final bool esGrupo;

  ConversacionLocal({this.nombre,this.esGrupo});

  ConversacionLocal.fromJson(Map<String, dynamic> m):
    nombre = m['nombre'],
    esGrupo = m['esGrupo'];
}