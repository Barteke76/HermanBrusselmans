import 'package:flutter/material.dart';
import 'package:herman_brusselmans/paginas/gewensteBoeken.dart';
import 'package:herman_brusselmans/paginas/hermanInfo.dart';
import 'package:herman_brusselmans/services/boek.dart';
import 'package:herman_brusselmans/services/boekenLijst.dart';
import 'package:herman_brusselmans/services/database.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper boekDB = DatabaseHelper.instance;
  List<String> tonen = ["alle boeken", "niet in mijn bezit", "in mijn bezit"];
  final TextEditingController _filter = TextEditingController();
  int selectie = 0;
  Icon _searchIcon = Icon(Icons.search);
  bool search = false;
  String searchText = "";
  BoekenLijst boekenLijst = BoekenLijst();
  BoekenLijst selectielijst = BoekenLijst();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _filter.dispose();
    super.dispose();
  }

  _updateFilterString() {
    if (_filter.text.isEmpty) {
      setState(() {
        searchText = "";
//        filterLijst = boekenLijst;
      });
    } else {
      setState(() {
        searchText = _filter.text;
      });
    }
  }

  Future<void> loadBoekenLijst() async {
    List<Boek> dbLijst = await boekDB.queryAllBoeks();
    boekenLijst.lijstToevoegen(dbLijst);
    setState(() {
      selectielijst = boekenLijst;
    });
  }

  void initState() {
    super.initState();
    loadBoekenLijst();
    _filter.addListener(_updateFilterString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[800],
            elevation: 0.0,
            title: search == false ? titleRow(context) : titleSearch(context),
            actions: <Widget>[
              IconButton(
                icon: _searchIcon,
                onPressed: () {
                  setState(() {
                    if (_searchIcon.icon == Icons.search) {
                      _searchIcon = Icon(Icons.close);
                      search = true;
                    } else {
                      _searchIcon = Icon(Icons.search);
                      _filter.clear();
                      search = false;
                    }
                  });
                },
              ),
            ],
          ),
          body: GewensteBoeken(selectie, searchText, search),
        ),
      ),
    );
  }

  Row titleRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HermanInfo(selectielijst),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                Text(
                  'Bibliografie',
                  style: TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Icon(
                  Icons.info_outline,
                  size: 17.0,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            children: <Widget>[
              Text(
                "Toon: ",
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(
                    () {
                      selectie++;
                      if (selectie > tonen.length - 1) {
                        selectie = 0;
                      }
                    },
                  );
                },
                child: Text(
                  tonen[selectie],
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row titleSearch(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.lightBlue),
                  controller: _filter,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: 'Zoek titel...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
