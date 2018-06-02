import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttery_demo/app_root.dart';
import 'package:fluttery_demo/screens/reveal/reveal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  var seenReveal = prefs.getBool('SEEN_REVEAL') ?? false;

  // set light system 
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); 

  // lock orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MyApp(
      seenReveal: seenReveal
    )
  );
}


class MyApp extends StatelessWidget {
  
  final bool seenReveal;

  MyApp({
    this.seenReveal
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Starter(seenReveal)
    );
  }
}


class Starter extends StatelessWidget {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final bool seenReveal;

  Starter(this.seenReveal);

  void _openApp(context) async {
    print('Open app: $context');
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('SEEN_REVEAL', true);

    Navigator
      .of(context)
      .pushReplacement(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (BuildContext context, _, __) {
          return AppRoot();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }
      ));
  }
  
  @override
  Widget build(BuildContext context) {
    return seenReveal 
      ? AppRoot() 
      : RevealScreen(
        onDismissed: () => _openApp(context),
      );
  }
}



