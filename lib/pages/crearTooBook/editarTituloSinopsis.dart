import 'package:flutter/material.dart';
import 'package:game/providers/editTooBookProvider.dart';
import 'package:game/models/tooBook.dart';
import 'package:provider/provider.dart';
import 'package:game/repositorio.dart' as db;

class EditarTooBook extends StatefulWidget {
  final EditTooBookProvider provider;
  final TooBook tooBook;
  EditarTooBook({Key key, this.provider, this.tooBook}) : super(key: key);

  @override
  _EditarTooBookState createState() => _EditarTooBookState();
}

class _EditarTooBookState extends State<EditarTooBook> {

  TextEditingController tituloController = new TextEditingController();
  TextEditingController sinopsisController = new TextEditingController();
  bool publico;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tituloController.text = widget.provider.titulo;
    sinopsisController.text = widget.provider.sinopsis;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Editar tooBook")
      ),
      body: SafeArea(
              child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Público",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
                  Switch(
                    activeColor: Colors.grey,
                    onChanged: (val) {
                      widget.provider.togglePublico(val);
                    },
                    value: widget.provider.publico,
                  ),
                ],
              ),
              Text("Titulo",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
              SizedBox(height: 10,),
              TextFormField(
                  controller: tituloController,
                  onChanged: (val) {
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                  ),
                ),
              SizedBox(height: 10,),
              Text("Sinopsis",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
              SizedBox(height: 10,),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  controller: sinopsisController,
                  onChanged: (val) {
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.blue,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    db.actualizaInfoTooBook(tituloController.text,sinopsisController.text,widget.tooBook.idToobook,widget.provider.publico).then((_){
                      widget.provider.toggleTitulo(tituloController.text);
                      widget.provider.toggleSinopsis(sinopsisController.text);
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Guardar cambios",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}