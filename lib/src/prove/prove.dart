import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

main() {
  var path = './lib/src/prove/primi.txt';
  int cont = 0;
  var p = new BigInt.from(0);
  var q = new BigInt.from(0);
  var e = new BigInt.from(0);
  var n = new BigInt.from(0);
  var d = new BigInt.from(0);
  var m = new BigInt.from(0);
  //print("path: " + path);
  var myFile = new File(path);
// assuming a utf8 encoding
  var numberOfLines = myFile.readAsLinesSync().length;
  //print(numberOfLines);
  final _random = new Random();
  int min = 0, r1, r2, r3;
  r1 = min + _random.nextInt(numberOfLines - min);
  do {
    r2 = min + _random.nextInt(numberOfLines - min);
  } while (r1 == r2);
  do {
    r3 = min + _random.nextInt(numberOfLines - min);
  } while (r3 == r1 || r3 == r2);
  //print(r1);
  new File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter());
  List<String> lines = myFile
      .readAsLinesSync(); //foreach sincrono altrimenti esegue prima le righe sotto e poi il foreach
  lines.forEach((l) {
    if (cont == r1) {
      p = BigInt.parse(l);
    }
    if (cont == r2) {
      q = BigInt.parse(l);
    }
    if (cont == r3) {
      e = BigInt.parse(l);
    }
    cont++;
  });
  n = p * q;
  m = (q - BigInt.one) * (p - BigInt.one);
  d = e.modInverse(m);
  int prove = 0, molt = 1;
  String mes = "ciao";
  var cript = new BigInt.from(0);
  var temp = new BigInt.from(0);
  var decrypt = new BigInt.from(0);
  List<int> bytes = utf8.encode(mes);
  int lunghezza = bytes.length;
  var strArr = [];
  //print(lunghezza);
  for (int i = 0; i < lunghezza; i++) {
    print(bytes[i]);
    temp = BigInt.from(bytes[i]);
    cript = temp.modPow(e, n);
    //print(cript);
    decrypt = cript.modPow(d, n);
    //print(decrypt);
    //strArr[i] = "ciao";
  }
  for (int i = lunghezza; i > 0; i--) {
    prove = prove + bytes[i - 1] * molt;
    if (bytes[i - 1].toString().length == 2) {
      molt = molt * 100;
    } else if (bytes[i - 1].toString().length == 3) {
      molt = molt * 1000;
    }
  }
  print(prove);
  temp = BigInt.from(prove);
  cript = temp.modPow(e, n);
  print(cript);
  decrypt = cript.modPow(d, n);
  print(decrypt);
  
}
