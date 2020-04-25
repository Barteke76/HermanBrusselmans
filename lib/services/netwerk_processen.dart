import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class NetwerkProcessen {
  String biografie = "";
  List<String> _urlLijst = [];
  List<String> titelLijst = [];
  List<String> fotoLijst = [];
  List<String> jaarLijst = [];
  List<String> inhoudLijst = [];

  //Web-site aflopen voor de boekenlijst en de url's
  Future<List<String>> inlezenBoekenLijst() async {
    var response = await http.get(
        "https://hermanbrusselmans.nl/boeken/bloed-spuwen-naar-de-hematoloog");
    var document = parser.parse(response.body);
    var content = document.getElementById("right_content");
    var gegevens = content.getElementsByTagName("a");
    _urlLijst = gegevens.map((cover) => cover.attributes['href']).toList();
    titelLijst = gegevens.map((cover) => cover.attributes['title']).toList();
    return _urlLijst;
  }

  //titel, jaar en inhoud van een boek scrappen van een website
  Future<void> boekInhoud(int i, bool extra) async {
    try {
      var response = await http.get(_urlLijst[i]);
      var document = parser.parse(response.body);
      var content = document.getElementById("leftcolumn");
      var content2 = content.getElementsByClassName("text");

      //Zoeken naar boekcover
      var gegevens = content2[1].getElementsByTagName("a");
      var foto = gegevens.map((cover) => cover.attributes['href']).toList();
      if (extra == false) {
        fotoLijst.add(foto[0]);
      } else {
        fotoLijst[i] = foto[0];
      }

      //jaartal filteren van content2[1].outerHtml
      var jaar = (content2[1].outerHtml).split("Publicatie jaar:</b><br>");
      jaar = jaar[1].split("<br>");
      if (extra == false) {
        jaarLijst.add(jaar[0]);
      } else {
        jaarLijst[i] = jaar[0];
      }
      // //inhoud filteren tekst[1]
      var inhoud = (content2[1].outerHtml).split("<b>Beschrijving:</b><br>");
      inhoud = inhoud[1].split("<div");
      inhoud[0] = inhoud[0].replaceAll("<br>", "\n");
      if (extra == false) {
        inhoudLijst.add(inhoud[0]);
      } else {
        inhoudLijst[i] = inhoud[0];
      }
    } catch (e) {
      if (extra == false) {
        fotoLijst.add("");
        jaarLijst.add("");
        inhoudLijst.add("");
      } else {
        fotoLijst[i] == "";
        jaarLijst[i] == "";
        inhoudLijst[i] == "";
        print(_urlLijst[i]);
      }
    }
  }

  //Alle inhoud van alle boeken scrappen van de websites
  Future<void> alleBoekenInhoud() async {
    for (var i = 0; i < _urlLijst.length; i++) {
      await boekInhoud(i, false);
    }
  }

  //biografie scrappen van website en vervolgens tekst opschonen
  //(HTML tekst verwijderen)
  Future<void> bioHerman() async {
    //biografie van herman brusselmans toevoegen
    var response = await http.get("https://hermanbrusselmans.nl/biografie");
    var document = parser.parse(response.body);
    var content = document.getElementById("leftcolumn");
    var content2 = content.getElementsByClassName("text no_border_mobile");
    var tekst = (content2[0].outerHtml).split("<br><i>");
    tekst = tekst[1].split("Meer biografische verhalen");
    biografie = tekst[0].replaceAll("<br>", "\n");
    biografie = biografie.replaceAll("</i>", "");
    biografie = biografie.replaceAll("&nbsp;", "");
    biografie = biografie.replaceAll("<i>", " ");
    biografie = biografie.replaceAll("door <a href=", " ");
    biografie = biografie.replaceAll("><u>hier naartoe te gaan</u></a>", "");
  }
}
