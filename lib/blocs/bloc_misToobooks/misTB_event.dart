import 'package:equatable/equatable.dart';

abstract class MisTBEvent extends Equatable{}

class Fetch extends MisTBEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Fetch';
  }
}

class Refresh extends MisTBEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Refresh';
  }
}