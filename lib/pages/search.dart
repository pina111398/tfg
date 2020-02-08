import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/blocs/bloc_descrubre/descubre_bloc.dart';
import 'package:game/blocs/bloc_descrubre/descubre_event.dart';
import 'package:game/blocs/bloc_descrubre/descubre_state.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/widgets/resumenToobook.dart';

class Search extends StatefulWidget {
  
  Search({Key key,this.uid}) : super(key: key);

  final String uid;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final DescubreBloc _descubreBloc = DescubreBloc();
  final _formKey = GlobalKey<FormState>();
  String texto = "";

  @override
  void initState() {
    // TODO: implement initState
    _descubreBloc.dispatch(Fetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Descubre"),
      ),
        body: 
          BlocBuilder(
            bloc: _descubreBloc,
            builder: (BuildContext context, DescubreState state){
              if(state is DescubreSinInicializar){
                return Center(child: CircularProgressIndicator(),);
              }
              if(state is DescubreError){
                return Center(
                child: Text('failed to fetch posts'),
              );
              }
              if (state is DescubreCargado) {
                return _montaUI(state.top,state.recientes,state.autores);
              }
            },
          )
    );
  }

_montaUI(List<TooBook> top,List<TooBook> recientes,List<TooBook> autores){
  return
    Padding(
      padding: const EdgeInsets.fromLTRB(16,16,0,0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form( 
              key: _formKey,
              child:     
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Titulo, autor, categoria, palabra clave...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val){
                    setState(() {
                      texto = val;
                    });
                  },
                ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 50.0,
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: "hero1",
                    backgroundColor: Colors.grey[300], 
                    onPressed: (){},
                    label: Text("Terror",style: TextStyle(color: Colors.black),),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton.extended(
                    heroTag: "hero2",
                    backgroundColor: Colors.grey[300], 
                    onPressed: (){},
                    label: Text("Romanticismo",style: TextStyle(color: Colors.black),),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton.extended(
                    heroTag: "hero3",
                    backgroundColor: Colors.grey[300], 
                    onPressed: (){},
                    label: Text("Informatica",style: TextStyle(color: Colors.black),),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton.extended(
                    heroTag: "hero4",
                    backgroundColor: Colors.grey[300], 
                    onPressed: (){},
                    label: Text("MicroRelatos",style: TextStyle(color: Colors.black),),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
            Text("Autores populares",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 6),
            Container(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                for(int i =0;i<7;i++)
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35,
                          backgroundImage:
                          AssetImage("assets/messi.jpg"),
                            ),
                          Text("Nombre autor")
                      ],
                    ),
                      SizedBox(width: 10,)
                  ],
                ),
                ],
              ),
            ),
            Text("Mas recientes",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 6),
            Container(
              height: 140,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index){
                  return ResumenTBCard(toobook: recientes[index],);
                },
                itemCount: recientes.length,
              ),
            ),
            Text("Top Semanal",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 6),
            Container(
              height: 170,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index){
                  return ResumenTBCard(toobook: top[index],);
                },
                itemCount: recientes.length,
              ),
            ),
          ],
        ),
      )
    );
  }
}
