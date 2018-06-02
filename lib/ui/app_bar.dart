import 'package:flutter/material.dart';



class MainAppBar extends StatefulWidget {

  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final double elevation;
  final List<Widget> actions;
  final AnimationController controller;
  final Function onMenuTapped;

  MainAppBar({
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.elevation,
    this.title,
    this.actions,
    this.controller,
    this.onMenuTapped
  });

  @override
  MainAppBarState createState() => MainAppBarState();
}

class MainAppBarState extends State<MainAppBar> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);

    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: widget.backgroundColor,
      elevation: widget.elevation,
      leading: IconButton(
        color: widget.iconColor,
        onPressed: widget.onMenuTapped,
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: widget.controller
        ),
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          fontFamily: 'bebas-neue',
          fontSize: 25.0
        ),
      ),
    );
  }
}