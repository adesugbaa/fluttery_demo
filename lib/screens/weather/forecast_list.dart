import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/radial_list.dart';
import 'package:fluttery_demo/models/radial_list_item.dart';



final RadialListViewModel forecastRadialList = RadialListViewModel(
  items: [
    RadialListItemViewModel(
      icon: AssetImage('assets/images/weather/ic_rain.png'),
      title: '11:30',
      subtitle: 'Light Rain',
      isSelected: true,
    ),
    RadialListItemViewModel(
      icon: AssetImage('assets/images/weather/ic_rain.png'),
      title: '12:30P',
      subtitle: 'Light Rain',
    ),
    RadialListItemViewModel(
      icon: AssetImage('assets/images/weather/ic_cloudy.png'),
      title: '1:30P',
      subtitle: 'Cloudy',
    ),
    RadialListItemViewModel(
      icon: AssetImage('assets/images/weather/ic_sunny.png'),
      title: '2:30P',
      subtitle: 'Sunny',
    ),
    RadialListItemViewModel(
      icon: AssetImage('assets/images/weather/ic_sunny.png'),
      title: '3:30P',
      subtitle: 'Sunny',
    ),
  ],
);



