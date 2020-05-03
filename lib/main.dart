import 'package:flutter/material.dart';
import 'package:game/pages/home/infoTooBook.dart';
import 'package:game/pages/perfil/ajustes.dart';
import 'package:provider/provider.dart';
import 'providers/descubreBuscadorProvider.dart';
import 'mainPage.dart';
import 'inicioSesion/loginPage.dart';
import 'inicioSesion/registerPage.dart';
import 'splash_page.dart';
import 'providers/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => DescubreBuscadorNotifier()),
      ],
          child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: notifier.darkTheme ? dark : light,
                home: SplashPage(),
                routes: <String, WidgetBuilder>{
                  '/login': (BuildContext context) => LoginPage(),
                  '/register': (BuildContext context) => RegisterPage(),
                  '/ajustes': (BuildContext context) => Ajustes(),
                }
              );
            } ,
          ),);
  }
}