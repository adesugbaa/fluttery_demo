import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';



enum MenuState {
  closed,
  opening,
  open,
  closing
}


class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _controller;
  MenuState state = MenuState.closed;
  
  MenuController({
    this.vsync,
  }): _controller = AnimationController(vsync: vsync, debugLabel: 'Test') {
    _controller
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;

          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;

          case AnimationStatus.completed:
            state = MenuState.open;
            break;

          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }

        notifyListeners();
      });
  }

  @override
  dispose() {
    _controller.dispose();

    super.dispose();
  }

  double get percentOpen {
    return _controller.value;
  }

  open() {
    _controller.forward();
  }

  close() {
    _controller.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}


class ZoomScaffold extends StatefulWidget {

  final Screen contentScreen;
  final Widget menuScreen;

  ZoomScaffold({
    this.contentScreen,
    this.menuScreen
  });

  @override
  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold> with TickerProviderStateMixin {

  MenuController _menuController;
  AnimationController _controller;

  Curve scaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    _menuController = MenuController(vsync: this)
      ..addListener(() => setState(() {}));

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      value: 1.0,
      vsync: this,
    ); 
  }

  @override
  void dispose() {
    _menuController.dispose();
    _controller.dispose();
    
    super.dispose();
  }

  bool get _menuOpen {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void toggleMenuVisibility() {
    _controller.fling(velocity: _menuOpen? -2.0 : 2.0);
    _menuController.toggle();
  }

  Widget _createAppBar() {
    if (widget.contentScreen.title == null) {
      return null;
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        onPressed: toggleMenuVisibility,
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: _controller.view
        ),
      ),
      title: Text(
        widget.contentScreen.title,
        style: TextStyle(
          fontFamily: 'bebas-neue',
          fontSize: 25.0
        ),
      ),
    );
  }

  Widget _createContentDisplay() {
    return _zoomAndSlideContent(
      widget.contentScreen.contentBuilder(context, _controller, toggleMenuVisibility),
      // Container(
      //   decoration: BoxDecoration(
      //     color: Colors.black,
      //     image: widget.contentScreen.background
      //   ),
      //   child: Scaffold(
      //     backgroundColor: Colors.transparent,
      //     appBar: _createAppBar(),
      //     body: widget.contentScreen.contentBuilder(context, _controller, _menuController.toggle),
      //   ),
      // )
    );
  }

  _zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (_menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;

      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;

      case MenuState.opening:
        slidePercent = slideOutCurve.transform(_menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(_menuController.percentOpen);
        break;

      case MenuState.closing:
        slidePercent = slideInCurve.transform(_menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(_menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * _menuController.percentOpen;

    return Transform(
      transform: Matrix4
        .translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x44000000),
              offset: const Offset(0.0, 5.0),
              blurRadius: 20.0,
              spreadRadius: 10.0
            ),
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius),
          child: content
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.menuScreen,
        _createContentDisplay()
        // MainContent(
        //   child: _createContentDisplay(),
        //   onMenuPressed: () {
        //     // TODO:
        //   },
        // )
      ]
    );
  }
}


class ZoomScaffoldMenuController extends StatefulWidget {

  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({ this.builder });

  @override
  ZoomScaffoldMenuControllerState createState() => ZoomScaffoldMenuControllerState();
}

class ZoomScaffoldMenuControllerState extends State<ZoomScaffoldMenuController> {
  
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
  
    super.dispose();
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  MenuController getMenuController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(
      TypeMatcher<_ZoomScaffoldState>()
    ) as _ZoomScaffoldState;

    return scaffoldState._menuController;
  }

  Function getToggle(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(
      TypeMatcher<_ZoomScaffoldState>()
    ) as _ZoomScaffoldState;

    return scaffoldState.toggleMenuVisibility;
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      getMenuController(context),
      getToggle(context)
    );
  }
}


typedef Widget ZoomScaffoldBuilder(BuildContext context, MenuController menuController, Function toggle);