import 'package:flutter_application_1/model/user.dart';

import 'package:flutter_application_1/controller/firestore_helper.dart';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/model/music.dart';

String defaultImage =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0IlRFDXG-47Lybx5VDsaOBssU7Qnlb_Ao8A&usqp=CAU";

MyUser me = MyUser();

enum StatutPlayer { play, pause, stop }

void onError(dynamic error) {
  print('Erreur : $error');
}

FirestoreHelper firestoreHelper = FirestoreHelper();

MyUser serviceClient = MyUser();
