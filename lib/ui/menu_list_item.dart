import 'package:flutter/material.dart';



class MenuListItem extends StatelessWidget {

  final String title;
  final bool isSelected;
  final Function() onTap;

  MenuListItem({
    this.title,
    this.isSelected,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected
        ? null
        : onTap,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontFamily: 'bebas-neue',
              fontSize: 25.0,
              letterSpacing: 2.0
            ),
          ),
        ),
      ),
    );
  }
}