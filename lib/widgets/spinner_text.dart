import 'package:flutter/material.dart';



class RectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}


class SpinnerText extends StatefulWidget {

  final String text;

  SpinnerText({
    this.text = '',
  });

  @override
  _SpinnerTextState createState() => _SpinnerTextState();
}

class _SpinnerTextState extends State<SpinnerText> with TickerProviderStateMixin {

  String topText = '';
  String bottomText = '';

  AnimationController _spinController;
  Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();

    bottomText = widget.text;

    _spinController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this
    )
    ..addListener(() => setState(() {}))
    ..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          bottomText = topText;
          topText = '';
          _spinController.value = 0.0;
        });
      }
    });

    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.elasticInOut
    );
  }

  @override
  void didUpdateWidget(SpinnerText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      topText = widget.text;
      _spinController.forward();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: RectClipper(),
      child: Stack(
        children: [
          FractionalTranslation(
            translation: Offset(0.0, _spinAnimation.value - 1.0),
            child: Text(
              topText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0
              ),
            ),
          ),

          FractionalTranslation(
            translation: Offset(0.0, _spinAnimation.value),
              child: Text(
              bottomText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0
              ),
            ),
          )
        ]
      ),
    );
  }
}