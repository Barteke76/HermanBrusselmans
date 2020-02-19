import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/boekinfo.dart';
import 'package:herman_brusselmans/services/globals.dart' as globals;

class MijnBoeken extends StatefulWidget {
  final Map gewensteLijst;

  MijnBoeken(this.gewensteLijst);

  @override
  _MijnBoekenState createState() => _MijnBoekenState();
}

class _MijnBoekenState extends State<MijnBoeken> {
  List<Color> checkColor = [];

  void verwijderBoek(titel) {
    setState(() {
      widget.gewensteLijst[titel] = globals.mijnLijst[titel];
      globals.mijnLijst.remove(titel);
    });
  }

  void changeColor(index) {
    setState(() {
      if (checkColor[index] == Colors.grey[100]) {
        checkColor[index] = Colors.green;
      } else {
        checkColor[index] = Colors.grey[100];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> titels;
    if (globals.mijnLijst != null) {
      titels = globals.mijnLijst.keys.toList();
      for (var i = 0; i < globals.mijnLijst.length; i++) {
        checkColor.add(Colors.grey[100]);
      }
    }

    String hoofd = 'https://www.deslegte.be';
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
      scrollDirection: Axis.vertical,
      itemCount: globals.mijnLijst == null ? 0 : globals.mijnLijst.length,
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
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BoekInfo(globals.mijnLijst, titels[index]),
                          ),
                        );
                      },
                      child: Image.network(
                        (hoofd + globals.mijnLijst[titels[index]]),
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
                      child: CircleAvatar(radius: 10.0, child: Text('-'))),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      changeColor(index);
                    },
                    child: CircleAvatar(
                        backgroundColor: checkColor[index],
                        //backgroundColor: Colors.grey[100],
                        radius: 10.0,
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
