import 'package:flutter/material.dart';



class MainContent extends StatelessWidget {
  final Function onMenuPressed;
  final Widget child;

  MainContent({
    this.child,
    this.onMenuPressed
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}