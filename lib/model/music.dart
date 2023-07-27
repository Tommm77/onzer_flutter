import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/global.dart';

class MyMusic {
  late String uid;
  late String title;
  late String artist;
  late String file;
  String? image;
  String? album;

  MyMusic(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    title = map["title"];
    artist = map["artist"];
    file = map["file"];
    album = map["album"] ?? "";
    image = map["image"] ?? defaultImage;
  }

  MyMusic.build(
      {required this.title,
      this.image,
      required this.artist,
      required this.uid,
      this.album,
      required this.file});

  MyMusic.dataBase(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    title = map["title"];
    artist = map["artist"];
    file = map["file"];
    image = map["image"] ?? defaultImage;
  }
}
