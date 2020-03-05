import 'package:flutter/material.dart';

class WrittingNotifierMessages extends ChangeNotifier {

  final String key = "write";
  bool _estaEscribiendo;
  String _nombre;
  List<String> _personajes;

  String get nombre => _nombre;
  bool get estaEscribiendo => _estaEscribiendo;
  List<String> get personajes => _personajes;
  
  WrittingNotifierMessages(List<String> personajes) {
    _estaEscribiendo = false;
    _nombre = "Yo";
    _personajes = personajes;
  }
  toggleName(String name) {
    _nombre = name;
    notifyListeners();
  }

  togglePersonaje(String name) {
    _personajes.add(name);
    notifyListeners();
  }

  toggleWritting(bool estaEscribiendo) {
    _estaEscribiendo = estaEscribiendo;
    notifyListeners();
  }
}