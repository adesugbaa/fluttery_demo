import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/radial_list.dart';
import 'package:fluttery_demo/screens/weather/ui/background_with_rings.dart';
import 'package:fluttery_demo/screens/weather/ui/radial_list.dart';
import 'package:fluttery_demo/screens/weather/ui/rain.dart';



class Forecast extends StatelessWidget {

  final RadialListViewModel radialList;
  final SlidingRadialListController slidingListController;

  Forecast({
    @required this.radialList,
    @required this.slidingListController
  });

  Widget _temperatureText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 150.0, left: 10.0),
        child: Text(
          '68°',
          style: TextStyle(
            color: Colors.white,
            fontSize: 80.0,
            fontWeight: FontWeight.w100
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundWithRings(),

        _temperatureText(),

        SlidingRadialList(
          radialList: radialList,
          controller: slidingListController,
        ),

        Rain()
      ]
    );
  }
}