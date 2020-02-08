import 'package:equatable/equatable.dart';

import 'package:game/models/mensaje.dart';

abstract class MensajeState extends Equatable{
  MensajeState([List props = const []]):super(props);
}

class MensajeSinInicializar extends MensajeState{
  @override
  String toString() {
    // TODO: implement toString
    return 'MensajeSinInicializar';
  }
}
class MensajeError extends MensajeState{
  @override
  String toString() {
    // TODO: implement toString
    return 'MensajeError';
  }
}

class MensajeCargado extends MensajeState{
  final List<Mensaje> mensajes;
  final bool hasReachedMax;
  MensajeCargado({
    this.mensajes,
    this.hasReachedMax,
  }):super([mensajes,hasReachedMax]);

  MensajeCargado copyWith({
    List<Mensaje> mensajes,
    bool hasReachedMax,
  }) {
    return MensajeCargado(mensajes: mensajes ?? this.mensajes,hasReachedMax: hasReachedMax ?? this.hasReachedMax,);
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'Post cargados: ${mensajes.length}';
  }
}