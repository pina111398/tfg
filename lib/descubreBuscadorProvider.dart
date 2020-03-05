import 'package:flutter/material.dart';

class DescubreBuscadorNotifier extends ChangeNotifier {

  final String key = "write";
  bool _estaEscribiendo;
  String _texto;

  bool get estaEscribiendo => _estaEscribiendo;
  String get texo => _texto;
  
  DescubreBuscadorNotifier() {
    _estaEscribiendo = false;
  }

  toggleWritting(bool estaEscribiendo) {
    _estaEscribiendo = estaEscribiendo;
    notifyListeners();
  }
  toggleTexto(String txt) {
    _texto = txt;
    notifyListeners();
  }
}