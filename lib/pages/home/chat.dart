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

  const Chat({this.conversacion});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>{
  
  _ChatState(){
    _scrollController.addListener(_onScroll);
    //Inicializo la lista de mensajes nada mas crear el homepage
    _postBloc.dispatch(Fetch());
  }
  final MensajeBloc _postBloc = MensajeBloc();
  final _scrollController = ScrollController();
  final _scrollUmbral = 200.0;
  
  List<Mensaje> mensajes;
  @override
  void initState() {
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
        backgroundColor: Colors.white,
        title: Text(widget.conversacion.para),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.replay),onPressed: (){setState(() {
          });},)
        ],
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
      _postBloc.dispatch(Fetch());
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