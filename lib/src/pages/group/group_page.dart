import 'package:flutter/material.dart';
import 'package:myfirstapp/src/pages/foundation/msg_widget/other_msg_widget.dart';
import 'package:myfirstapp/src/pages/foundation/msg_widget/own_msg_widget.dart';
import 'package:myfirstapp/src/pages/group/chiavi_oggetto.dart';
import 'package:myfirstapp/src/rsa/rsa.dart';
import 'package:uuid/uuid.dart';
import 'msg_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupPage extends StatefulWidget {
  final String nomeUtente;
  final String userId;
  const GroupPage(
      {Key? key,
      required this.nomeUtente,
      required this.userId //senza nome non posso arrivare a questa schermata, (serve a flutter per escluderla)
      });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  var chiavi;
  String provettaE = "";
  String provettaD = "";
  String provettaN = "";

  IO.Socket? socket; //? serve a nonn accettare valori se null
  List<MsgModel> listMsg =
      []; //conterrà i messaggi con che tipo di messaggio sono
  List<chiaviModel> listaChiavi = [];
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
      /*chiavi = GeneraChiavi().generaChiavi();
      provettaE = chiavi[0].toString();
      provettaD = chiavi[1].toString();
      provettaN = chiavi[2].toString();*/
      provettaE = BigInt.from(10).toString();
      provettaD = BigInt.from(20).toString();
      provettaN = BigInt.from(30).toString();
      sendChiavi("chiavi", widget.userId);
      //mettiamo in ascolto il client
      socket!.on("sendMsgServer", (msg) {
        //print(msg);
        //compiliamo la lista con i messaggi ricevuti
        if (msg["uuid"] != widget.userId) {
          //se il messaggio è dello stesso userid non lo stampo (rischio che stampava in verde anche s enon ero io ad inviarlo)
          setState(() {
            //aggiorniamo la ui appena aggiorniamo la lista
            listMsg.add(MsgModel(
                msg: msg["msg"], type: msg["type"], mandante: msg["mandante"]));
          });
        }
      });
    });
  }

  void sendChiavi(String chiavi, String userId) {
    chiaviModel oggettoChiavi = chiaviModel(
        type: "Chiavi",
        uuid: widget.userId,
        chiavePubE: provettaE,
        chiavePubN:
            provettaN); //mettiamo in una lista il contenuto degli oggetti rivecuti e inviati
    listaChiavi.add(
        oggettoChiavi); //possiamo visualizzarli nella gui estrandeli e visualizzandoli
    socket!.emit('chiavi', {
      "type": "chiavii",
      "uuid": widget.userId,
      "chiavePubE": provettaE,
      "chiavePubN": provettaN
    }); //sendMsg è l'evento, msg la stringa da inviare
  }

  void sendMsg(String msg, String mandante) {
    //da rcihaiamre quando premo l;'icona di invio
    //inviamo un oggetto
    MsgModel ownMsg = MsgModel(
        msg: msg,
        type: "ownMsg",
        mandante:
            mandante); //mettiamo in una lista il contenuto degli oggetti rivecuti e inviati
    listMsg.add(
        ownMsg); //possiamo visualizzarli nella gui estrandeli e visualizzandoli
    setState(() {
      listMsg; //mutiamo lpo stato della ui seguendo le regole della lista
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "mandante": mandante,
      "uuid": widget.userId,
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
              //context e index sono i due paramentri ella fuzionme buildcontext
              child: ListView.builder(
                  //ritorna un widget della lunghezza Itemcount
                  itemCount: listMsg.length,
                  itemBuilder: (context, index) {
                    //mandiamo alla funzione di visualizzazione in base al tipo di messaggio (mio o di altri)
                    if (listMsg[index].type == "ownMsg") {
                      return ownMsgWidget(
                          mandante: listMsg[index].mandante,
                          msg: listMsg[index].msg);
                    } else {
                      return otherMsgWidget(
                          mandante: listMsg[index].mandante,
                          msg: listMsg[index].msg);
                    }
                  })),

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
                          if (messaggio.isNotEmpty) {
                            sendMsg(_messController.text, widget.nomeUtente);
                            _messController.clear();
                          }
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
