import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/background_controller.dart';
import 'package:flutter_application_1/global.dart';

class MyMessagerie extends StatefulWidget {
  const MyMessagerie({super.key});

  @override
  State<MyMessagerie> createState() => _MyMessagerieState();
}

class _MyMessagerieState extends State<MyMessagerie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceClient.firstname),
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
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                    width: double.infinity,
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                          hintText: "Entrer votre message"),
                    )),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
