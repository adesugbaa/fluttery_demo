import 'package:flutter/material.dart';



class Screen {
  final Key key;
  final String title;
  final DecorationImage background;
  final ScreenBuilder contentBuilder;

  Screen({
    this.key,
    this.title,
    this.background,
    this.contentBuilder,
  });
}

typedef Widget ScreenBuilder(BuildContext context, AnimationController controller, Function toggle);
