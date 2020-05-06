import 'dart:io';
import 'dart:ui';
import 'package:game/repositorio.dart' as db;
import 'package:game/utilidades.dart' as utilidades;
import 'package:flutter/material.dart';
import 'package:game/models/usuario.dart';
import 'package:image_picker/image_picker.dart';

class EditarInformacionUsuario extends StatefulWidget {
  final Usuario usuario;

  const EditarInformacionUsuario({Key key, this.usuario}) : super(key: key);
  @override
  _EditarInformacionUsuarioState createState() =>
      _EditarInformacionUsuarioState();
}

class _EditarInformacionUsuarioState extends State<EditarInformacionUsuario> {
  
  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidoController = new TextEditingController();
  
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombreController.text = widget.usuario.nombre;
    apellidoController.text = widget.usuario.apellido;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar perfil"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 32,left: 32,right: 32),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage("${widget.usuario.fotoPerfil}"),
                      backgroundColor: Colors.transparent,
                    ),
                    GestureDetector(
                      onTap: (){
                        pickImage(source: ImageSource.gallery).then((url){setState((){widget.usuario.fotoPerfil= url;});});
                        print("Editar imagen");
                      },
                      child: CircleAvatar(
                        radius: 15,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    )
                  ]),
                ],
              ),
              Column(
            children: <Widget>[
              SizedBox(height: 50,),
              TextFormField(
                  controller: nombreController,
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
            
              TextFormField(
                  controller: apellidoController,
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
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.blue,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    db.updatePerfil(widget.usuario.uid, nombreController.text, apellidoController.text).then((onValue){setState(() {
                      widget.usuario.nombre = nombreController.text;
                      widget.usuario.apellido = apellidoController.text;
                    });});
                  },
                  child: Text("Guardar cambios",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

            ],
          ),
        ));
  }
  Future<String> pickImage({@required ImageSource source}) async {
    File selectedImage = await utilidades.pickImage(source: source);
    return 
    selectedImage != null ?
    await db.updateImagenPerfil(
      image: selectedImage,
      uid: widget.usuario.uid
    ):null;
  }
}
