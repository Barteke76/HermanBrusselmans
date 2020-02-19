import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/homepage.dart';
import 'package:herman_brusselmans/paginas/loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: Loading(),
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => MyHomePage(),
      },
    );
  }
}
