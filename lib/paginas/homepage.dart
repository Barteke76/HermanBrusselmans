import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/gewensteBoeken.dart';
import 'package:herman_brusselmans/paginas/hermanInfo.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tonen = ["alles", "niet in mijn collectie", "mijn collectie"];
  int selectie = 0;
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    BoekenLijst boekenLijst = data['boekLijst'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HermanInfo(boekenLijst),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      'Bibliografie',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HermanInfo(boekenLijst)));
                      },
                      child: Icon(
                        Icons.info_outline,
                        size: 15.0,
                      ),
                    ),
                    SizedBox(
                      width: 60.0,
                    ),
                    Text(
                      "Toon: ",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(
                          () {
                            selectie++;
                            if (selectie > tonen.length - 1) {
                              selectie = 0;
                            }
                          },
                        );
                      },
                      child: Text(
                        tonen[selectie],
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TextField(
              //   onChanged: (text) {
              //     value = text;
              //   },
              // ),
              Icon(
                Icons.search,
                size: 15.0,
              ),
            ],
          ),
        ),
        body: GewensteBoeken(boekenLijst),
      ),
    );
  }
}
