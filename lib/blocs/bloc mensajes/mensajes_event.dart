import 'package:equatable/equatable.dart';

abstract class MensajeEvent extends Equatable{}

class Fetch extends MensajeEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Fetch';
  }
}

class Refresh extends MensajeEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Refresh';
  }
}