import 'package:equatable/equatable.dart';

abstract class DescubreEvent extends Equatable{}

class Fetch extends DescubreEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Fetch';
  }
}