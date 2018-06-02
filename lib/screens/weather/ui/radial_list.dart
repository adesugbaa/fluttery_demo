import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/radial_list.dart';
import 'package:fluttery_demo/models/radial_list_item.dart';
import 'package:fluttery_demo/widgets/radial_position.dart';



enum RadialListState {
  closed,
  slidingOpen,
  open,
  fadingOut
}


class SlidingRadialListController extends ChangeNotifier {

  final double _firstItemAngle = -pi / 3;
  final double _lastItemAngle = pi / 3;
  final double startSlidingAngle = 3 * pi / 4;

  final int itemCount;
  final AnimationController _slideController;
  final AnimationController _fadeController;
  final List<Animation<double>> _slidePositions;

  RadialListState _state = RadialListState.closed;
  Completer<Null> _onOpenedCompleter;
  Completer<Null> _onClosedCompleter;

  SlidingRadialListController({
    this.itemCount,
    vsync
  }) : 
  _slidePositions = [],
  _slideController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: vsync
  ),
  _fadeController = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: vsync
  ) {

    _slideController
      ..addListener(notifyListeners)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = RadialListState.slidingOpen;
            notifyListeners();
            break;

          case AnimationStatus.completed:
            _state = RadialListState.open;
            notifyListeners();
            _onOpenedCompleter.complete();
            break;

          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    _fadeController
      ..addListener(notifyListeners)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = RadialListState.fadingOut;
            notifyListeners();
            break;

          case AnimationStatus.completed:
            _state = RadialListState.closed;

            // reset
            _slideController.value = 0.0;
            _fadeController.value = 0.0;

            notifyListeners();
            _onClosedCompleter.complete();
            break;

          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    final delayInterval = 0.1;
    final slideInterval = 0.5;
    final angleDeltaPerItem = (_lastItemAngle - _firstItemAngle) / (itemCount - 1);
      
    for (var i = 0; i < itemCount; ++i) {
      final start = delayInterval * i;
      final end = start + slideInterval;

      final endSlidePosition = _firstItemAngle + (angleDeltaPerItem * i);

      _slidePositions.add(
        Tween(
          begin: startSlidingAngle,
          end: endSlidePosition,
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Interval(start, end, curve: Curves.easeInOut)
          )
        )
      );
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();

    super.dispose();
  }

  double getItemAngle(int index) {
    return _slidePositions[index].value;
  }

  double getItemOpacity(int index) {
    switch(_state) {
      case RadialListState.closed:
        return 0.0;
      case RadialListState.slidingOpen:
      case RadialListState.open:
        return 1.0;
      case RadialListState.fadingOut:
        return (1.0 - _fadeController.value);
      default:
        return 1.0;
    }
  }

  Future<Null> open() {
    if (_state == RadialListState.closed) {
      _slideController.forward();
      _onOpenedCompleter = Completer();

      return _onOpenedCompleter.future;
    }

    return null;
  }

  Future<Null> close () {
    if (_state == RadialListState.open) {
      _fadeController.forward();
      _onClosedCompleter = Completer();

      return _onClosedCompleter.future;
    }

    return null;
  }
}


class RadialListItem extends StatelessWidget {

  final RadialListItemViewModel listItem;

  RadialListItem({
    this.listItem
  });

  @override
  Widget build(BuildContext context) {

    final circleDecoration = listItem.isSelected
      ? BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        )
      : BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        );

    return Transform(
      transform: Matrix4.translationValues(-30.0, -30.0, 0.0),
      child: Row(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                image: listItem.icon,
                color: listItem.isSelected ? Color(0xFF6688CC) : Colors.white,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  listItem.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0
                  ),
                ),

                Text(
                  listItem.subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0
                  ),
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}


class SlidingRadialList extends StatelessWidget {

  final RadialListViewModel radialList;
  final SlidingRadialListController controller;

  double screenH;

  SlidingRadialList({
    this.radialList,
    this.controller
  });

  Widget _radialListItem(RadialListItemViewModel viewModel, double angle, double opacity) {
    return Transform(
      transform: Matrix4.translationValues(40.0, screenH/2, 0.0),
      child: RadialPosition(
        radius: 140.0 + 75.0,
        angle: angle,
        child: Opacity(
          opacity: opacity,
          child: RadialListItem(
            listItem: viewModel,
          ),
        ),
      ),
    );
  }

  List<Widget> _radialMenuItems() {
    int index = 0;

    return radialList.items.map((RadialListItemViewModel vm) {
      final listItem = _radialListItem(
        vm, 
        controller.getItemAngle(index),
        controller.getItemOpacity(index)
      );
      ++index;
      return listItem;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (screenH == null) {
      screenH = MediaQuery.of(context).size.height;
    }

    // return AnimatedBuilder(
    //   animation: controller,
    //   builder: (BuildContext context, Widget child) {
    //     return Stack(
    //       children: _radialListItems(screenH),
    //     );
    //   },
    // );
    
    return Stack(
      children: _radialMenuItems(),
    );
  }
}