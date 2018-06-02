import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';



final Screen otherScreen = Screen(
  title: 'OTHER SCREEN',
  background: DecorationImage(
    image: AssetImage('assets/images/other_screen_bk.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(const Color(0xCC000000), BlendMode.multiply)
  ),
  contentBuilder: (BuildContext context, Animation controller, Function toggle) {
    return Container(
      
    );
  }
);