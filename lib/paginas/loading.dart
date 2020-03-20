import 'package:flutter/material.dart';
import 'package:herman_brusselmans/services/boek.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var tekst;
  var jaar;
  var inhoud;
  List<String> fotoLijst = [];
  List<String> jaarLijst = [];
  List<String> inhoudLijst = [];
  BoekenLijst boekenLijst = BoekenLijst();

  Future<void> gegevensLaden() async {
    //site aflopen voor de boekenlijst en de url's
    var response = await http.get(
        "https://hermanbrusselmans.nl/boeken/bloed-spuwen-naar-de-hematoloog");
    var document = parser.parse(response.body);
    var content = document.getElementById("right_content");
    var gegevens = content.getElementsByTagName("a");
    var urlLijst = gegevens.map((cover) => cover.attributes['href']).toList();
    var titelLijst =
        gegevens.map((cover) => cover.attributes['title']).toList();
    //alle boek inlezen van de verschillende url's
    for (var i = 0; i < urlLijst.length; i++) {
      try {
        response = await http.get(urlLijst[i]);
        document = parser.parse(response.body);
        content = document.getElementById("leftcolumn");
        var content2 = content.getElementsByClassName("text");

        //Zoeken naar boekcover
        gegevens = content2[1].getElementsByTagName("a");
        var foto = gegevens.map((cover) => cover.attributes['href']).toList();
        fotoLijst.add(foto[0]);

        //jaartal filteren van content2[1].outerHtml
        jaar = (content2[1].outerHtml).split("Publicatie jaar:</b><br>");
        jaar = jaar[1].split("<br>");
        jaarLijst.add(jaar[0]);

        // //inhoud filteren tekst[1]
        inhoud = (content2[1].outerHtml).split("<b>Beschrijving:</b><br>");
        inhoud = inhoud[1].split("<div");
        inhoud = inhoud[0].replaceAll("<br>", "\n");
        inhoudLijst.add(inhoud);
      } catch (e) {
        fotoLijst.add("");
        jaarLijst.add("");
        inhoudLijst.add("");
        print(urlLijst[i]);
      }
    }

    //biografie van herman brusselmans toevoegen, alleen in eerste record
    response = await http.get("https://hermanbrusselmans.nl/biografie");
    document = parser.parse(response.body);
    content = document.getElementById("leftcolumn");
    var content2 = content.getElementsByClassName("text no_border_mobile");
    var tekst = (content2[0].outerHtml).split("<br><i>");
    tekst = tekst[1].split("Meer biografische verhalen");
    var biografie = tekst[0].replaceAll("<br>", "\n");
    biografie = biografie.replaceAll("</i>", "");
    biografie = biografie.replaceAll("&nbsp;", "");
    biografie = biografie.replaceAll("<i>", " ");
    biografie = biografie.replaceAll("door <a href=", " ");
    biografie = biografie.replaceAll("><u>hier naartoe te gaan</u></a>", "");

    for (var i = 0; i < urlLijst.length; i++) {
      Boek newBoek = Boek();
      newBoek.titel = titelLijst[i];
      newBoek.url = urlLijst[i];
      newBoek.bezit = false;
      newBoek.foto = fotoLijst[i];
      newBoek.jaar = jaarLijst[i];
      newBoek.inhoud = inhoudLijst[i];
      newBoek.biografie = biografie;
      boekenLijst.boekToevoegen(newBoek);
    }

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'boekLijst': boekenLijst,
    });
  }

  @override
  void initState() {
    super.initState();
    gegevensLaden();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/loading/loading2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Herman Brusselmans",
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                CircularProgressIndicator(),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welkom, even geduld",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "alleen bij eerste gebruik duurt dit even.",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
