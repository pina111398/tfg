import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/models/tooBook.dart';
import 'package:game/pages/crearTooBook/writeChatsTB.dart';

class ContinuarTB extends StatefulWidget {
  final String userId;

  ContinuarTB({this.userId});
  @override
  _ContinuarTBState createState() => _ContinuarTBState();
}

class _ContinuarTBState extends State<ContinuarTB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Mis TooBooks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("toobooks/")
            .where("idAutor", isEqualTo: widget.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              return snapshot.data.documents.length != 0
                  ? ListView.builder(
                      itemBuilder: (BuildContext ctx, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => WriteChatsTB(
                                      tooBook: TooBook.fromSnapshot(snapshot.data.documents[index]),
                                        )));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.documents[index]['titulo'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    snapshot.data.documents[index]['publico'] ?
                                      Icon(Icons.check_circle, color:  Colors.green)
                                    : Icon(Icons.do_not_disturb_on, color:  Colors.red)
                                  ],
                                ),
                              ),
                              Divider(
                                height: 5,
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                    )
                  : Center(child: Text("No has escrito nada anteriormente"));
          }
        },
      ),
    );
  }
}
