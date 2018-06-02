import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttery_demo/app_root.dart';
import 'package:fluttery_demo/models/page_indicator_view_model.dart';
import 'package:fluttery_demo/screens/reveal/enums.dart';
import 'package:fluttery_demo/screens/reveal/pages.dart';
import 'package:fluttery_demo/screens/reveal/ui/action_button.dart';
import 'package:fluttery_demo/screens/reveal/ui/page.dart';
import 'package:fluttery_demo/screens/reveal/ui/page_dragger.dart';
import 'package:fluttery_demo/screens/reveal/ui/pager_indicator.dart';
import 'package:fluttery_demo/screens/reveal/ui/page_reveal.dart';



class RevealScreen extends StatefulWidget {
  final Function onDismissed;

  RevealScreen({
    this.onDismissed
  });

  @override
  _RevealScreenState createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  double slidePercent = 0.0;
  SlideDirection slideDirection = SlideDirection.none;

  _RevealScreenState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          //('Sliding ${event.direction} at ${event.slidePercent}');
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();

        } else if (event.updateType == UpdateType.animating) {
          // print('Sliding ${event.direction} at ${event.slidePercent}');
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

        } else if (event.updateType == UpdateType.doneAnimating) {
          // print('Done animating. Next page index: $nextPageIndex');
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });
  }

  void _openApp() {
    Navigator
      .of(context)
      .pushReplacement(PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (BuildContext context, _, __) {
          return AppRoot();
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }
      ));

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (ctx) => AppRoot())
    // );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0,
          ),

          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),

          PagerIndicator(
            viewModel: PagerIndicatorViewModel(
              pages,
              activeIndex,
              slideDirection,
              slidePercent,
            ),
          ),

          PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateStream: this.slideUpdateStream,
          ),

          ActionButton(
            numPages: pages.length,
            activeIndex: activeIndex,
            onTapped: widget.onDismissed
          )
        ]
      ),
    );
  }
}