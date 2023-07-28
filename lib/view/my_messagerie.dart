import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/controller/background_controller.dart';
import 'package:flutter_application_1/controller/firestore_helper.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/model/user.dart';

class MyMessagerie extends StatefulWidget {
  const MyMessagerie({Key? key}) : super(key: key);

  @override
  State<MyMessagerie> createState() => _MyMessagerieState();
}

class _MyMessagerieState extends State<MyMessagerie> {
  final TextEditingController messageTextController = TextEditingController();
  late Future<MyUser> futureReceiver;

  @override
  void initState() {
    super.initState();

    if (me.email == "tommytom@gmail.com") {
      futureReceiver =
          FirestoreHelper().getUser("FVahUI70KTN0tsjqBRm0JMrGmGZ2");
    } else if (me.email == "serviceiencli@gmail.com") {
      futureReceiver =
          FirestoreHelper().getUser("H6Fvg94SwqS37q90igaZCHuTUYD2");
    } else {
      print("cela ne fonctionne pas");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyUser>(
      future: futureReceiver,
      builder: (BuildContext context, AsyncSnapshot<MyUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text("Une erreur s'est produite")));
        }

        receiver = snapshot.data!;
        print("me.uid = ${me.uid}");
        print("receiver.uid = ${receiver.uid}");

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
      },
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirestoreHelper().getChatMessages(me.uid, receiver.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    print(
                        'StreamBuilder builder called with data: ${snapshot.data}');
                    if (snapshot.hasError) {
                      print('StreamBuilder error: ${snapshot.error}');
                      return Text('Une erreur s\'est produite');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        print('ListTile data: $data');
                        return Align(
                          alignment: (data['senderID'] == me.uid)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: (data['senderID'] == me.uid)
                                  ? Colors.blue[200]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(data['text']),
                          ).animate().slide(duration: const Duration(milliseconds: 500)),
                        ).animate().fade(duration: const Duration(milliseconds: 500));
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
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

                    List<String> ids = [me.uid, receiver.uid];
                    ids.sort();

                    String chatID = ids[0] + ids[1];
                    FirestoreHelper()
                        .sendMessage(chatID, me.uid, receiver.uid, text);
                    messageTextController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
