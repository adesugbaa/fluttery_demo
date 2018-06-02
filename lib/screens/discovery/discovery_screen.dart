import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/screens/weather/ui/app_bar.dart';
import 'package:fluttery_demo/ui/app_bar.dart';
import 'package:fluttery_demo/widgets/feature_discovery.dart';



final feature1 = "FEATURE_1";
final feature2 = "FEATURE_2";
final feature3 = "FEATURE_3";
final feature4 = "FEATURE_4";


class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.network(
              'https://www.balboaisland.com/wp-content/uploads/Starbucks-Balboa-Island-01.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Starbucks Coffee',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Text(
                      'Coffee Shop',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  child: Text('Do Feature Discovery'),
                  onPressed: () {
                    FeatureDiscovery
                        .discoverFeatures(context, [feature1, feature2, feature3, feature4]);
                  },
                )),
          ],
        ),
        Positioned(
            top: 200.0,
            right: 0.0,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: DescribedFeatureOverlay(
                featureId: feature4,
                icon: Icons.drive_eta,
                color: Colors.blue,
                title: 'Find the fastest route',
                description:
                    'Get car, walking, cycling or public transit directions to this place.',
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  child: Icon(
                    Icons.drive_eta,
                  ),
                  onPressed: () {
                    // TODO:
                  },
                ),
              ),
            )),
      ],
    );
  }
}


class DiscoveryScreen extends StatefulWidget {

  final AnimationController controller;
  final Function toggleMenu;

  DiscoveryScreen({
    this.controller,
    this.toggleMenu
  });

  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {


  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: DescribedFeatureOverlay(
            featureId: feature1,
            icon: Icons.menu,
            color: Colors.green,
            title: 'Just how you want it',
            description: 'Tap the menu icon to switch accounts, change settings & more.',
            child: IconButton(
              icon: Icon(
                Icons.menu,
              ),
              onPressed: widget.toggleMenu
            ),
          ),
          title: Text(''),
          actions: <Widget>[
            DescribedFeatureOverlay(
              featureId: feature2,
              icon: Icons.search,
              color: Colors.green,
              title: 'Search your compounds',
              description: 'Tap the magnifying glass to quickly scan your compounds.',
              child: IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  // TODO:
                },
              ),
            ),
          ],
        ),
        body: Content(),
        floatingActionButton: DescribedFeatureOverlay(
          featureId: feature3,
          icon: Icons.add,
          color: Colors.blue,
          title: 'FAB Feature',
          description: 'This is the FAB and it does stuff.',
          child: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            onPressed: () {
              // TODO:
            },
          ),
        ),
      ),
    );
  }
}


final Screen discoveryScreen = Screen(
  title: null,
  contentBuilder: (BuildContext context, Animation controller, Function toggle) {
    return DiscoveryScreen(
      controller: controller,
      toggleMenu: toggle
    );
  }
);