import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spritewidget/spritewidget.dart';



ImageMap _images;
SpriteSheet _sprites;


class WeatherWorld extends NodeWithSize {
  RainNode _rain;

  WeatherWorld() : super(Size(2048.0, 2048.0)) {
    _rain = RainNode();
    _rain.active = true;

    addChild(_rain);
  }
}


class RainNode extends Node {
  List<ParticleSystem> _particles = [];

  RainNode() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  void _addParticles(double distance) {
    ParticleSystem particles = ParticleSystem(
      _sprites['raindrop.png'],
      transferMode: BlendMode.lighten,
      posVar: Offset(1300.0, 0.0),
      direction: 90.0,
      directionVar: 0.0,
      speed: 10000.0 / distance,
      speedVar: 100.0 / distance,
      startSize: 1.2 / distance,
      startSizeVar: 0.2 / distance,
      endSize: 1.2 / distance,
      endSizeVar: 0.2 / distance,
      life: 1.5 * distance,
      lifeVar: 1.0 * distance,
      maxParticles: 15,
    );

    particles.position = Offset(1024.0, -200.0);
    particles.rotation = 0.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    actions.stopAll();

    for (ParticleSystem system in _particles) {
      if (active) {
        actions.run(
          ActionTween<double>(
            (value) => system.opacity = value,
            system.opacity,
            1.0,
            2.0
          ),
        );
      } else {
        actions.run(
          ActionTween<double>(
            (value) => system.opacity = value,
            system.opacity,
            0.0,
            0.5
          ),
        );
      }
    }
  }
}


class Rain extends StatefulWidget {

  @override
  RainState createState() => RainState();
}

class RainState extends State<Rain> {

  bool _assetsLoaded = false;
  WeatherWorld weatherWorld;

  @override
  void initState() {
    super.initState();

    AssetBundle bundle = rootBundle;
    _loadAssets(bundle).then((nothing) {
      setState(() {
        _assetsLoaded = true;
        weatherWorld = WeatherWorld();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<Null> _loadAssets(AssetBundle bundle) async {
    _images = ImageMap(bundle);

    await _images.load([
      'assets/images/weather/weathersprites.png'
    ]);

    String json = await DefaultAssetBundle.of(context).loadString('assets/images/weather/weathersprites.json');
    _sprites = SpriteSheet(_images['assets/images/weather/weathersprites.png'], json);
  }


  @override
  Widget build(BuildContext context) {
    return _assetsLoaded 
      ? SpriteWidget(weatherWorld)
      : Container();
  }
}