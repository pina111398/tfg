import 'dart:io' as io;
import 'dart:math';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:game/repositorio.dart' as db;

class GrabaAudio extends StatefulWidget {

  final String idTooBook;
  final String idChat;
  final String nombre;

  final LocalFileSystem localFileSystem;

  GrabaAudio({localFileSystem, this.idTooBook, this.idChat, this.nombre})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  
  @override
  _GrabaAudioState createState() => _GrabaAudioState();
}

class _GrabaAudioState extends State<GrabaAudio> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Grabar audio")),
          body: Center(
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
              children: <Widget>[
                new FlatButton(
                  onPressed: _isRecording ? null : _start,
                  child: new Text("Start"),
                  color: Colors.green,
                ),
                new FlatButton(
                  onPressed: _isRecording ? _stop : null,
                  child: new Text("Stop"),
                  color: Colors.red,
                ),
                new Text(
                    "Duracion audio : ${_recording.duration.toString()}")
              ]),
        ),
      ),
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        await AudioRecorder.start();
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    String url = await db.uploadAudioToStorage(file);
    db.subeAudio(widget.idTooBook, widget.idChat, widget.nombre, url).then((onValue){Navigator.pop(context);});
  }
}