import 'package:equatable/equatable.dart';
import 'package:game/models/tooBook.dart';

abstract class DescubreState extends Equatable{
  DescubreState([List props = const []]):super(props);
}

class DescubreSinInicializar extends DescubreState{
  @override
  String toString() {
    // TODO: implement toString
    return 'MensajeSinInicializar';
  }
}
class DescubreError extends DescubreState{
  @override
  String toString() {
    // TODO: implement toString
    return 'MensajeError';
  }
}
class DescubreCargado extends DescubreState{
  final List<TooBook> recientes;
  final List<TooBook> top;
  final List<TooBook> autores;
  DescubreCargado({
    this.recientes,
    this.top,
    this.autores,
  }):super([recientes,top,autores]);

  DescubreCargado copyWith({
  final List<TooBook> recientes,
  final List<TooBook> top,
  final List<TooBook> autores,
  }) {
    return DescubreCargado(recientes: recientes ?? this.recientes,top: top ?? this.top,autores: autores ?? this.autores);
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Descubre cargados: ${recientes.length}';
  }
}