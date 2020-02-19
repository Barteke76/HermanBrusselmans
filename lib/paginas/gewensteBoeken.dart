import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/boekinfo.dart';
import 'package:herman_brusselmans/services/globals.dart' as globals;

class GewensteBoeken extends StatefulWidget {
  final Map gewensteLijst;

  GewensteBoeken(this.gewensteLijst);

  @override
  _GewensteBoekenState createState() => _GewensteBoekenState();
}

class _GewensteBoekenState extends State<GewensteBoeken> {
  void verwijderBoek(titel) {
    setState(() {
      globals.mijnLijst[titel] = widget.gewensteLijst[titel];
      widget.gewensteLijst.remove(titel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var titels = widget.gewensteLijst.keys.toList();
    String hoofd = 'https://www.deslegte.be';
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
      scrollDirection: Axis.vertical,
      itemCount: widget.gewensteLijst.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
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
                            builder: (context) => BoekInfo(widget.gewensteLijst, titels[index]),
                          ),
                        );
                      },
                      child: Image.network(
                        (hoofd + widget.gewensteLijst[titels[index]]),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                      onTap: () {
                        verwijderBoek(titels[index]);
                      },
                      child: CircleAvatar(radius: 10.0, child: Text('+'))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
