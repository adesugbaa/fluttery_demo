import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/card_view_model.dart';



class CarouselCard extends StatelessWidget {
  final CardViewModel viewModel;
  final double parallaxPercent;

  CarouselCard({
    this.viewModel,
    this.parallaxPercent
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FractionalTranslation(
            translation: Offset(parallaxPercent * 2.0, 0.0),
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Image.asset(
                viewModel.backdropAssetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Text(
                viewModel.address.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'petita',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0
                ),
              ),
            ),

            Expanded(child: Container()),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, top: 30.0),
                  child: Text(
                    'FT',
                    style: TextStyle(
                      color: Colors.transparent,
                      fontFamily: 'petita',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  '${viewModel.minHeightInFeet} - ${viewModel.maxHeightInFeet}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'petita',
                    fontSize: 140.0,
                    letterSpacing: -5.0
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                  child: Text(
                    'FT',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'petita',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${viewModel.tempInDegrees}º',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'petita',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                )
              ]
            ),

            Expanded(child: Container()),

            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5
                  ),
                  color: Colors.black.withOpacity(0.3)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        viewModel.weatherType,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        )
                      ),

                      Text(
                        '${viewModel.windSpeedInMph} ${viewModel.cardinalDirection}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        )
                      ),
                    ]
                  ),
                ),
              ),
            )
          ]
        )
      ]
    );
  }
}