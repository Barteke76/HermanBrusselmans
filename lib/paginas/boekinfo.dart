import 'package:flutter/material.dart';

class BoekInfo extends StatelessWidget {
  final Map lijst;
  final String titel;

  BoekInfo(this.lijst, this.titel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(onTap: () {Navigator.pop(context);}, child: Icon(Icons.arrow_back)),
        title: Text('Boek Info'),
        centerTitle: true,
      ),
      body: Card(
        elevation: 8.0,
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(width: double.infinity),
              Text(
                titel,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Image.network('https://www.deslegte.be' + lijst[titel]),
            ],
          ),
        ),
      ),
    );
  }
}
