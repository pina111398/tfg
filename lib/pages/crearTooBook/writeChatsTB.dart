import 'package:flutter/material.dart';
import 'package:game/models/conversacionLocal.dart';
import 'package:game/repositorio.dart' as db;

class WriteChatsTB extends StatefulWidget {

  final String nombreTB;
  final String tooBookId;
  WriteChatsTB({this.nombreTB,this.tooBookId});
  @override
  _WriteChatsTBState createState() => _WriteChatsTBState();
}

class _WriteChatsTBState extends State<WriteChatsTB> {

  List<ConversacionLocal> chats;
  bool _esGrupo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _esGrupo = false;
    chats = [];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreTB),
      ),
      body: 
          chats.length != 0 ?
            ListView.builder(
              itemBuilder: (BuildContext ctx, int index){
                return InkWell(
                  onTap: (){
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(chats[index].nombre,style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Divider(height: 5,)
                    ],
                  ),
                );
              },
              itemCount: chats.length,
            )
        :
          ListTile(
            title: Text("Crea un chat",style:TextStyle(fontSize: 20)),
            trailing: Icon(Icons.add),
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _ChatDialog(grupo: _esGrupo,tooBookId: widget.tooBookId);
                });
            },
          ),
      floatingActionButton: 
      chats.length !=0?
        FloatingActionButton.extended(
          onPressed: (){
            
          },
          icon: Icon(Icons.add),
          label: Text("Crear chat"),
        )
      :null
    );
  } 
}

class _ChatDialog extends StatefulWidget {

  final bool grupo;
  final String tooBookId;
  _ChatDialog({this.grupo,this.tooBookId});
  @override
  __ChatDialogState createState() => __ChatDialogState();
}

class __ChatDialogState extends State<_ChatDialog> {

  bool grupo;
  final _formKey = GlobalKey<FormState>();
  final controladorNombre = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    grupo = widget.grupo;
  }
  @override
  Widget build(BuildContext context) {
    return 
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), //this right here
        child: Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controladorNombre,
                    validator: (value) {
                      if (value.length > 20) {
                        return 'El nombre no puede ser tan largo';
                      } else 
                        return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Nombre del chat'),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("Es grupo"),
                    Checkbox(
                    activeColor: Colors.blue,
                    value: grupo,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        grupo = value;
                      });
                    },
                  ),
                  ],
                ),
                Center(
                  child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print(grupo.toString());
                          print(controladorNombre.text);
                          print(widget.tooBookId);
                          db.addChatToTooBook(grupo.toString(),controladorNombre.text,widget.tooBookId)
                          .then((documentId) => {
                            print(documentId)
                          });
                        }
                      },
                      child: Text(
                        "Siguiente",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                ),
              ],
            ),
          ),
        ),
      );
  }

}
