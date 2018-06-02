import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/page_view_model.dart';



class Page extends StatelessWidget {

  final PageViewModel viewModel;
  final double percentVisible;

  Page({
    this.viewModel,
    this.percentVisible = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: viewModel.color,
      child: SafeArea(
        child: Opacity(
          opacity: percentVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.translationValues(0.0, 50.0 * (1.0 - percentVisible), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 25.0),
                  child: Image.asset(
                    viewModel.heroAssetPath,
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ),

              Transform(
                transform: Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
                  child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                  child: Text(
                    viewModel.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FlamanteRoma',
                      fontSize: 34.0,
                    )
                  ),
                ),
              ),

              Transform(
                transform: Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 75.0),
                  child: Text(
                    viewModel.body,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}