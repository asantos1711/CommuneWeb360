import 'package:encrypt/encrypt.dart';

class EncryptData {
//for AES Algorithms

  static late Encrypted encrypted;
  static var decrypted;

  static encryptAES(plainText) {
    final key = Key.fromBase64("6q65bEGhodPmCIhWWu7rqQBJQERJ/PpV+5xKcqObGsU=");
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted.base64);
    return encrypted.base64;
  }

  static decryptAES(plainText) {
    final key = Key.fromBase64("6q65bEGhodPmCIhWWu7rqQBJQERJ/PpV+5xKcqObGsU=");
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    decrypted = encrypter.decrypt64(plainText, iv: iv);
    print(decrypted);
    return decrypted;
  }
}
