import 'package:flutter/material.dart';

class EditTooBookProvider extends ChangeNotifier {

  final String key = "edit";
  String _titulo;
  String _sinopsis;
  bool _publico = false;
  

  String get titulo => _titulo;
  bool get publico => _publico;
  String get sinopsis => _sinopsis;
  
  EditTooBookProvider(String titulo, sinopsis,publico) {
    _titulo = titulo;
    _sinopsis = sinopsis;
    _publico = publico;
  }
  toggleTitulo(String titulo) {
    _titulo = titulo;
    notifyListeners();
  }

  toggleSinopsis(String sinopsis) {
    _sinopsis = sinopsis;
    notifyListeners();
  }

  togglePublico(bool publico) {
    _publico = publico;
    notifyListeners();
  }
}