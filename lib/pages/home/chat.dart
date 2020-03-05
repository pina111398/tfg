import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/widgets/MensajeUI.dart';
import 'package:game/blocs/bloc%20mensajes/mensaje_bloc.dart';
import 'package:game/blocs/bloc%20mensajes/mensajes_event.dart';
import 'package:game/blocs/bloc%20mensajes/mensajes_state.dart';
import 'package:game/models/conversacion.dart';
import 'package:game/models/mensaje.dart';

class Chat extends StatefulWidget {

  final Conversacion conversacion;
  final String toobookId;

  const Chat({this.conversacion,this.toobookId});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>{
  
  MensajeBloc _postBloc;
  final _scrollController = ScrollController();
  final _scrollUmbral = 200.0;
  
  List<Mensaje> mensajes;
  @override
  void initState() {
    _postBloc = MensajeBloc(toobookId: widget.toobookId, chatId: widget.conversacion.idConversacion);
    _postBloc.dispatch(Fetch());
    _scrollController.addListener(_onScroll);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context),
        ),
        title: Text(widget.conversacion.para),
      ),
      body:
        SafeArea(
          child: BlocBuilder(
            bloc: _postBloc,
            builder: (BuildContext context, MensajeState state){
              if(state is MensajeSinInicializar){
                return Center(child: CircularProgressIndicator(),);
              }
              if(state is MensajeError){
                return Center(
                child: Text('failed to fetch mensajes'),
              );
              }
              if (state is MensajeCargado) {
                if (state.mensajes.isEmpty) {
                  return Center(
                    child: Text('no hay mensajes'),
                  );
                }
                return 
                ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.mensajes.length
                          ? BottomLoader()
                          : MensajeUI(mensaje: state.mensajes[index],esGrupo: widget.conversacion.esGrupo,);
                    },
                    itemCount: state.hasReachedMax
                      ? state.mensajes.length
                      : state.mensajes.length + 1,
                    controller: _scrollController,              
                );
              }
            },
          ),
        )
    );
  }
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollUmbral) {
      //_postBloc.dispatch(Fetch());
    }
  }
}
class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
