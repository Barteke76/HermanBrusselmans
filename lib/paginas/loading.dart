import 'package:flutter/material.dart';
import 'package:herman_brusselmans/services/boek.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';
import 'package:herman_brusselmans/services/netwerk_processen.dart';
import 'dart:async';
import 'package:herman_brusselmans/services/database.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final DatabaseHelper boekDB = DatabaseHelper.instance;
  NetwerkProcessen netwerk = NetwerkProcessen();
  BoekenLijst boekenLijst = BoekenLijst();
  String status = "";
  String status2 = "";

  Future<void> boekenLaden() async {
    //opzoeken van de url's voor alle boeken.
    List<String> urlLijst = await netwerk.inlezenBoekenLijst();
    //biografie van herman Brusselmans scrappen
    await netwerk.bioHerman();
    //alle boek inhouden inlezen van de verschillende url's
    await netwerk.alleBoekenInhoud();
    //boekenlijst aanmaken
    for (var i = 0; i < urlLijst.length; i++) {
      Boek newBoek = Boek();
      newBoek.titel = netwerk.titelLijst[i];
      newBoek.url = urlLijst[i];
      newBoek.bezit = false;
      newBoek.eBoek = false;
      newBoek.boek = false;
      newBoek.foto = netwerk.fotoLijst[i];
      newBoek.jaar = netwerk.jaarLijst[i];
      newBoek.inhoud = netwerk.inhoudLijst[i];
      newBoek.biografie = netwerk.biografie;
      boekenLijst.boekToevoegen(newBoek);
    }
    //ontbrekende boeken invullen waardat scrappen een foutmelding geeft
    boekenLijst.ontbrekendeBoeken();
    //controleren of er nor ontbrekende boeken zijn en indien nog eens proberen
    //scrappen
    for (var i = 0; i < boekenLijst.getBoekenLijstLengte(); i++) {
      if (boekenLijst.getInhoud(i) == "") {
        await netwerk.boekInhoud(i, true);
        Boek newBoek = Boek();
        newBoek.titel = netwerk.titelLijst[i];
        newBoek.url = urlLijst[i];
        newBoek.bezit = false;
        newBoek.eBoek = false;
        newBoek.boek = false;
        newBoek.foto = netwerk.fotoLijst[i];
        newBoek.jaar = netwerk.jaarLijst[i];
        newBoek.inhoud = netwerk.inhoudLijst[i];
        newBoek.biografie = netwerk.biografie;
        boekenLijst.boekVervangen(newBoek, i);
      }
    }
  }

  Future<void> controleDatabase() async {
    List<Boek> dbLijst = await boekDB.queryAllBoeks();
    if (dbLijst.length < 15) {
      setState(() {
        status = "eerste gebruik, initialiseren database";
        status2 = "even geduld, aub";
      });
      await boekenLaden();
      //database vullen met alle boeken van herman brusselmans
      for (var i = 0; i < boekenLijst.getBoekenLijstLengte(); i++) {
        Boek newBoek = boekenLijst.ontvangBoek(i);
        await boekDB.insertBoek(newBoek);
      }
    } else {
      setState(() {
        status = "database wordt ingeladen";
      });
      boekenLijst.lijstToevoegen(dbLijst);
      await Future.delayed(Duration(seconds: 3));
    }
    Navigator.pushReplacementNamed(context, '/home', arguments: {
//      'boekLijst': boekenLijst,
    });
  }

  @override
  void initState() {
    super.initState();
    controleDatabase();
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
                      "Welkom",
                      style: TextStyle(
                        fontSize: 18.0,
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
                      status,
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
                      status2,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
