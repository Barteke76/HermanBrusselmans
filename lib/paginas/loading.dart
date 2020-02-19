import 'package:flutter/material.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  //de verschillende url's die worden gebruikt
  var url1 =
      'https://www.deslegte.be/boeken/herman-brusselmans/paperback/verzending-vanuit-belgie/antwerpen-wapper/?q=&p=1&sc=popularity&so=desc&lv=list';
  var url2 =
      'https://www.deslegte.be/boeken/herman-brusselmans/paperback/verzending-vanuit-belgie/antwerpen-wapper/?p=2&lv=list&sc=popularity&so=desc';

  Future<void> gegevensLaden() async {
    List<String> titelLijst = [];
    List<String> imageLijst = [];
    var boek = Map<String, String>();
    var tijdelijk1 = Map<String, String>();
    var tijdelijk2 = Map<String, String>();
    List<String> titelPart1;

    //1ste pagina scrappen
    http.Response response = await http.get(url1);
    dom.Document document = parser.parse(response.body);
    var content = document.getElementsByClassName('searchresults list');
    var gegevens = (content[0].getElementsByTagName('img'));
    imageLijst = gegevens.map((cover) => cover.attributes['src']).toList();
    titelLijst = gegevens.map((cover) => cover.attributes['title']).toList();
    for (var i = 0; i < (titelLijst.length); i++) {
      titelPart1 = titelLijst[i].split(" -");
      tijdelijk1[titelPart1[0]] = imageLijst[i];
    }
    //2de pagine scrappen
    response = await http.get(url2);
    document = parser.parse(response.body);
    content = document.getElementsByClassName('searchresults list');
    gegevens = (content[0].getElementsByTagName('img'));
    imageLijst = gegevens.map((cover) => cover.attributes['src']).toList();
    titelLijst = gegevens.map((cover) => cover.attributes['title']).toList();
    for (var i = 0; i < (titelLijst.length); i++) {
      titelPart1 = titelLijst[i].split(" -");
      tijdelijk2[titelPart1[0]] = imageLijst[i];
    }
    boek = {...tijdelijk1, ...tijdelijk2} ;
    print(boek.length);

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'boek': boek,
    });
  }

  @override
  void initState() {
    super.initState();
    gegevensLaden();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Herman Brusselmans',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
