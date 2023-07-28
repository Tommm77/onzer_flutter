import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/background_controller.dart';
import 'package:flutter_application_1/controller/firestore_helper.dart';
import 'package:flutter_application_1/global.dart';

class MyMessagerie extends StatefulWidget {
  const MyMessagerie({super.key});

  @override
  State<MyMessagerie> createState() => _MyMessagerieState();
}

class _MyMessagerieState extends State<MyMessagerie> {
  final TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    if (me.email == "tommytom@gmail.com") {
      FirestoreHelper().getUser("FVahUI70KTN0tsjqBRm0JMrGmGZ2").then((value) {
        setState(() {
          receiver = value;
        });
        print("me.uid = ${me.uid}");
        print("receiver.uid = ${receiver.uid}");
      });

      super.initState();
    } else if (me.email == "serviceiencli@gmail.com") {
      FirestoreHelper().getUser("H6Fvg94SwqS37q90igaZCHuTUYD2").then((value) {
        setState(() {
          receiver = value;
        });
      });
    } else {
      print("cela ne fonctionne pas");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.firstname),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return Stack(
      children: [
        MyBackground(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MessagerieView(),
        ),
      ],
    );
  }

  Widget MessagerieView() {
    print('Building MessagerieView');
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreHelper().getChatMessages(me.uid, receiver.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(
                      'StreamBuilder builder called with data: ${snapshot.data}');
                  if (snapshot.hasError) {
                    print('StreamBuilder error: ${snapshot.error}');
                    return Text('Une erreur s\'est produite');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Chargement...");
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      print('ListTile data: $data');
                      return ListTile(
                        title: Text(data['text']),
                        subtitle: Text(data['senderID'] == me.uid
                            ? "Vous"
                            : receiver.firstname),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  child: TextField(
                    controller: messageTextController,
                    decoration: InputDecoration.collapsed(
                        hintText: "Entrer votre message"),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  String text = messageTextController.text;
                  print('Sending message: $text');
                  FirestoreHelper().sendMessage(me.uid, receiver.uid, text);
                  messageTextController.clear();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
