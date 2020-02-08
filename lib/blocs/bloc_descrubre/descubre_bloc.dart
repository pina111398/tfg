import 'dart:async';
import 'dart:convert';

import 'package:game/blocs/bloc_descrubre/descubre_event.dart';
import 'package:game/blocs/bloc_descrubre/descubre_state.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/repositorio.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';


class DescubreBloc extends Bloc<DescubreEvent,DescubreState>{

//Para no saturar la api de peticiones hasta que llega la primera
  @override
  Stream<DescubreState> transform(
    Stream<DescubreEvent> events,
    Stream<DescubreState> Function(DescubreEvent event) next,
  ) {
    return super.transform(
      (events as Observable<DescubreEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  DescubreState get initialState => DescubreSinInicializar();
  @override
  Stream<DescubreState> mapEventToState(DescubreEvent event) async* {
    print('evento: '+event.toString());
    if (event is Fetch){
      try{
        if (currentState is DescubreSinInicializar){
          List<TooBook> recientes;
          List<TooBook> top;
          List<TooBook> autores;
          recientes = await Repositorio.fetchRecientes();
          top = await Repositorio.fetchTop();
          autores = await Repositorio.fetchAutores();
          yield 
            DescubreCargado(
              recientes: recientes,
              top: top,
              autores: autores,
            );
          return;
        }
      }
      catch(_){
        yield DescubreError();
      }
    }
  }

}
