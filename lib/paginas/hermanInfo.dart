import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';

class HermanInfo extends StatefulWidget {
  final BoekenLijst boekenLijst;

  HermanInfo(this.boekenLijst);

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
                          widget.boekenLijst.getBio(),
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
