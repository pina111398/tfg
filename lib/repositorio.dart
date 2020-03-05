import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/models/tooBook.dart';
import 'package:intl/intl.dart';

final databaseReference = Firestore.instance;

Future<List<TooBook>> fetchMisTooBooks(String idUser) async {
  List<String> listaIds = [];
  await databaseReference
      .collection("users/$idUser/leyendo")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => listaIds.add(f.documentID));
  });
  List<TooBook> lista = [];
  for (int i = 0; i < listaIds.length; ++i) {
    DocumentSnapshot doc = await databaseReference
        .collection("toobooks")
        .document(listaIds[i])
        .get();
    lista.add(TooBook.fromSnapshot(doc));
  }
  return lista;
}

Future<List<Conversacion>> fetchChats(String tooBookId) async {
  List<Conversacion> lista = [];
  await databaseReference
      .collection("toobooks/$tooBookId/chats/")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => lista.add(Conversacion.fromSnapshot(f)));
  });
  return lista;
}

Future<List<Mensaje>> fetchMensajes(
    tooBookId, chatId, startIndex, limit) async {
  print(startIndex);
  print(limit);
  List<Mensaje> lista = [];
  await databaseReference
      .collection("toobooks/$tooBookId/chats/$chatId/mensajes/")
      .orderBy("fecha")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => lista.add(Mensaje.fromSnapshot(f)));
  });
  return lista;
}

Future<String> addTooBook(userId, titulo) async {
  final doc = await databaseReference.collection("toobooks").add({
    "autor": "prueba",
    "idAutor": userId,
    "sinopsis": "Sinopsis de prueba",
    "fecha": "12/12/2020",
    "titulo": titulo
  });
  return doc.documentID;
}

Future<String> addChatToTooBook(esGrupo, para, tooBookId) async {
  final doc =
      await databaseReference.collection("toobooks/$tooBookId/chats").add({
    "esGrupo": esGrupo,
    "para": para,
  });
  return doc.documentID;
}

Future<String> addPersonajeToGroupChat(nombre, idTooBook, idChat) async {
  final doc = await databaseReference
      .collection("toobooks/$idTooBook/chats/$idChat/personajes")
      .add({
    "nombre": nombre,
  });
  return doc.documentID;
}

Future<List<String>> fetchPersonajes(idToobook, idChat) async {
  List<String> listaPersonajes = [];
  await databaseReference
      .collection("toobooks/$idToobook/chats/$idChat/personajes")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => listaPersonajes.add(f['nombre']));
  });
  return listaPersonajes;
}

Future<List<TooBook>> fetchRecientes() async {
  List<TooBook> lista = [];
  await databaseReference
      .collection("toobooks/")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => lista.add(TooBook.fromSnapshot(f)));
  });
  return lista;
}

Future<List<TooBook>> fetchTop() async {
  List<TooBook> lista = [];
  await databaseReference
      .collection("toobooks/")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => lista.add(TooBook.fromSnapshot(f)));
  });
  return lista;
}

Future<List<TooBook>> fetchAutores() async {
  List<TooBook> lista = [];
  for (int i = 0; i < 5; i++) {
    lista.add(TooBook(
        idToobook: "idTooBook",
        autor: "kike",
        fecha: "15/10/2019 ",
        sinopsis: "sinopsis",
        titulo: "titulo del toobook $i"));
  }
  return lista;
}

String _generaSinopsis() {
  return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
}

enviaMensaje(idTooBook, idChat, mensaje, nombre) async {
  await databaseReference
      .collection("toobooks/$idTooBook/chats/$idChat/mensajes")
      .add({
    "nombre": nombre,
    "texto": mensaje,
    "tipo": "texto",
    "yo": nombre == "Yo",
    "fecha": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
  });
}

Future<bool> usuarioLeyendoTooBook(uid, idTooBook) async {
  final snapShot = await databaseReference
      .collection('users/$uid/leyendo')
      .document(idTooBook)
      .get();
  if (snapShot == null || !snapShot.exists)
    return false;
  else
    return true;
}

quitarLeyendo(uid,idTooBook)async{
  await databaseReference.collection("users/$uid/leyendo")
  .document(idTooBook)
  .delete();
}
anadirLeyendo(uid,idTooBook)async{
  await databaseReference.collection("users/$uid/leyendo")
  .document(idTooBook)
  .setData({});
}
eliminaMensaje(docID, idTooBook, idChat)async{
  await databaseReference.collection("toobooks/$idTooBook/chats/$idChat/mensajes")
  .document(docID)
  .delete();
}
updateMensaje(texto,idTooBook,idChat,mensajeID)async{
  await databaseReference.collection("toobooks/$idTooBook/chats/$idChat/mensajes")
  .document(mensajeID)
  .updateData({"texto":texto});
}