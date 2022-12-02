import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class otherMsgWidget extends StatelessWidget {
  final String mandante, msg;
  const otherMsgWidget({super.key, required this.mandante, required this.msg});
  @override
  Widget build(BuildContext context) {
    //per la data da modificare
    DateTime now = DateTime.now();
    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    //
    return Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width -
                MediaQuery.of(context).size.width *
                    0.30), //prende la dimensione dello shcermo e ne toglie 45 pixel, questa dimensione sarà la dimesioo del box allieneata a destra
        child: Card(
          color: Color.fromARGB(255, 158, 156, 156), //da cambiare
          shape: //bordi torndi belli dei messaggi
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //colonne per il nome del mandante e per il messaggio (2colone)
              children: [
                Text(
                  mandante,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 0, 0)),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  msg,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                //Text("orario"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
