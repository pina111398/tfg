import 'package:flutter/material.dart';

class Dos extends StatefulWidget {
  @override
  _DosState createState() => _DosState();
}

class _DosState extends State<Dos> {
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Init Dos");
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Dos"),
    );
  }
}