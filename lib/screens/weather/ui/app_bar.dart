import 'package:flutter/material.dart';
import 'package:fluttery_demo/widgets/spinner_text.dart';



class ForecastAppBar extends StatefulWidget {

  final String day;
  final String city;
  final AnimationController controller;
  final Function onMenuTapped;
  final Function onOpenDrawerTapped;

  ForecastAppBar({
    @required this.day,
    @required this.city,
    @required this.controller,
    @required this.onMenuTapped,
    this.onOpenDrawerTapped
  });
  
  @override
  ForecastAppBarState createState() => ForecastAppBarState();
}

class ForecastAppBarState extends State<ForecastAppBar> {

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
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        onPressed: widget.onMenuTapped,
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: widget.controller
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpinnerText(
            text: widget.day
          ),

          Text(
            widget.city,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0
            ),
          )
        ]
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 35.0
          ),
          onPressed: () {
            widget.onOpenDrawerTapped();
          },
        )
      ]
    );
  }
}