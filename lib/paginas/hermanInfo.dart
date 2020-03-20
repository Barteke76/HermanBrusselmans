import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HermanInfo extends StatefulWidget {
  @override
  _HermanInfoState createState() => _HermanInfoState();
}

class _HermanInfoState extends State<HermanInfo> {
  int teller = 0;

  void optellen() {
    teller++;
    if (teller == 4) {
      teller = 0;
    }
  }

  void aftrekken() {
    teller--;
    if (teller == -1) {
      teller = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool terug = false;
    bool vooruit = false;
    return SafeArea(
      child: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 4) {
            terug = true;
          } else if (details.delta.dx < -4) {
            vooruit = true;
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (terug == true) {
            terug = false;
            setState(() {
              aftrekken();
            });
          }
          if (vooruit == true) {
            vooruit = false;
            setState(() {
              optellen();
            });
          }
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/portrait/herman_brusselmans$teller.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Bibliografie:",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ListView(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        Text(
                          "Herman Frans Martha Brusselmans wordt geboren op 9 oktober 1957 te Hamme, België. Hij groeit op tot een vrij succesvol voetballer bij de plaatselijke trots Vigor Hamme. Een voetbalcarriëre lonkt, topclub SK Lokeren lijft hem in, maar links-buiten Brusselmans ziet geen heil in een profvoetballerbestaan. Hij relativeert te veel, denkt te veel na en beseft dat dat geen goede eigenschap voor een voetballer is. "
                          ""
                          "Hij besluit Germaanse filologie (met Engels als hoofdvak en Nederlandse literatuur als bijvak) te studeren aan de Rijksuniversiteit van Gent. Herman loopt de kantjes eraf, zit vaker in het café dan in de collegebanken en neemt al snel een baantje aan in een bibliotheek, om precies te zijn de ontspanningsbibliotheek van de Rijksdienst voor Arbeidsvoorziening te Brussel. Na zijn huwelijk in 1981 vestigde hij zich in Iddergem, later (in 1986) betrok hij een flat in een van de /'hipste/' buurten van Gent. Tegenwoordig woont hij aan de overkant van de straat samen met zijn hondje Eddie."
                          "Tussen de boeken zittend, raakt hij zelf ook aan het schrijven. Als onderwerp kiest hij zichzelf, maar hij weet het autobiografische gelukkig wel te larderen met de nodige humor. Hoofdthema is /'een existentiële, verlammende huiver voor eenzaamheid, geweld en dood/' (Ed van Eeden in Kritisch Literatuur Lexicon). In een interview met Corine Koole in Het Parool merkte Brusselmans op: 'Ik beschouw mezelf als een professioneel uitdrager van een negatieve levenshouding.' In zijn romans, interviews en recensies neemt hij een provocerende zelfbewuste houding aan en geeft hij onomwonden zijn mening. Vooral voor J.D. Salinger en Gerard Reve heeft hij grote bewondering. Het relativeren, wat bij voetbal uit den boze was, bleek hier goed van pas te komen.  "
                          "Zijn debuut verschijnt in 1982: een verhalenbundel met de fraaie titel: 'Het zinneloze zeilen'. Herman krijgt de smaak te pakken en blijft schrijven en schrijven. Het ene boek volgt het andere op, een roman volgt op een novelle, en tussendoor schrijft hij ook nog korte verhalen, toneelstukken en essays. Zijn tweede boek, 'Prachtige ogen', krijgt in 1984 de Yang-prijs toegekend. Samen met Tom Lanoye schreef hij het toneelstuk De Canadese muur. "
                          "Alle romans en verhalen kennen een hoge autobiografische graad. 'De man die werk vond' bijvoorbeeld handelt over zijn baantje als bibliothecaris. Verder spelen in tal van zijn boeken zijn eerste drie vrouwen (Phoebe, Gloria en Tania) een belangrijke rol. Ook schrijft hij tal van columns (o.a. voor 'Humo', 'Playboy' en 'Esquire') en recensies (prachtig gebundeld in het hilarische 'De geschiedenis van de Vlaamse letterkunde').",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ) /* add child content here */,
            ],
          ),
        ),
      ),
    );
  }
}
