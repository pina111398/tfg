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
}