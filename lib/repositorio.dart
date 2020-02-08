import 'package:game/models/mensaje.dart';
import 'package:game/models/tooBook.dart';

class Repositorio{

  static Future<List<Mensaje>> fetchMensajes(startIndex,limit) async{
    List<Mensaje> lista = [];
    for (int i =0; i < 48; i++){
      if(i % 2 == 0)
        lista.add(Mensaje(idConversacion: "idConver", quien: "kike", text: "Texto con startIndex: $startIndex y limite en $limit ",tipo: "texto",yo:true));
      else
        lista.add(Mensaje(idConversacion: "idConver", quien: "pedro", text: "Texto con startIndex: $startIndex y limite en $limit ",tipo: "texto",yo:false));

    }
    lista.add(Mensaje(idConversacion: "idConver", quien: "kike", text: "https://blog.hubspot.com/hubfs/image8-2.jpg",tipo: "foto",yo: true));
    lista.add(Mensaje(idConversacion: "idConver", quien: "pedro", text: "Pepe",tipo: "referencia",yo: false));
    return lista;
  }

  static Future<List<TooBook>> fetchRecientes() async{
    List<TooBook> lista = [];
    for (int i =0; i < 4; i++){
      lista.add(TooBook(idToobook: "idTooBook $i", autor: "kike", fecha: "15/10/2019 ", sinopsis: _generaSinopsis(),titulo:"titulo del toobook $i"));
    }
    await new Future.delayed(const Duration(seconds: 2));
    return lista;
  }
  static Future<List<TooBook>> fetchTop() async{
    List<TooBook> lista = [];
    for (int i =0; i < 5; i++){
      lista.add(TooBook(idToobook: "idTooBook", autor: "kike", fecha: "15/10/2019 ", sinopsis: "sinopsis",titulo:"titulo del toobook $i"));
    }
    return lista;
  }
  static Future<List<TooBook>> fetchAutores() async{
    List<TooBook> lista = [];
    for (int i =0; i < 5; i++){
      lista.add(TooBook(idToobook: "idTooBook", autor: "kike", fecha: "15/10/2019 ", sinopsis: "sinopsis",titulo:"titulo del toobook $i"));
    }
    return lista;
  }
}
String _generaSinopsis(){
  return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
}