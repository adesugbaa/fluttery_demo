import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  final int numPages;
  final int activeIndex;
  final Function onTapped;

  ActionButton({
    @required this.numPages,
    @required this.activeIndex,
    @required this.onTapped
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 44.0,
      right: 16.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white)
        ),
        child: FlatButton(
          onPressed: onTapped,
          //color: Colors.white,
          child: Text(
            activeIndex == (numPages - 1) ? 'PROCEED' : 'SKIP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}