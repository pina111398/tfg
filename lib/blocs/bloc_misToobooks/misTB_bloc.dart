import 'dart:async';
import 'dart:convert';
import 'package:game/blocs/bloc_misToobooks/misTB_event.dart';
import 'package:game/blocs/bloc_misToobooks/misTB_state.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/repositorio.dart' as db;
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';


class MisTBBloc extends Bloc<MisTBEvent,MisTBState>{

  final String userId;
  MisTBBloc({this.userId});

//Para no saturar el server de peticiones hasta que llega la primera
  @override
  Stream<MisTBState> transform(
    Stream<MisTBEvent> events,
    Stream<MisTBState> Function(MisTBEvent event) next,
  ) {
    return super.transform(
      (events as Observable<MisTBEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  MisTBState get initialState => MisTBSinInicializar();
  @override
  Stream<MisTBState> mapEventToState(MisTBEvent event) async* {
    print('evento: '+event.toString());
    if (event is Fetch){
      try{
        if (currentState is MisTBSinInicializar){
          List<TooBook> misTB;
          misTB = await db.fetchMisTooBooks(userId);
          yield 
            MisTBCargado(misTB: misTB,);
        }
      }
      catch(_){
        yield MisTBError();
      }
    }
  }

}
