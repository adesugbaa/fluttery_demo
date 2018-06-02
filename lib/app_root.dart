import 'package:flutter/material.dart';

import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/screens/about/about_screen.dart';
import 'package:fluttery_demo/screens/discovery/discovery_screen.dart';
import 'package:fluttery_demo/screens/flipcarousel/card_flip_carousel_screen.dart';
import 'package:fluttery_demo/screens/menu_screen.dart';
import 'package:fluttery_demo/screens/music/music_screen.dart';
import 'package:fluttery_demo/screens/other_screen.dart';
import 'package:fluttery_demo/screens/restaurant/restaurant_screen.dart';
import 'package:fluttery_demo/screens/timer/timer_screen.dart';
import 'package:fluttery_demo/screens/weather/weather_screen.dart';
import 'package:fluttery_demo/ui/zoom_scaffold.dart';



class AppRoot extends StatefulWidget {

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {

  Screen _activeScreen;
  String _selectedMenuId;

  final menu = Menu(
    items: [
      MenuItem(id: 'discovery', title: 'DISCOVERY', screen: discoveryScreen),
      MenuItem(id: 'restaurant', title: 'THE PADDOCK', screen: restaurantScreen),
      MenuItem(id: 'weather', title: 'WEATHER', screen: weatherScreen),
      MenuItem(id: 'music', title: 'MUSIC', screen: musicScreen),
      MenuItem(id: 'flipcards', title: 'FLIP CARDS', screen: cardFlipCarouselScreen),
      MenuItem(id: 'timer', title: 'EGG TIMER', screen: timerScreen),
      MenuItem(id: 'about', title: 'ABOUT', screen: aboutScreen),
    ]
  );

  @override
  void initState() {
    super.initState();

    var startMenu = menu.items[0];
    _activeScreen =  startMenu.screen;
    _selectedMenuId =  startMenu.id;
  }

  void _onMenuSelected(menuId) {
    print('Menu Callback => $menuId clicked');
    MenuItem menuItem = menu.items.firstWhere((item) => item.id == menuId);

    setState(() {
      _activeScreen = menuItem.screen;
      _selectedMenuId = menuItem.id;
    });
  }

  @override
  Widget build(BuildContext context) {

    return ZoomScaffold(
      menuScreen: MenuScreen(
        menu: menu,
        selectedMenuId: _selectedMenuId,
        onMenuSelected: _onMenuSelected
      ),
      contentScreen: _activeScreen,
    );
  }
}

