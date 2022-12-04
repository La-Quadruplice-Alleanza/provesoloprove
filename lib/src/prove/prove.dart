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
  //int prove = 0, molt = 1;
  String mes = "Hello, world!";
  var prove = new BigInt.from(0);
  var molt = new BigInt.from(1);
  var cript = new BigInt.from(0);
  var temp = new BigInt.from(0);
  var decrypt = new BigInt.from(0);
  List<int> bytes = utf8.encode(mes);
  int lunghezza = bytes.length;
  print(lunghezza);
  //String strArr;
  //print(lunghezza);
  //int lung, prova = 0, base = 1;
  var lung = new BigInt.from(0);
  var prova = new BigInt.from(0);
  var base = new BigInt.from(1);
  // cripto e decripto i singoli carratteri
  /*for (int i = lunghezza - 1; i >= 0; i--) {
    print(bytes[i]);
  }*/
  for (int i = lunghezza - 1; i >= 0; i--) {
    prove = prove + molt * BigInt.from(bytes[i]);
    //print(bytes[i]);
    if (bytes[i].toString().length == 2) {
      molt = molt * BigInt.from(100);
    } else if (bytes[i].toString().length == 3) {
      molt = molt * BigInt.from(1000);
    }
  }

  print(prove);
  //
  for (int i = lunghezza; i > 1; i--) {
    base = base * BigInt.from(10);
  }
  //int provola = 0;
  var provola = new BigInt.from(0);
  for (int i = 0; i < lunghezza; i++) {
    if (bytes[i].toString().length == 2) {
      provola = base * BigInt.from(2);
    } else if (bytes[i].toString().length == 3) {
      provola = base * BigInt.from(3);
    }
    prova = prova + provola;
    base = base ~/ BigInt.from(10);
  }
  print(prova);
  //print(prove);
  temp = prove;
  cript = temp.modPow(e, n);
  print(cript);
  decrypt = cript.modPow(d, n);
  print(decrypt);
  int lun = prova.toString().length;
  molt = BigInt.one;
  //int appoggio = 0, appMess = 0;
  var appoggio = new BigInt.from(0);
  var appMess = new BigInt.from(0);
  String messDecript = "";
  for (int i = lunghezza; i > 0; i--) {
    appoggio = prova % BigInt.from(10);
    prova = prova ~/ BigInt.from(10);
    print(appoggio);
    if (appoggio.toInt() == 3) {
      appMess = decrypt.modPow(BigInt.from(1), BigInt.from(1000));
      print(appMess);
      messDecript = messDecript + String.fromCharCode(appMess.toInt());
      decrypt = decrypt ~/ BigInt.from(1000);
    } else if (appoggio.toInt() == 2) {
      appMess = decrypt.modPow(BigInt.from(1), BigInt.from(100));
      print(appMess);
      messDecript = messDecript + String.fromCharCode(appMess.toInt());
      decrypt = decrypt ~/ BigInt.from(100);
    }
  }
  //print(messDecript);
  messDecript = messDecript.split('').reversed.join();
  print(messDecript);
}
