import 'package:equatable/equatable.dart';
import 'package:game/models/tooBook.dart';

abstract class MisTBState extends Equatable{
  MisTBState([List props = const []]):super(props);
}

class MisTBSinInicializar extends MisTBState{
  @override
  String toString() {
    // TODO: implement toString
    return 'TooBooksSinInicializar';
  }
}
class MisTBError extends MisTBState{
  @override
  String toString() {
    // TODO: implement toString
    return 'MisTBError';
  }
}
class MisTBCargado extends MisTBState{
  final List<TooBook> misTB;
  MisTBCargado({
    this.misTB,
  }):super([misTB]);

  MisTBCargado copyWith({
  final List<TooBook> misTB,
  }) {
    return MisTBCargado(misTB: misTB ?? this.misTB);
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'MisTB cargados: ${misTB.length}';
  }
}