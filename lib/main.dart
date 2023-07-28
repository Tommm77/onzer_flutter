// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/controller/animation_controller.dart';
import 'package:flutter_application_1/controller/firestore_helper.dart';
import 'package:flutter_application_1/controller/permission_photo.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/view/dashboard.dart';
import 'controller/background_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PermissionPhoto().init();
  // FirestoreHelper().initMusic();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amberAccent,
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
            .copyWith(secondary: Colors.amberAccent),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController firstname = TextEditingController();
  double randomNumber = (new Random().nextDouble() * 10) - 10;

  SnackBar snackBarShow() {
    return SnackBar(
        backgroundColor: Colors.amberAccent,
        duration: const Duration(minutes: 5),
        content: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: lastname,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.amber,
                        ),
                        hintText: "Entrez votre nom",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  TextField(
                    controller: firstname,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.amber,
                        ),
                        hintText: "Entrez votre prenom",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  TextField(
                    controller: nickname,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.amber,
                        ),
                        hintText: "Entrez votre Pseudo",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.amber,
                        ),
                        hintText: "Entrez votre email",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.amber,
                        ),
                        hintText: "Entrez votre password",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                      ),
                      onPressed: (() {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        FirestoreHelper().inscription(
                            email.text,
                            firstname.text,
                            lastname.text,
                            nickname.text,
                            password.text);
                      }),
                      child: const Text("Inscription",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            backgroundColor: Colors.amber),
        body: Stack(
          children: [
            const MyBackground(),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyAnimationController(
                        offsetBegingX: randomNumber,
                        offsetBegingY: randomNumber,
                        delay: 1,
                        child: Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0IlRFDXG-47Lybx5VDsaOBssU7Qnlb_Ao8A&usqp=CAU"),
                      ),
                      MyAnimationController(
                        offsetBegingX: Random().nextDouble() * 10,
                        offsetBegingY: Random().nextDouble() * 10,
                        delay: 1,
                        child: TextField(
                          controller: email,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'email',
                          ),
                        ),
                      ),
                      MyAnimationController(
                        offsetBegingX: randomNumber,
                        offsetBegingY: randomNumber,
                        delay: 1,
                        child: TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      MyAnimationController(
                        offsetBegingX: Random().nextDouble() * 10,
                        offsetBegingY: Random().nextDouble() * 10,
                        delay: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            FirestoreHelper()
                                .connect(email.text, password.text)
                                .then((value) {
                              setState(() {
                                me = value;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MySecondPage(
                                    email: email.text,
                                  ),
                                ),
                              );
                            }).catchError(onError);
                          },
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      MyAnimationController(
                        offsetBegingX: randomNumber,
                        offsetBegingY: randomNumber,
                        delay: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBarShow());
                          },
                          child: const Text('Inscription',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ]),
              )),
            ),
          ],
        ));
  }
}
