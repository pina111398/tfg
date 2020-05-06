import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/descubreBuscadorProvider.dart';
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
                title: 'Aplicacion generadora de ediciones multimedia',
                theme: notifier.darkTheme ? dark : light,
                home: SplashPage(),
              );
            } ,
          ),);
  }
}