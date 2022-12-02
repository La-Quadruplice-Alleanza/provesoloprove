import 'dart:async';
import 'dart:io';
import 'dart:convert';

main() {
  var path = './lib/src/prove/primi.txt';
  print("path: " + path);
  new File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .forEach((l) => print('line: $l'));
}
