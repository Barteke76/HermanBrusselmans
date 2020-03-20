import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/homepage.dart';
import 'package:herman_brusselmans/paginas/loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primaryColorDark: Colors.blueGrey[800],
        scaffoldBackgroundColor: Colors.blueGrey[800],
        
        // primarySwatch: Colors.blue,
      ),
      //home: Loading(),
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => MyHomePage(),
      },
    );
  }
}
