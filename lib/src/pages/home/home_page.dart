import 'package:flutter/material.dart';
import 'package:myfirstapp/src/pages/group/group_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController input = TextEditingController();
  final attivaValidazione = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Socket 3"),
        ),
        body: Center(
          child: TextButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Ciao, inserisci un nome utente"),
                      content: Form(
                        key: attivaValidazione,
                        child: TextFormField(
                          controller: input,
                          validator: (nome) {
                            String? controllami = nome;
                            //print(controllami);
                            if (controllami == "") {
                              return "Inserisci il nome utente";
                            } else {
                              if (controllami!.length < 3) {
                                return "Il nome utente è troppo corto, minimo 3 caratteri";
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            input.clear(); //cxancelliamo la form di input
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Annulla",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //print(input.text);
                            if (attivaValidazione.currentState!
                                .validate()) //restituisce true o false (boolean)
                            {
                              String nomeUtente = input.text;
                              input.clear();
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupPage(
                                      nomeUtente: nomeUtente,
                                    ), // richiamiamo la schermata groupPage e passiamo come argomento il nome utente
                                  ));
                            }
                          },
                          child: const Text(
                            "Inserisci",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        )
                      ],
                    )),
            child: const Text(
              "Benvenuto in socket 3",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ));
  }
}
