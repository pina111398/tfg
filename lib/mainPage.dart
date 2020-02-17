import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game/pages/crearTooBook/writeTooBook.dart';
import 'package:game/pages/home/home.dart';
import 'package:game/pages/perfil.dart';
import 'package:game/pages/search.dart';
import 'package:game/theme.dart';
import 'package:provider/provider.dart';
class MainPage extends StatefulWidget {
  MainPage({Key key,this.uid}) : super(key: key);

  final String uid;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  int _currentIndex = 1;

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.search,),title: Text("")),
    BottomNavigationBarItem(icon: Icon(Icons.home,),title: Text("")),
    BottomNavigationBarItem(icon: Icon(Icons.add_box,),title: Text("")),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle,),title: Text("")),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              Search(uid: widget.uid),
              HomePage(uid: widget.uid),
              WriteTB(uid: widget.uid),
              Perfil()
            ],
          ),
        ),
      bottomNavigationBar: 
        new Theme(
        data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor,
            ),
        child: 
          BottomNavigationBar(
            iconSize: 25,
            showSelectedLabels: false,
            showUnselectedLabels: false, 
            unselectedItemColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            selectedItemColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            currentIndex: _currentIndex,
            onTap: (int i){
              setState(() {
              _currentIndex = i; 
              });
            },
            items: items,
          ),
        )
    );
  }
}
