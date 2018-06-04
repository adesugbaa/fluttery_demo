import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/screens/timer/egg_timer.dart';
import 'package:fluttery_demo/screens/timer/ui/egg_timer_controls.dart';
import 'package:fluttery_demo/screens/timer/ui/egg_timer_dial.dart';
import 'package:fluttery_demo/screens/timer/ui/egg_timer_time_display.dart';
import 'package:fluttery_demo/ui/app_bar.dart';



const Color GRADIENT_TOP = const Color(0xFFF5F5F5);
const Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerScreen extends StatefulWidget {

  final AnimationController controller;
  final Function toggleMenu;

  EggTimerScreen({
    this.controller,
    this.toggleMenu
  });

  @override
  _EggTimerScreenState createState() => _EggTimerScreenState();
}

class _EggTimerScreenState extends State<EggTimerScreen> {

  EggTimer eggTimer;

  _EggTimerScreenState() {
    eggTimer = EggTimer(
      maxTime: const Duration(minutes: 35),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  @override
  void dispose() {
    // print('[ScreenTimer] dispose');
    // eggTimer.pause();
    eggTimer.dispose();
    // eggTimer = null;

    super.dispose();
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  _onTimerUpdate() {
    
    if (this.mounted) {
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  EggTimerTimeDisplay(
                    eggTimerState: eggTimer.state,
                    selectionTime: eggTimer.lastStartTime,
                    countdownTime: eggTimer.currentTime,
                  ),

                  EggTimerDial(
                    eggTimerState: eggTimer.state,
                    currentTime: eggTimer.currentTime,
                    maxTime: eggTimer.maxTime,
                    ticksPerSection: 5,
                    onTimeSelected: _onTimeSelected,
                    onDialStopTurning: _onDialStopTurning,
                  ),

                  Expanded(child: Container()),

                  EggTimerControls(
                    eggTimerState: eggTimer.state,
                    onPause: () {
                      setState(() => eggTimer.pause());
                    },
                    onResume: () {
                      setState(() => eggTimer.resume());
                    },
                    onRestart: () {
                      setState(() => eggTimer.restart());
                    },
                    onReset: () {
                      setState(() => eggTimer.reset());
                    },
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: MainAppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              iconColor: Colors.black,
              controller: widget.controller,
              title: '',
              onMenuTapped: widget.toggleMenu,
            ),
          ),
        ]
      ),
    );
  }
}


final Screen timerScreen = Screen(
  title: null,
  contentBuilder: (BuildContext context, AnimationController controller, Function toggle) {
    return EggTimerScreen(
      controller: controller,
      toggleMenu: toggle
    );
  }
);