import 'package:herman_brusselmans/services/boek.dart';

class BoekenLijst {
  List<Boek> boekenLijst = [];

  void boekToevoegen(Boek newBoek) {
    boekenLijst.add(newBoek);
  }

  int volgendeBoek(int index) {
    index++;
    if (index > boekenLijst.length - 1) {
      index = 0;
    }
    return index;
  }

  String getJaar(index) {
    String jaar;
    jaar = boekenLijst[index].jaar;
    return jaar;
  }

  int vorigeBoek(int index) {
    index--;
    if (index < 0) {
      index = boekenLijst.length - 1;
    }
    return index;
  }

  String getInhoud(int index) {
    String inhoud;
    inhoud = boekenLijst[index].inhoud;
    return inhoud;
  }

  String getBio(){
    return boekenLijst[0].biografie;
  }

  String getTitel(int index) {
    String titel;
    titel = boekenLijst[index].titel;
    return titel;
  }

  int getBoekenLijstLengte() {
    return boekenLijst.length;
  }

  String getFoto(int index) {
    String foto = "";

    foto = boekenLijst[index].foto;

    return foto;
  }

  bool getBezit(int index) {
    return boekenLijst[index].bezit;
  }

  void changeBezit(index) {
    if (boekenLijst[index].bezit == true) {
      boekenLijst[index].bezit = false;
    } else {
      boekenLijst[index].bezit = true;
    }
  }
}
