import 'package:flutter/material.dart';

class DescubreBuscadorNotifier extends ChangeNotifier {

  final String key = "write";
  bool _estaEscribiendo;
  bool _appBarForm;
  String _texto;

  bool get estaEscribiendo => _estaEscribiendo;
  bool get appBarForm => _appBarForm;
  String get texo => _texto;
  
  DescubreBuscadorNotifier() {
    _estaEscribiendo = false;
    _appBarForm = false;
  }

  toggleWritting(bool estaEscribiendo) {
    _estaEscribiendo = estaEscribiendo;
    notifyListeners();
  }
  toggleAppBarForm(bool form) {
    _appBarForm = form;
    notifyListeners();
  }
  toggleTexto(String txt) {
    _texto = txt;
    notifyListeners();
  }
}