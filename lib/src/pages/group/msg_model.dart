import 'package:flutter/cupertino.dart';

class MsgModel {
  String type; //stringa
  String msg; //messaggio
  String mandante; //chi invia il messaggio
  MsgModel({required this.msg, required this.type, required this.mandante});
}
