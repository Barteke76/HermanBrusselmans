import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/boekinfo2.dart';
import 'package:herman_brusselmans/services/boek.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';
import 'package:herman_brusselmans/services/database.dart';

class GewensteBoeken extends StatefulWidget {
  final int selectie;
  final String searchText;
  final bool search;

  GewensteBoeken(this.selectie, this.searchText, this.search);

  @override
  _GewensteBoekenState createState() => _GewensteBoekenState();
}

class _GewensteBoekenState extends State<GewensteBoeken> {
  BoekenLijst selectielijst = BoekenLijst();
  BoekenLijst nietCollectieLijst = BoekenLijst();
  BoekenLijst collectieLijst = BoekenLijst();
  BoekenLijst boekenLijst = BoekenLijst();
  BoekenLijst zoekLijst = BoekenLijst();

  final DatabaseHelper boekDB = DatabaseHelper.instance;

  Future<void> loadBoekenLijst() async {
    List<Boek> dbLijst = await boekDB.queryAllBoeks();
    boekenLijst.lijstToevoegen(dbLijst);
    setState(() {
      selectielijst = boekenLijst;
      zoekLijst = boekenLijst;
    });
  }

  void updateBoekenLijsten() {
    collectieLijst = BoekenLijst();
    nietCollectieLijst = BoekenLijst();
    zoekLijst = boekenLijst;
    for (var i = 0; i < boekenLijst.getBoekenLijstLengte(); i++) {
      if (boekenLijst.getBezit(i) == true) {
        collectieLijst.boekToevoegen(boekenLijst.ontvangBoek(i));
      } else {
        nietCollectieLijst.boekToevoegen(boekenLijst.ontvangBoek(i));
      }
    }
    //Update the zoeklijst
    if (widget.searchText.isNotEmpty) {
      BoekenLijst tempList = BoekenLijst();
      for (int i = 0; i < zoekLijst.getBoekenLijstLengte(); i++) {
        if (zoekLijst
            .getTitel(i)
            .toLowerCase()
            .contains(widget.searchText.toLowerCase())) {
          tempList.boekToevoegen(boekenLijst.ontvangBoek(i));
        }
      }
      zoekLijst = tempList;
      print(zoekLijst.getBoekenLijstLengte());
    }
  }

  void updateSelectie() {
    if (widget.search == true) {
      selectielijst = zoekLijst;
    } else {
      if (widget.selectie == 0) {
        selectielijst = boekenLijst;
      } else if (widget.selectie == 1) {
        selectielijst = nietCollectieLijst;
      } else if (widget.selectie == 2) {
        selectielijst = collectieLijst;
      }
    }
  }

  void initState() {
    super.initState();
    loadBoekenLijst();
    updateBoekenLijsten();
    setState(() {
      updateSelectie();
    });
  }

  @override
  Widget build(BuildContext context) {
    updateBoekenLijsten();
    updateSelectie();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
      scrollDirection: Axis.vertical,
      itemCount: selectielijst.getBoekenLijstLengte(),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BoekInfo2(selectielijst, index),
                          ),
                        );
                      },
                      child: selectielijst.getFoto(index) == ""
                          ? Image.asset(
                              "assets/NoPicAvailable.png",
                            )
                          : Image.network(
                              selectielijst.getFoto(index),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () async {
                      await boekDB.updateBoek(index + 1);
                      setState(() {
                        selectielijst.changeBoek(index);
                      });
                    },
                    child: CircleAvatar(
                        backgroundColor: selectielijst.getBoek(index) == true
                            ? Colors.green
                            : Colors.grey[200],
                        radius: 14.0,
                        child: Icon(Icons.book, size: 14.0)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () async {
                      await boekDB.updateEboek(index + 1);
                      setState(() {
                        selectielijst.changeEBoek(index);
                      });
                    },
                    child: CircleAvatar(
                        backgroundColor: selectielijst.getEBoek(index) == true
                            ? Colors.purple
                            : Colors.grey[200],
                        radius: 14.0,
                        child: Icon(Icons.explicit, size: 20.0)),
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
