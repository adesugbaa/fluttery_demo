import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/screens/weather/forecast_list.dart';
import 'package:fluttery_demo/screens/weather/ui/app_bar.dart';
import 'package:fluttery_demo/screens/weather/ui/forecast.dart';
import 'package:fluttery_demo/screens/weather/ui/radial_list.dart';
import 'package:fluttery_demo/screens/weather/ui/week_drawer.dart';
import 'package:fluttery_demo/widgets/openable_controller.dart';
import 'package:fluttery_demo/widgets/sliding_drawer.dart';



class WeatherScreen extends StatefulWidget {

  final Function toggleMenu;
  final AnimationController controller;

  WeatherScreen({
    this.controller,
    this.toggleMenu
  });

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with TickerProviderStateMixin {

  final week = [
    'Monday\nAugust 26',
    'Tuesday\nAugust 27',
    'Wednesday\nAugust 28',
    'Thursday\nAugust 29',
    'Friday\nAugust 30',
    'Saturday\nAugust 31',
    'Sunday\nSeptember 01'
  ];

  OpenableController openableController;
  SlidingRadialListController slidingRadialListController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    openableController = OpenableController(
      openDuration: const Duration(milliseconds: 250),
      vsync: this
    )
    ..addListener(() => setState(() {}));

    slidingRadialListController = SlidingRadialListController(
      itemCount: forecastRadialList.items.length,
      vsync: this
    )
    ..addListener(() => setState(() {}))
    ..open();
  }

  @override
  void dispose() {
    openableController.dispose();
    slidingRadialListController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Forecast(
            radialList: forecastRadialList,
            slidingListController: slidingRadialListController,
          ),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: ForecastAppBar(
              day: week[currentIndex].replaceFirst('\n', ', '),
              city: 'Bowie, MD',
              controller: widget.controller,
              onMenuTapped: widget.toggleMenu,
              onOpenDrawerTapped: openableController.open
            ),
          ),

          SlidingDrawer(
            openableController: openableController,
            drawer: WeekDrawer(
              week: week,
              onRefreshed: () {},
              onDaySelected: (index) {
                setState(() {
                  currentIndex = index;
                });

                slidingRadialListController
                  .close()
                  .then((nothing) => slidingRadialListController.open());

                openableController.close();
              },
            ),
          )
        ]
      ),
    );
  }
}


final Screen weatherScreen = Screen(

  contentBuilder: (BuildContext context, AnimationController controller, Function toggle) {
    return WeatherScreen(
      controller: controller,
      toggleMenu: toggle
    );
  }
);