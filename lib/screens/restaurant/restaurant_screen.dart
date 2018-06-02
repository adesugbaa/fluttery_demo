import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/screens/restaurant/ui/restaurant_card.dart';



class RestaurantScreen extends StatefulWidget {

  final AnimationController controller;
  final Function toggleMenu;

  RestaurantScreen({
    this.controller,
    this.toggleMenu
  });

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/wood_bk.jpg'),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: widget.toggleMenu,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: widget.controller.view
            ),
          ),
          title: Text(
            'THE PALEO PADDOCK',
            style: TextStyle(
              fontFamily: 'bebas-neue',
              fontSize: 25.0
            ),
          ),
        ),
        body: ListView(
          children: [
            RestaurantCard(
              headImageAssetPath: 'assets/images/eggs_in_skillet.jpg',
              icon: Icons.fastfood,
              iconBackgroundColor: Colors.red,
              title: 'il domacca',
              subtitle: '78 5TH AVENUE, NEW YORK',
              heartCount: 84,

            ),
            RestaurantCard(
              headImageAssetPath: 'assets/images/steak_on_cooktop.jpg',
              icon: Icons.restaurant,
              iconBackgroundColor: Colors.orange,
              title: 'Mc Grady',
              subtitle: '79 105TH AVENUE, NEW YORK',
              heartCount: 54,
            ),
            RestaurantCard(
              headImageAssetPath: 'assets/images/spoons_of_spices.jpg',
              icon: Icons.local_dining,
              iconBackgroundColor: Colors.purpleAccent,
              title: 'Sugar & Spice',
              subtitle: '1102 15TH AVENUE, NEW YORK',
              heartCount: 113,
            ),
          ]
        ),
      ),
    );
  }
}
final Screen restaurantScreen = Screen(
  title: 'THE PALEO PADDOCK',
  background: DecorationImage(
    image: AssetImage('assets/images/wood_bk.jpg'),
    fit: BoxFit.cover
  ),
  contentBuilder: (BuildContext context, AnimationController controller, Function toggle) {
    return RestaurantScreen(
      controller: controller,
      toggleMenu: toggle,
    );// 
  }
);