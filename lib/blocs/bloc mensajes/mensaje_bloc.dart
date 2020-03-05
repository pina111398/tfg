import 'dart:async';
import 'dart:convert';

import 'package:game/repositorio.dart' as db;
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:game/models/mensaje.dart';
import 'package:rxdart/rxdart.dart';
import 'mensajes_event.dart';
import 'mensajes_state.dart';

class MensajeBloc extends Bloc<MensajeEvent,MensajeState>{

  final String toobookId;
  final String chatId;
  MensajeBloc({this.toobookId,this.chatId});

//Para no saturar la api de peticiones hasta que llega la primera
  @override
  Stream<MensajeState> transform(
    Stream<MensajeEvent> events,
    Stream<MensajeState> Function(MensajeEvent event) next,
  ) {
    return super.transform(
      (events as Observable<MensajeEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  MensajeState get initialState => MensajeSinInicializar();
  @override
  Stream<MensajeState> mapEventToState(MensajeEvent event) async* {
    print('evento: '+event.toString());
    if (event is Fetch && !_hasReachedMax(currentState)){
      try{
        if (currentState is MensajeSinInicializar){
          List<Mensaje> mensaje;
          mensaje = await db.fetchMensajes(toobookId,chatId,0,10);
          yield mensaje.length < 10 
            ? MensajeCargado(
              mensajes: mensaje,
              hasReachedMax: true,
            )
            :MensajeCargado(
              mensajes: mensaje,
              hasReachedMax: false,
            );
          return;
        }
        if(currentState is MensajeCargado){
          final mensaje = await db.fetchMensajes(toobookId,chatId,(currentState as MensajeCargado).mensajes.length,50);
          yield mensaje.isEmpty 
            ?(currentState as MensajeCargado).copyWith(hasReachedMax: true)
            : mensaje.length<50
              ? MensajeCargado(
                  mensajes: (currentState as MensajeCargado).mensajes + mensaje,
                  hasReachedMax: true,
              )            
              : MensajeCargado(
                mensajes: (currentState as MensajeCargado).mensajes + mensaje,
                hasReachedMax: false,
              );
        }
      }
      catch(_){
        yield MensajeError();
      }
    }
  }

  _hasReachedMax(MensajeState estado){
    return estado is MensajeCargado && estado.hasReachedMax;
  }

}
