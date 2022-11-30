import 'package:flutter/material.dart';

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
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
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
                  const Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState(); //when this route starts, it will execute this code
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
