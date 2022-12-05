import 'package:flutter/cupertino.dart';

class chiaviModel {
  String type; //stringa (chaivi)
  String uuid; //identificatore
  String chiavePubN;
  String chiavePubE;
  chiaviModel(
      {required this.type,
      required this.uuid,
      required this.chiavePubE,
      required this.chiavePubN});
}
