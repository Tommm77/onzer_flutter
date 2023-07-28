import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/controller/firestore_helper.dart';
import 'package:flutter_application_1/global.dart';
import 'package:flutter_application_1/model/music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


enum StatutPlayer { play, pause, stop }

class MyPlayerMusic extends StatefulWidget {
  final List<MyMusic> musicList;
  int currentMusicIndex;
  MyPlayerMusic({Key? key, required this.musicList, this.currentMusicIndex = 0})
      : super(key: key);

  @override
  _MyPlayerMusicState createState() => _MyPlayerMusicState();
}

class _MyPlayerMusicState extends State<MyPlayerMusic> {
  bool isPlaying = false;
  bool isFavorite = false;
  late StatutPlayer statutPlayer;
  late AudioPlayer audioPlayer;
  late double volumeSound;
  late Duration dureeTotalMusic;
  late ShakeEffect _shakeEffect;
  late ScaleEffect _scaleEffect;
  late ScaleEffect _scaleEffect2;
  late bool _isFav;
  Duration position = Duration(seconds: 0);

  FirestoreHelper firestoreHelper = FirestoreHelper();

  @override
  void initState() {
    super.initState();
    configurationPlayer();
    checkIfFavorite();

    _shakeEffect = ShakeEffect(
      curve: Curves.easeInOut,
      delay: 0.ms,
      duration: 400.ms,
      hz: 8,
      offset:  Offset(0, 0),
      rotation: 0.262,
    );


    _scaleEffect = ScaleEffect(
      curve: Curves.bounceOut,
      delay: 200.ms,
      duration: 500.ms,
      begin:  Offset(1, 1),
      end:  Offset(2, 2),
    );

    _scaleEffect2 = ScaleEffect(
        curve: Curves.bounceOut,
        delay: 400.ms,
        duration: 500.ms,
        begin:  Offset(1, 1),
        end:  Offset(0.5, 0.5),
    );


  }

  @override
  void dispose() {
    cleanPlayer();
    super.dispose();
  }

  Future<String> fetchArtistBio(String artistName) async {
    String url =
        "https://musicbrainz.org/ws/2/artist/?query=artist:$artistName&fmt=json";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['artists'].isNotEmpty) {
        String bio = jsonResponse['artists'][0]['disambiguation'];
        return bio;
      }
    } else {
      throw Exception('Failed to load artist bio');
    }
    return '';
  }

  void togglePlay() {
    if (statutPlayer == StatutPlayer.stop ||
        statutPlayer == StatutPlayer.pause) {
      play();
      isPlaying = true;
    } else {
      pause();
      isPlaying = false;
    }
  }

  void configurationPlayer() {
    statutPlayer = StatutPlayer.stop;
    volumeSound = 0.5;
    dureeTotalMusic = const Duration(seconds: 8000);
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        dureeTotalMusic = event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    play();
  }

  void cleanPlayer() {
    audioPlayer.stop();
  }

  void play() {
    setState(() {
      statutPlayer = StatutPlayer.play;
      isPlaying = true;
    });
    audioPlayer.play(UrlSource(widget.musicList[widget.currentMusicIndex].file),
        volume: volumeSound);
  }

  void pause() {
    setState(() {
      statutPlayer = StatutPlayer.pause;
      isPlaying = false;
      audioPlayer.pause();
    });
  }

  void nextTrack() {
    int nextIndex = (widget.currentMusicIndex + 1) % widget.musicList.length;
    setState(() {
      widget.currentMusicIndex = nextIndex;
    });
    play();
    checkIfFavorite();
  }

  void previousTrack() {
    int previousIndex =
        (widget.currentMusicIndex - 1 + widget.musicList.length) %
            widget.musicList.length;
    setState(() {
      widget.currentMusicIndex = previousIndex;
    });
    play();
    checkIfFavorite();
  }

  void addToFavorite() async {
    MyUser currentUser =
        await firestoreHelper.getUser(firestoreHelper.auth.currentUser!.uid);

    String snackMessage;

    if (currentUser.favory == null) {
      currentUser.favory = [widget.musicList[widget.currentMusicIndex].uid];
      me.favory = [widget.musicList[widget.currentMusicIndex].uid];
      isFavorite = true;
      snackMessage = "La musique a été ajoutée aux favoris";
    } else if (!currentUser.favory!
        .contains(widget.musicList[widget.currentMusicIndex].uid)) {
      setState(() {
        currentUser.favory!.add(widget.musicList[widget.currentMusicIndex].uid);
        me.favory!.add(widget.musicList[widget.currentMusicIndex].uid);
        isFavorite = true;
      });
      snackMessage = "La musique a été ajoutée aux favoris";
    } else {
      setState(() {
        currentUser.favory!
            .remove(widget.musicList[widget.currentMusicIndex].uid);
        isFavorite = false;
        me.favory!.remove(widget.musicList[widget.currentMusicIndex].uid);
      });
      snackMessage = "La musique a été retirée des favoris";
    }

    setState(() {
      firestoreHelper
          .updateUser(currentUser.uid, {'favory': currentUser.favory});
    });

    // Affiche la snackbar avec le message correspondant
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void checkIfFavorite() async {
    MyUser currentUser =
        await firestoreHelper.getUser(firestoreHelper.auth.currentUser!.uid);

    if (currentUser.favory != null &&
        currentUser.favory!
            .contains(widget.musicList[widget.currentMusicIndex].uid)) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.musicList.isNotEmpty
            ? widget.musicList[widget.currentMusicIndex].title
            : ""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            audioPlayer.stop();
            setState(() {
              widget.musicList.clear();
            });
            List<MyMusic> myMusicList = [];
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              widget.musicList[widget.currentMusicIndex].image ??
                  defaultImage ??
                  " ",
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50),
            Text(
              widget.musicList[widget.currentMusicIndex].artist,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.musicList[widget.currentMusicIndex].title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            IconButton(
              icon: Icon(Icons.info),
              color: Colors.blue,
              iconSize: 30.0,
              onPressed: () async {
                String bio = await fetchArtistBio(
                    widget.musicList[widget.currentMusicIndex].artist);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Information sur l\'artiste'),
                      content: Text(
                          'Nom de l\'artiste: ${widget.musicList[widget.currentMusicIndex].artist}\n\nBio: $bio'),
                      actions: [
                        TextButton(
                          child: Text('Fermer'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 64.0,
                  onPressed: previousTrack,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: togglePlay,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 64.0,
                  onPressed: nextTrack,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: dureeTotalMusic.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  position = Duration(seconds: value.toInt());
                  audioPlayer.seek(position);
                });
              },
            ),
            Animate(
              effects: [ _shakeEffect, _scaleEffect, _scaleEffect2 ],
              autoPlay: false,
              target: isFavorite ? 1 : 0,
              child: IconButton(
                icon: FaIcon(
                  (isFavorite) ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                    addToFavorite();
                  });
                },
            )
          ),
          ],
        ),
      ),
    );
  }
}
