import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mainPage.dart';
import 'inicioSesion/loginPage.dart';
import 'inicioSesion/registerPage.dart';
import 'splash_page.dart';
import 'theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
          child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: notifier.darkTheme ? dark : light,
                home: SplashPage(),
                routes: <String, WidgetBuilder>{
                  '/home': (BuildContext context) => MainPage(),
                  '/login': (BuildContext context) => LoginPage(),
                  '/register': (BuildContext context) => RegisterPage(),
                }
              );
            } ,
          ),);
    
  }
}