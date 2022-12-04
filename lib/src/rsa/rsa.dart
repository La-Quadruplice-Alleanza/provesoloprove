import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

generaChiavi() {
  var path = './lib/src/rsa/primi.txt';
  int cont = 0;
  //variabili per rsa
  var p = BigInt.from(0);
  var q = BigInt.from(0);
  var e = BigInt.from(0);
  var n = BigInt.from(0);
  var d = BigInt.from(0);
  var m = BigInt.from(0);
  //link al file
  var myFile = File(path);
  var numberOfLines = myFile.readAsLinesSync().length; //linee nel file
  //genero i numeri casuali
  final random = Random();
  int min = 0, r1, r2, r3;
  r1 = min + random.nextInt(numberOfLines - min);
  do {
    r2 = min + random.nextInt(numberOfLines - min);
  } while (r1 == r2);
  do {
    r3 = min + random.nextInt(numberOfLines - min);
  } while (r3 == r1 || r3 == r2);
  //prendo le linee del file
  File(path).openRead().transform(utf8.decoder).transform(const LineSplitter());
  List<String> lines = myFile //converto in funzione sincrona
      .readAsLinesSync(); //foreach sincrono altrimenti esegue prima le righe sotto e poi il foreach
  for (var l in lines) {
    if (cont == r1) {
      p = BigInt.parse(l); //prendo dalle linee del file primi.txt
    }
    if (cont == r2) {
      q = BigInt.parse(l);
    }
    if (cont == r3) {
      e = BigInt.parse(l);
    }
    cont++;
  }
  n = p * q;
  m = (q - BigInt.one) * (p - BigInt.one);
  d = e.modInverse(m);
  // Cpub = e,n Cpriv = e,n
  //0 = pubblica (e)
  //1= privata (d)
  //2 = n
  var chiavi = [e, d, n]; // crea un array di grandeza dinamica lIST<BIGINT>
  //print(chiavi[1]);
  return chiavi;
}
