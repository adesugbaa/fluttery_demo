import 'package:flutter/material.dart';



class WeekDrawer extends StatelessWidget {
  final List<String> week;
  final Function(int index) onDaySelected;
  final Function onRefreshed;

  WeekDrawer({
    @required this.week,
    @required this.onDaySelected,
    @required this.onRefreshed
  });

  List<Widget> _buildDayButtons() {
    return week.map((String day) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onDaySelected(week.indexOf(day)),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125.0,
      height: double.infinity,
      color: const Color(0xAA234060),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ]
          ..addAll(_buildDayButtons())
        ),
      ),
    );
  }
}