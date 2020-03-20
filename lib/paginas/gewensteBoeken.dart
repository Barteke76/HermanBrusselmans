import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/boekinfo.dart';
import 'package:herman_brusselmans/paginas/boekinfo2.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';

class GewensteBoeken extends StatefulWidget {
  final BoekenLijst boekenLijst;

  GewensteBoeken(this.boekenLijst);

  @override
  _GewensteBoekenState createState() => _GewensteBoekenState();
}

class _GewensteBoekenState extends State<GewensteBoeken> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
      scrollDirection: Axis.vertical,
      itemCount: widget.boekenLijst.getBoekenLijstLengte(),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.blueGrey[900],
          margin: EdgeInsets.all(8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BoekInfo2(widget.boekenLijst, index),
                          ),
                        );
                      },
                      child: widget.boekenLijst.getFoto(index) == ""
                          ? Image.asset(
                              "assets/NoPicAvailable.png",
                            )
                          : Image.network(
                              widget.boekenLijst.getFoto(index),
                            ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.boekenLijst.changeBezit(index);
                      });
                    },
                    child: CircleAvatar(
                        backgroundColor:
                            widget.boekenLijst.getBezit(index) == true
                                ? Colors.green
                                : Colors.grey[200],
                        radius: 12.0,
                        child: Icon(Icons.done, size: 10.0)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
