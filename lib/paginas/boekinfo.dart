import 'package:flutter/material.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';

class BoekInfo extends StatefulWidget {
  // final Map lijst;
  final int index;

  final BoekenLijst boekenLijst;

  BoekInfo(this.boekenLijst, this.index);

  @override
  _BoekInfoState createState() => _BoekInfoState();
}

class _BoekInfoState extends State<BoekInfo> {
  String title;
  int teller;
  int volgorde;

  @override
  void initState() {
    super.initState();
    volgorde = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    bool terug = false;
    bool vooruit = false;

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
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
                volgorde = widget.boekenLijst.vorigeBoek(volgorde);
              });
            }
            if (vooruit == true) {
              vooruit = false;
              setState(() {
                volgorde = widget.boekenLijst.volgendeBoek(volgorde);
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Card(
                color: Colors.blueGrey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 15.0,
                margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(width: double.infinity),
                      Text(
                        "Publicatie jaar: ${widget.boekenLijst.getJaar(volgorde)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: widget.boekenLijst.getFoto(volgorde) != ""
                            ? Image.network(
                                widget.boekenLijst.getFoto(volgorde))
                            : Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      widget.boekenLijst.getTitel(volgorde),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  Center(
                                      child: Image.asset(
                                          "assets/NoPicAvailable.png")),
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ListView(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            Text(
                              widget.boekenLijst.getInhoud(volgorde),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.boekenLijst.changeBezit(volgorde);
                            });
                          },
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "In mijn collectie",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              CircleAvatar(
                                  backgroundColor:
                                      widget.boekenLijst.getBezit(volgorde) ==
                                              true
                                          ? Colors.green
                                          : Colors.grey[200],
                                  radius: 15.0,
                                  child: Icon(Icons.done, size: 10.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
