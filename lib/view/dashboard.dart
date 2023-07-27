import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/all_music.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/model/music.dart';
import 'package:flutter_application_1/view/player_music.dart';

import '../controller/background_controller.dart';
import '../controller/firestore_helper.dart';
import 'my_drawer.dart';

class MySecondPage extends StatefulWidget {
  String email;
  MySecondPage({required this.email});
  @override
  State<MySecondPage> createState() => _MySecondPage();
}

class _MySecondPage extends State<MySecondPage> {
  int _currentIndex = 0;
  FirestoreHelper firestoreHelper = FirestoreHelper();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      refreshFavorites();
    }
  }

  void refreshFavorites() {
    myMusicList.clear();
    inittab();
  }

  void inittab() async {
    for (String uid in me.favory!) {
      firestoreHelper.getMusicDetails(uid).then((value) {
        setState(() {
          myMusicList.add(value);
        });
      });
    }
  }

  List<MyMusic> myMusicList = [];

  @override
  void initState() {
    inittab();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(85), topRight: Radius.circular(85)),
        ),
        child: const MyDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const MyBackground(),
          SafeArea(child: bodyPage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Musique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
        ],
      ),
    );
  }

  Widget bodyPage() {
    if (_currentIndex == 0) {
      return const AllMusic();
    } else {
      return ListView.builder(
          itemCount: myMusicList.length,
          itemBuilder: (context, index) {
            MyMusic music = myMusicList[index];
            print(music.image);
            return ListTile(
              title: Text(music.title),
              subtitle: Text(music.artist),
              leading: Image.network(music.image ?? defaultImage),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyPlayerMusic(
                            musicList: myMusicList,
                            currentMusicIndex: index,
                          )),
                ).then((value) {
                  if (value == true) {
                    refreshFavorites();
                  }
                });
              },
            );
          });
    }
  }
}
