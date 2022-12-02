import 'package:flutter/material.dart';
import 'msg_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupPage extends StatefulWidget {
  final String nomeUtente;
  const GroupPage({
    Key? key,
    required this.nomeUtente, //senza nome non posso arrivare a questa schermata, (serve a flutter per escluderla)
  });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket; //? serve a nonn accettare valori se null
  List<MsgModel> listMsg =
      []; //conterrà i messaggi con che tipo di messaggio sono
  TextEditingController _messController = TextEditingController();
  bool _visible = true;
  bool fissa = false;
  @override //server per far scopearire un widget dopo x secondi
  void initState() {
    super
        .initState(); //questo codice viene eseguito appena avviamo questa schermata
    connect();
    Future.delayed(const Duration(seconds: 2), () {
      //asynchronous delay
      if (this.mounted) {
        //checks if widget is still active and not disposed
        setState(() {
          //tells the widget builder to rebuild again because ui has updated
          _visible =
              false; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
        });
      }
    });
  }

  void connect() {
    //connesione a socketio
    // Dart client
    socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print("Client: Connesso");
    });
  }

  void sendMsg(String msg, String mandante) {
    //da rcihaiamre quando premo l;'icona di invio
    //inviamo un oggetto
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "mandante": mandante,
    }); //sendMsg è l'evento, msg la stringa da inviare
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Visibility(
          visible: _visible,
          replacement: const Text("Chat"),
          child: Text("Benvenuto, ${widget.nomeUtente}",
              style: const TextStyle(fontSize: 20)),
        ),
      ),
      body: Column(
        children: [
          //elenco messaggi, quindi colonne
          Expanded(
            child: Container(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messController,
                    decoration: InputDecoration(
                      hintText: "Scrivi un messaggio...",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          String messaggio = _messController.text;
                          if
                          sendMsg(_messController.text, widget.nomeUtente);
                          _messController.clear();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.green,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
//capisci come metterlo
/* body: Center(
          child: Visibility(
              visible: _visible,
              child: Text(
                "Benvenuto ${widget.nomeUtente}",
                style: const TextStyle(fontSize: 20),
              )),
        )*/
