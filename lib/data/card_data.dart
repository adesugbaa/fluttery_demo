import 'package:fluttery_demo/models/card_view_model.dart';



final List<CardViewModel> demoCards = [
  CardViewModel(
    backdropAssetPath: 'assets/images/carousel/van_on_beach.jpg',
    address: '10TH STREET',
    minHeightInFeet: 2,
    maxHeightInFeet: 3,
    tempInDegrees: 65.1,
    weatherType: "Mostly Cloudy",
    windSpeedInMph: 11.2,
    cardinalDirection: "ENE",
  ),
  CardViewModel(
    backdropAssetPath: 'assets/images/carousel/dusk_waves.jpg',
    address: '10TH STREET NORTH\nTO 14TH STREET NO...',
    minHeightInFeet: 6,
    maxHeightInFeet: 7,
    tempInDegrees: 54.5,
    weatherType: "Rain",
    windSpeedInMph: 20.5,
    cardinalDirection: "E",
  ),
  CardViewModel(
    backdropAssetPath: 'assets/images/carousel/board_walk.jpg',
    address: 'BELLS BEACH',
    minHeightInFeet: 3,
    maxHeightInFeet: 4,
    tempInDegrees: 61.0,
    weatherType: "Sunny",
    windSpeedInMph: 19.9,
    cardinalDirection: "W",
  ),
];