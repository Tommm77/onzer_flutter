import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/model/music.dart';
import 'package:flutter_application_1/model/user.dart';

class FirestoreHelper {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection('users');
  final cloudMusics = FirebaseFirestore.instance.collection('musics');

  List<MyMusic> Musics = [
    MyMusic.build(
        title: "Médicale",
        artist: "Houdi",
        uid: "ahuahuahauh",
        file:
            "https://firebasestorage.googleapis.com/v0/b/flutterschool-975b9.appspot.com/o/Music%2FX2Download.app%20-%20HOUDI%20-%20M%C3%89DICALE%20(128%20kbps).mp3?alt=media&token=ee18d3cf-58b9-4866-8bba-c9412dad8344",
        image:
            "https://cdns-images.dzcdn.net/images/cover/695db496e38fdf36d229f1cb536db744/264x264.jpg")
  ];

  initMusic() {
    for (MyMusic music in Musics) {
      Map<String, dynamic> map = {
        "title": music.title,
        "artist": music.artist,
        "file": music.file,
      };
      addMusic(music.uid, map);
    }
  }

  addMusic(String uid, Map<String, dynamic> data) {
    cloudMusics.doc(uid).set(data);
  }

  Future<MyUser> inscription(String email, String firstname, String lastname,
      String nickname, String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = credential.user?.uid ?? "";
    Map<String, dynamic> map = {
      "lastname": lastname,
      "firstname": firstname,
      "nickname": nickname,
      "email": email,
      "uid": "",
      "favory": []
    };

    addUser(uid, map);
    return getUser(uid);
  }

  updateUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).update(data);
  }

  Future<MyUser> getUser(String uid) async {
    DocumentSnapshot documentSnapshot = await cloudUsers.doc(uid).get();
    return MyUser.database(documentSnapshot);
  }

  connect(String email, String password) async {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user?.uid ?? "";
    return getUser(uid);
  }

  addUser(String uid, Map<String, dynamic> data) {
    cloudUsers.doc(uid).set(data);
  }

  Future<String> stockageFiles(String destination, String uidUser,
      String nameImage, Uint8List bytes) async {
    String url = "";
    TaskSnapshot snapshot =
        await storage.ref("$destination/$uidUser/$nameImage").putData(bytes);
    url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<MyMusic> getMusicDetails(String musicId) async {
    DocumentSnapshot documentSnapshot = await cloudMusics.doc(musicId).get();
    return MyMusic.dataBase(documentSnapshot);
  }
}
