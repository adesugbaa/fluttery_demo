import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class AboutScreen extends StatefulWidget {

  final AnimationController controller;
  final Function toggleMenu;

  AboutScreen({
    this.controller,
    this.toggleMenu
  });

  @override
  AboutScreenState createState() {
    return AboutScreenState();
  }
}

class AboutScreenState extends State<AboutScreen> {

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<Null> _launched;

  Future<Null> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _confirm() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SUCCESS'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All applications settings have been reset.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text(
          'ABOUT',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'bebas-neue',
            fontSize: 25.0
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'This application combines all the beautiful UI challenges by the awesome developer Matthew Carroll (Fluttery).',
                      style: TextStyle(
                        fontFamily: 'bebas-neue',
                        fontSize: 24.0,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Please visit his youtube channel for Flutter tutorials.',
                      style: TextStyle(
                          fontFamily: 'bebas-neue',
                          fontSize: 24.0,
                        )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.green)
                      ),
                      child: FlatButton(
                        child: Text('Visit Fluttery\'s YouTube Page') ,
                        onPressed: () => setState(() {
                          _launched = _launchInWebViewOrVC('https://www.youtube.com/channel/UCtWyVkPpb8An90SNDTNF0Pg');
                        }),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.green)
                      ),
                      child: FlatButton(
                        child: Text('Visit Fluttery\'s GitHub Page') ,
                        onPressed: () => setState(() {
                          _launched = _launchInWebViewOrVC('https://github.com/matthew-carroll');
                        }),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 44.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.green)
                      ),
                      child: FlatButton(
                        child: Text('Try Flutter') ,
                        onPressed: () => setState(() {
                          _launched = _launchInWebViewOrVC('https://flutter.io');
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.red)
                ),
                child: FlatButton(
                  child: Text(
                    'RESET APPLICATION',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                    ),
                  ) ,
                  onPressed: () async {
                    final SharedPreferences prefs = await _prefs;
                    await prefs.setBool('SEEN_REVEAL', false);
                    await prefs.setBool('SEEN_DISCOVERY', false);
                    await _confirm();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


final Screen aboutScreen = Screen(
  title: null,
  contentBuilder: (BuildContext context, AnimationController controller, Function toggle) {
    return AboutScreen(
      controller: controller,
      toggleMenu: toggle
    );
  }
);