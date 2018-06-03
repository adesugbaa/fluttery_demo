import 'dart:async';

class EggTimer {

  final Duration maxTime;
  final Function onTimerUpdate;
  final Stopwatch stopwatch = Stopwatch();
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);
  EggTimerState state = EggTimerState.ready;
  Timer mainTimer;

  EggTimer({
    this.maxTime,
    this.onTimerUpdate,
  });

  get currentTime {
    return _currentTime;
  }

  set currentTime(newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
      lastStartTime = currentTime;
    }
  }

  dispose() {
    print('[EggTimer] dispose');

    if (mainTimer != null) {
      mainTimer.cancel();
    }

    lastStartTime = const Duration(seconds: 0);
    _currentTime = const Duration(seconds: 0);
    stopwatch.stop();
  }

  resume() {
    if (state != EggTimerState.running) {
      if (state == EggTimerState.ready) {
        _currentTime = _roundToTheNearestMinute(_currentTime);
        lastStartTime = _currentTime;
      }

      state = EggTimerState.running;
      stopwatch.start();

      if (mainTimer != null) {
        mainTimer.cancel();
      }

      _tick();
    }
  }

  _roundToTheNearestMinute(duration) {
    return Duration(
      minutes: (duration.inSeconds / 60).round()
    );
  }

  pause() {
    if (state == EggTimerState.running) {
      state = EggTimerState.paused;
      stopwatch.stop();
    }
  }

  restart() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.running;
      _currentTime = lastStartTime;
      stopwatch.reset();
      stopwatch.start();

      if (mainTimer != null) {
        mainTimer.cancel();
      }

      _tick();
    }
  }

  reset() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.ready;
      _currentTime = const Duration(seconds: 0);
      lastStartTime = _currentTime;
      stopwatch.reset();

      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  _update(Timer t) {
    _currentTime = lastStartTime - stopwatch.elapsed;

    if (_currentTime != null && _currentTime.inSeconds > 0) {
      if (state != EggTimerState.running) {
        print('Canceling Timer');
        t.cancel();
      } else {
        print('Current time: ${_currentTime.inSeconds}');
      }
    } else {
      t.cancel();
      state = EggTimerState.ready;
    }

    if (null != onTimerUpdate && state == EggTimerState.running) {
      onTimerUpdate();
    }
  }

  _tick() {
    mainTimer = Timer.periodic(const Duration(seconds: 1), _update);

    if (null != onTimerUpdate && state == EggTimerState.running) {
      _currentTime = lastStartTime - stopwatch.elapsed;
      //print('Current time: ${_currentTime.inSeconds}');
      onTimerUpdate();
    }
  }
}

enum EggTimerState {
  ready,
  running,
  paused,
}