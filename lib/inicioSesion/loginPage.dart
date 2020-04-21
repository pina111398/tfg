import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../mainPage.dart';
import '../providers/theme.dart';

const color = const Color(0xff01A0C7);
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 4) {
      return 'Password must be longer than 4 characters';
    } else {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/flutterLogo.png'),
                      //El logo sera del tamaño de un tercio de la anchura de la pantalla
                      height: MediaQuery.of(context).size.width/3,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email*'),
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Contraseña*', hintText: "********"),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    SizedBox(height: 20,),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: color,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {validarLogin(_loginFormKey);},
                        child: Text("Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                      child: Text("Registrarse",),
                      onPressed: (){
                        Navigator.pushNamed(context, '/register');
                      },
                    )
            ],
          )
        )
      )
    );
  }
  validarLogin(_loginFormKey){
    if (_loginFormKey.currentState.validate()) {
      FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailInputController.text,
            password: pwdInputController.text)
        .then((currentUser) => 
        currentUser != null ?
        Firestore.instance
            .collection("users")
            .document(currentUser.user.uid)
            .get()
            .then((DocumentSnapshot result) =>
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                              uid: currentUser.user.uid,
                            ))))
            .catchError((err) => print(err)):print('object'))
        .catchError((err) => print(err));
    }
  }
}