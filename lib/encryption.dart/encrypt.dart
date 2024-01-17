/// Vigenere cipher implementation.
class Vigenere {
  String key;

  /// [key] keyword for cipher.
  Vigenere(this.key);

  String _convert(String text, String m) {
    StringBuffer cipher = StringBuffer();
    int keyIndex = 0;
    String keyUpper = this.key.toUpperCase();

    for (var i = 0; i < text.length; i++) {
      String ch = text[i];

      if (isLetter(ch)) {
        int alphaIndex = alphabet.indexOf(ch.toUpperCase());

        if (m == "encrypt") {
          alphaIndex += alphabet.indexOf(keyUpper[keyIndex]);
        } else {
          alphaIndex -= alphabet.indexOf(keyUpper[keyIndex]);
        }

        alphaIndex %= 26;

        String s = alphabet[alphaIndex];
        cipher.write(isUpper(ch) ? s : s.toLowerCase());

        keyIndex++;
        if (keyIndex == keyUpper.length) keyIndex = 0;
      } else {
        cipher.write(ch);
      }
    }
    print(cipher.toString());
    return cipher.toString();
  }

  /// Encrypt [text].
  String encrypt(String text) => _convert(text, "encrypt");

  /// Decrypt [text].
  String decrypt(String text) => _convert(text, "decrypt");
}

final String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
final String digits = "0123456789";
final String punctuation = "!\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~";

// check if string is digit
bool isDigit(String s) => RegExp(r"^[0-9]+$").hasMatch(s);

// check if string is letter
bool isLetter(String s) => RegExp(r"^[a-zA-Z]+$").hasMatch(s);

// check if string is lowercase
bool isLower(String s) {
  var c = s.codeUnitAt(0);

  return c >= 0x61 && c <= 0x7A;
}

// check if string is uppercase
bool isUpper(String s) {
  var c = s.codeUnitAt(0);

  return c >= 0x41 && c <= 0x5A;
}

// check if string is punctuation
bool isPunctuation(String s) =>
    RegExp(r"""[!"#$%&'()*+,-./:;<=>?@[\\\]^_`{|}~]""").hasMatch(s);

// reverse map
Map reverseMap(Map m) => m.map((k, v) => MapEntry(v, k));

// simple python range in dart
List<int> range(int end, {start: 0}) => [for (var i = start; i < end; i++) i];
