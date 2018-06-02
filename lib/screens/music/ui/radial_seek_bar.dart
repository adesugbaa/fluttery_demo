import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery_demo/screens/music/theme.dart';
import 'package:fluttery_demo/screens/music/ui/bottom_controls.dart';
import 'package:fluttery_demo/screens/music/ui/radial_progress_bar.dart';


class RadialSeekBar extends StatefulWidget {

  final double progress;
  final double seekPercent;
  final Function(double) onSeekRequested;
  final Widget child;

  RadialSeekBar({
    this.progress = 0.0,
    this.seekPercent = 0.0,
    this.onSeekRequested,
    this.child,
  });

  @override
  RadialSeekBarState createState() {
    return RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {

  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;


  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);

    setState(() => _currentDragPercent = (_startDragPercent + dragPercent) % 1.0);
  }

  void _onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }

    return RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            child: RadialProgressBar(
              trackColor: const Color(0xFFDDDDDD),
              progressPercent: _progress,
              progressColor: accentColor,
              thumbPosition: thumbPosition,
              thumbColor: lightAccentColor,
              innerPadding: const EdgeInsets.all(10.0),
              child: ClipOval(
                clipper: CircleClipper(),
                child: widget.child,
              ),
            ),
          )
        ),
      ),
    );
  }
}