import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/animation_fav.dart';
import 'package:flutter_application_1/controller/firestore_helper.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/model/music.dart';
import 'package:flutter_application_1/view/player_music.dart';
import 'package:flutter_application_1/model/user.dart';

class AllMusic extends StatefulWidget {
  const AllMusic({Key? key}) : super(key: key);

  @override
  _AllMusicState createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic> {
  FirestoreHelper firestoreHelper = FirestoreHelper();

  void addToFavorite(MyMusic music) async {
    MyUser currentUser =
        await firestoreHelper.getUser(firestoreHelper.auth.currentUser!.uid);

    String snackMessage;

    if (currentUser.favory == null) {
      currentUser.favory = [music.uid];
      me.favory = [music.uid];
      snackMessage = "La musique a été ajoutée aux favoris";
    } else if (!currentUser.favory!.contains(music.uid)) {
      currentUser.favory!.add(music.uid);
      me.favory!.add(music.uid);
      snackMessage = "La musique a été ajoutée aux favoris";
    } else {
      currentUser.favory!.remove(music.uid);
      me.favory!.remove(music.uid);
      snackMessage = "La musique a été retirée des favoris";
    }

    firestoreHelper.updateUser(currentUser.uid, {'favory': currentUser.favory});

    // Affiche la snackbar avec le message correspondant
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> isFavorite(MyMusic music) async {
    MyUser currentUser =
        await firestoreHelper.getUser(firestoreHelper.auth.currentUser!.uid);
    return currentUser.favory != null &&
        currentUser.favory!.contains(music.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreHelper.cloudMusics.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (!snap.hasData) {
          return Text("Erreur lors du chargement");
        } else {
          List<MyMusic> musicList =
              snap.data!.docs.map((doc) => MyMusic(doc)).toList();
          return ListView.builder(
            itemCount: musicList.length,
            itemBuilder: (context, index) {
              MyMusic music = musicList[index];
              return Card(
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: FutureBuilder<bool>(
                  future: isFavorite(music),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPlayerMusic(
                                musicList: musicList,
                                currentMusicIndex: index,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        leading: Image.network(
                          music.image ?? defaultImage,
                          width: 100,
                        ),
                        title: Text(music.title),
                        subtitle: Text(music.artist),
                        trailing:  LikeAnimation(
                          isFav: me.favory!.contains(music.uid) ? true : false,
                          onpressed: () => addToFavorite(music),
                        )
                      );/*IconButton(
                          icon: Icon(
                            snapshot.data ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => addToFavorite(music),
                        ),
                      );*/
                    }
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
