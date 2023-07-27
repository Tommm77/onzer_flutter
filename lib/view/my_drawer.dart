import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/firestore_helper.dart';
import 'package:flutter_application_1/view/my_messagerie.dart';

import '../global.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isEditing = false;
  TextEditingController nickname = TextEditingController();
  String? nameImage;
  Uint8List? bytesImage;

  showCalendar() async {
    DateTime? time = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (time != null) {
      setState(() {
        me.birthday = time;
      });
      Map<String, dynamic> map = {
        "birthday": time,
      };
      FirestoreHelper().updateUser(me.uid, map);
    }
  }

  pickerImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      setState(() {
        bytesImage = result.files.first.bytes;
        nameImage = result.files.first.name;
      });
      popImage();
    }
  }

  popImage() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Voulez-vous changer votre photo de profil ?"),
            content: Image.memory(bytesImage!),
            actions: [
              CupertinoDialogAction(
                child: const Text("Oui"),
                onPressed: () {
                  FirestoreHelper()
                      .stockageFiles("photos", me.uid, nameImage!, bytesImage!)
                      .then((value) {
                    setState(() {
                      me.avatar = value;
                    });
                    Map<String, dynamic> datas = {"avatar": me.avatar};
                    FirestoreHelper().updateUser(me.uid, datas);
                  });
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text("Non"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              pickerImage();
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(me.avatar ?? defaultImage),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            me.fullName,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
              onTap: () {
                showCalendar();
              },
              child: Text("AGE : ${me.age()}")),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            thickness: 3,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: (isEditing)
                ? TextField(
                    controller: nickname,
                    decoration: InputDecoration.collapsed(
                      hintText: me.nickname,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ))
                : Text(me.nickname),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  if (nickname.text.isNotEmpty && isEditing == true) {
                    Map<String, dynamic> map = {
                      "nickname": nickname.text,
                    };
                    FirestoreHelper().updateUser(me.uid, map);
                  }

                  setState(() {
                    me.nickname = nickname.text;
                    isEditing = !isEditing;
                  });
                });
              },
              icon: Icon((isEditing) ? Icons.save : Icons.edit),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(me.email),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MyMessagerie();
              }));
            },
            leading: Icon(Icons.chat_bubble),
            title: Text("Contacts"),
          ),
        ],
      ),
    ));
  }
}
