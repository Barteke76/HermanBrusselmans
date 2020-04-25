import 'package:herman_brusselmans/paginas/gewensteBoeken.dart';

final String columnId = '_id';
final String columnTitel = 'titel';
final String columnInhoud = 'inhoud';
final String columnJaar = 'jaar';
final String columnBezit = 'bezit';
final String columnEboek = 'Eboek';
final String columnBoek = 'boek';
final String columnFoto = 'foto';
final String columnUrl = 'url';
final String columnBiografie = 'biografie';

class Boek {
  int id;
  String titel = "";
  String inhoud = "";
  String jaar = "";
  bool bezit = false;
  bool eBoek = false;
  bool boek = false;
  String foto = "";
  String url = "";
  String biografie = "";

  Boek(
      {this.id,
      this.titel,
      this.inhoud,
      this.jaar,
      this.bezit,
      this.eBoek,
      this.boek,
      this.foto,
      this.url,
      this.biografie});

  // convenience constructor to create a Boek object
  Boek.fromDb(Map<String, dynamic> map) {
    id = map[columnId];
    titel = map[columnTitel];
    inhoud = map[columnInhoud];
    jaar = map[columnJaar];
    bezit = map[columnBezit] == 1;
    eBoek = map[columnEboek] == 1;
    boek = map[columnBoek] == 1;
    foto = map[columnFoto];
    url = map[columnUrl];
    biografie = map[columnBiografie];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMapForDb() {
    var map = <String, dynamic>{
      columnTitel: titel,
      columnInhoud: inhoud,
      columnJaar: jaar,
      columnBezit: bezit ? 1 : 0,
      columnEboek: eBoek ? 1 : 0,
      columnBoek: boek ? 1 : 0,
      columnFoto: foto,
      columnUrl: url,
      columnBiografie: biografie,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
