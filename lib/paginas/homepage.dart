
import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/gewensteBoeken.dart';
import 'package:herman_brusselmans/paginas/mijnBoeken.dart';
import 'package:herman_brusselmans/services/globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  //Map<String, String> mijnLijst = {};

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    Map boek = data['boek'];
    List<String> titels = [];
    List<String> covers = [];
    titels = boek.keys.toList();
    covers = boek.values.toList();
    Map<String, String> gewensteLijst = {};
    //Map<String, String> mijnLijst = {};
    List<String> titelsMijnLijst = [];

    if (globals.mijnLijst != null) {
      titelsMijnLijst = globals.mijnLijst.keys.toList();
    }

    for (var i = 0; i < titels.length; i++) {
      for (var j = 0; j < titelsMijnLijst.length; j++) {
        if (titels[i] == titelsMijnLijst[j]) {
          titels.remove(titels[i]);
          covers.remove(covers[i]);
        }
      }
    }

    gewensteLijst = Map.fromIterables(titels, covers);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
              child: Text(
                'Gewenste boeken',
                textScaleFactor: 1.3,
              ),
            ),
            Tab(
              child: Text(
                'Mijn boeken',
                textScaleFactor: 1.3,
              ),
            ),
          ]),
          actions: <Widget>[
            InkWell(onTap: () {}, child: Icon(Icons.search)),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Text(
                  'Herman Brusselmans',
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.info_outline,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GewensteBoeken(gewensteLijst),
            MijnBoeken(gewensteLijst),
          ],
        ),
      ),
    );
  }
}
