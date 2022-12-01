import 'package:flutter/cupertino.dart';

class MsgModel {
  String tipo; //stringa
  String msg; //messaggio
  String mandante; //chi invia il messaggio
  MsgModel({required this.msg, required this.tipo, required this.mandante});
}
