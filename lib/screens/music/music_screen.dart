import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/demo_song.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/screens/music/songs.dart';
import 'package:fluttery_demo/screens/music/ui/audio_radial_seekbar.dart';
import 'package:fluttery_demo/screens/music/ui/bottom_controls.dart';
import 'package:fluttery_demo/ui/app_bar.dart';
import 'package:fluttery_audio/fluttery_audio.dart';



class MusicScreen extends StatefulWidget {

  final AnimationController controller;
  final Function toggleMenu;

  MusicScreen({
    this.controller,
    this.toggleMenu
  });

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            color: Colors.black,
            onPressed: widget.toggleMenu,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: widget.controller.view
            ),
          ),
          title: Text(''),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.music_note,
              ),
              color: const Color(0xFFDDDDDD),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: AudioPlaylistComponent(
                playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
                  String albumArtUrl = demoPlaylist.songs[playlist.activeIndex].albumArtUrl;

                  return AudioRadialSeekBar(
                    albumArtUrl: albumArtUrl,
                  );
                },
              ),
            ),

            BottomControls()
          ]
        ),
      ),
    );
  }
}

final Screen musicScreen = Screen(
  title: null,
  contentBuilder: (BuildContext context, Animation controller, Function toggle) {
    return MusicScreen(
      controller: controller,
      toggleMenu: toggle
    );
  }
);