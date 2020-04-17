import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/models/usuario.dart';
import 'package:intl/intl.dart';

final databaseReference = Firestore.instance;
StorageReference _storageReference;

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

Future<TooBook> addTooBook(userId, titulo) async {
  String fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  Usuario usuario = await fetchdatosUsuario(userId);
  final doc = await databaseReference.collection("toobooks").add({
    "autor": usuario.nombre,
    "idAutor": userId,
    "sinopsis": "",
    "fecha": fecha,
    "titulo": titulo,
    "publico":false,
  });
  return TooBook(autor: "prueba",fecha: fecha, idToobook: doc.documentID,sinopsis: "",titulo: titulo);
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
      .orderBy("fecha", descending: true)
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

quitarLeyendo(uid, idTooBook) async {
  await databaseReference
      .collection("users/$uid/leyendo")
      .document(idTooBook)
      .delete();
}

anadirLeyendo(uid, idTooBook) async {
  await databaseReference
      .collection("users/$uid/leyendo")
      .document(idTooBook)
      .setData({});
}

eliminaMensaje(docID, idTooBook, idChat) async {
  await databaseReference
      .collection("toobooks/$idTooBook/chats/$idChat/mensajes")
      .document(docID)
      .delete();
}

updateMensaje(texto, idTooBook, idChat, mensajeID) async {
  await databaseReference
      .collection("toobooks/$idTooBook/chats/$idChat/mensajes")
      .document(mensajeID)
      .updateData({"texto": texto});
}

eliminaChat(documentID, tooBookId) async {
  await databaseReference
      .collection("toobooks/$tooBookId/chats")
      .document(documentID)
      .delete();
}

Future<int> getNumPublicaciones(uid) async {
  int total;
  await databaseReference
      .collection("toobooks/")
      .where("idAutor", isEqualTo: uid)
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    total = snapshot.documents.length;
  });
  return total;
}

Future<Usuario> fetchdatosUsuario(uid) async {
  Usuario user;
  await databaseReference
      .collection("users/")
      .where("uid", isEqualTo: uid)
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    user = Usuario.fromSnapshot(snapshot.documents[0]);
  });
  return user;
}

void uploadImage(
    {@required File image,
    @required String idTooBook,
    @required String idChat,
    @required String nombre}) async {

    String url = await uploadImageToStorage(image);
  
    subeImagen(idTooBook,idChat,nombre,url);
    }

  void subeImagen(idTooBook,idChat,nombre,url) async {
    await databaseReference
          .collection("toobooks/$idTooBook/chats/$idChat/mensajes")
          .add({
        "nombre": nombre,
        "texto": url,
        "tipo": "foto",
        "yo": nombre == "Yo",
        "fecha": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });
  }
  
  Future subeAudio(idTooBook,idChat,nombre,url) async {
    await databaseReference
          .collection("toobooks/$idTooBook/chats/$idChat/mensajes")
          .add({
        "nombre": nombre,
        "texto": url,
        "tipo": "audio",
        "yo": nombre == "Yo",
        "fecha": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });
  }
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
    Future<String> uploadAudioToStorage(File audioFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask =
          _storageReference.putFile(audioFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
  
  Future actualizaInfoTooBook(titulo,sinopsis,tooBookId)async{
    await databaseReference
      .collection("toobooks")
      .document(tooBookId)
      .updateData({"titulo": titulo,"sinopsis": sinopsis});
  }

  Future<TooBook> getTooBookFromId(String toobookid)async{
    DocumentSnapshot doc = await databaseReference
        .collection("toobooks")
        .document(toobookid)
        .get();
    return TooBook.fromSnapshot(doc);
  }