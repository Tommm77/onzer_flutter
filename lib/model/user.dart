import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/global.dart';

class MyUser {
  late String lastname;
  late String firstname;
  late String nickname;
  DateTime? birthday;
  String? avatar;
  late String email;
  late String uid;
  List? favory;

  String get fullName => "$firstname $lastname";

  int age() {
    if (birthday == null) {
      return 0;
    }
    DateTime now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month) {
      age--;
    } else if (now.month == birthday!.month && now.day < birthday!.day) {
      age--;
    }
    return age;
  }

  MyUser() {
    lastname = "";
    firstname = "";
    nickname = "";
    email = "";
    uid = "";
  }

  MyUser.database(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
    lastname = map["lastname"];
    firstname = map["firstname"];
    nickname = map["nickname"];
    email = map["email"];
    birthday = map["birthday"]?.toDate();
    avatar = map["avatar"] ?? defaultImage;
    favory = map["favory"] ?? [];
  }
}
