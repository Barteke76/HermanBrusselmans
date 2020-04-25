import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';
import 'package:herman_brusselmans/services/database.dart';

class BoekInfo2 extends StatefulWidget {
  final int index;

  final BoekenLijst boekenLijst;

  BoekInfo2(this.boekenLijst, this.index);

  @override
  _BoekInfoState createState() => _BoekInfoState();
}

class _BoekInfoState extends State<BoekInfo2> {
  final DatabaseHelper boekDB = DatabaseHelper.instance;
  String title;
  int teller;
  int index;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> banners = List<Widget>();

    for (int i = 0; i < widget.boekenLijst.getBoekenLijstLengte(); i++) {
      var boekView = Container(
        child: Card(
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
                  "Publicatie jaar: ${widget.boekenLijst.getJaar(i)}",
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
                  child: widget.boekenLijst.getFoto(i) != ""
                      ? Image.network(
                          widget.boekenLijst.getFoto(i),
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        )
                      : Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                widget.boekenLijst.getTitel(i),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Center(
                                child:
                                    Image.asset("assets/NoPicAvailable.png")),
                          ],
                        ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      Text(
                        widget.boekenLijst.getInhoud(i),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  await boekDB.updateEboek(i + 1);
                                  setState(() {
                                    widget.boekenLijst.changeEBoek(i);
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      widget.boekenLijst.getEBoek(i) == true
                                          ? Colors.purple
                                          : Colors.grey[200],
                                  radius: 15.0,
                                  child: Icon(Icons.explicit, size: 18.0),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Op E-reader",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "In boekvorm",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              InkWell(
                                onTap: () async {
                                  await boekDB.updateBoek(i + 1);
                                  setState(() {
                                    widget.boekenLijst.changeBoek(i);
                                  });
                                },
                                child: CircleAvatar(
                                    backgroundColor:
                                        widget.boekenLijst.getBoek(i) == true
                                            ? Colors.green
                                            : Colors.grey[200],
                                    radius: 15.0,
                                    child: Icon(Icons.book, size: 18.0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      banners.add(boekView);
    }

    PageController controller = PageController(
        viewportFraction: 0.9, initialPage: (index + banners.length));

    return SafeArea(
      child: Scaffold(
        body: Column(
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: PageView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int teller) {
                    return banners[teller % banners.length];
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
