import 'package:graffitineeds/encryption.dart/encrypt.dart';
import 'package:graffitineeds/services/apitest.dart';

void main() {
  String vigenere(String text, String key, int encrypt) {
    String result = '';
    int j = 0;
    for (var i = 0; i < text.length; i++) {
      if (encrypt == 1) {
        int x = (text.codeUnitAt(i) + key.codeUnitAt(j)) % 26 + 65;
        result += String.fromCharCode(x);
      } else {
        int y = ((text.codeUnitAt(i) - key.codeUnitAt(j)) % 26 + 26) % 26;
        result += String.fromCharCode(y + 65);
      }
      if (j < key.length - 1)
        j++;
      else
        j = 0;
    }
    print(result);
    return result;
  }

  Vigenere("gn143523525kgoskblsmb15*6").encrypt("GraffitiNeeds2016**");
  Vigenere("gn").decrypt("MegslvzvTrkqy2016**");
}
