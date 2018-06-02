import 'package:flutter/material.dart';



enum OpenableState {
  closed,
  opening,
  open,
  closing
}


class OpenableController extends ChangeNotifier {
  OpenableState _state = OpenableState.closed;
  AnimationController _controller;

  OpenableController({
    @required TickerProvider vsync,
    @required Duration openDuration
  }) :
  _controller = AnimationController(duration: openDuration, vsync: vsync) {
    _controller
      ..addListener(notifyListeners)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = OpenableState.opening;
            break;

          case AnimationStatus.completed:
            _state = OpenableState.open;
            break;

          case AnimationStatus.reverse:
            _state = OpenableState.closing;
            break;

          case AnimationStatus.dismissed:
            _state = OpenableState.closed;
            break;
        }

        notifyListeners();
      });
  }

  get state => _state;

  get percentOpen => _controller.value;

  bool isOpen() {
    return _state == OpenableState.open;
  }

  bool isOpening() {
    return _state == OpenableState.opening;
  }

  bool isClosed() {
    return _state == OpenableState.closed;
  }

  bool isClosing() {
    return _state == OpenableState.closing;
  }

  void open() {
    _controller.forward();
  }

  void close() {
    _controller.reverse();
  }

  void toggle() {
    if (isClosed()) {
      open();
    } else if (isOpen()) {
      close();
    }
  }
}