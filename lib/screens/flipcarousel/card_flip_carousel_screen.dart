import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:fluttery_demo/data/card_data.dart';
import 'package:fluttery_demo/models/card_view_model.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/ui/app_bar.dart';
import 'package:fluttery_demo/screens/flipcarousel/ui/carousel_card.dart';



class CardFlipper extends StatefulWidget {
  final List<CardViewModel> cards;
  final AnimationController controller;
  final Function onMenuTapped;
  final Function(double scrollPercent) onScroll;

  CardFlipper({
    @required this.cards,
    @required this.controller,
    @required this.onMenuTapped,
    @required this.onScroll
  });

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin {
  
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();

    finishScrollController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
    ..addListener(() {
      setState(() {
        scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);

        if (widget.onScroll != null) {
          widget.onScroll(scrollPercent);
        }
      });
    })
    ..addStatusListener((AnimationStatus status) {});
  }

  @override
  void dispose() {
    super.dispose();

    finishScrollController.dispose();
  }
  
  Matrix4 _buildCardProjection(double scrollPercent) {
    // Pre-multiplied matrix of a projection matrix and a view matrix.
    //
    // Projection matrix is a simplified perspective matrix
    // http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
    // in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, 0.0],
    //  [0.0, 0.0, -perspective, 1.0]]
    //
    // View matrix is a simplified camera view matrix.
    // Basically re-scales to keep object at original size at angle = 0 at
    // any radius in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, -radius],
    //  [0.0, 0.0, 0.0, 1.0]]
    final perspective = 0.002;
    final radius = 1.0;
    final angle = scrollPercent * pi / 8;
    final horizontalTranslation = 0.0;
    Matrix4 projection = Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1.0);

    // Model matrix by first translating the object from the origin of the world
    // by radius in the z axis and then rotating against the world.
    final rotationPointMultiplier = angle > 0.0 ? angle / angle.abs() : 1.0;
    // print('Angle: $angle');
    projection *= Matrix4.translationValues(
      horizontalTranslation + (rotationPointMultiplier * 300.0), 0.0, 0.0) *
        Matrix4.rotationY(angle) *
        Matrix4.translationValues(0.0, 0.0, radius) *
        Matrix4.translationValues(-rotationPointMultiplier * 300.0, 0.0, 0.0);

    return projection;
  }

  Widget _buildCard(CardViewModel vm, int cardIndex, int cardCount, double scrollPercent) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / cardCount);

    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Transform(
          transform: _buildCardProjection(cardScrollPercent - cardIndex),
          child: CarouselCard(
            viewModel: vm,
            parallaxPercent: parallax
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    final numCards = widget.cards.length;
    int index = -1;

    return widget.cards.map((CardViewModel vm) {

      return _buildCard(vm, ++index, numCards, scrollPercent);
    }).toList();
  }

  void _onPanStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;
    final numCards = widget.cards.length;

    setState(() {
      scrollPercent = (startDragPercentScroll + (-singleCardDragPercent / numCards)).clamp(0.0, 1.0 - (1 / numCards));

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final numCards = widget.cards.length;
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * numCards).round() / numCards;
    finishScrollController.forward(from: 0.0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack( 
        children: _buildCards()
        ..add(
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: MainAppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              controller: widget.controller,
              title: '',
              onMenuTapped: widget.onMenuTapped,
              // leading: IconButton(
              //   onPressed: widget.onMenuTapped,
              //   icon: AnimatedIcon(
              //     icon: AnimatedIcons.close_menu,
              //     progress: widget.controller.view
              //   ),
              // ),
            ),
          )
        ),
        
      ),
    );
  }
}


class ScrollIndicatorPainter extends CustomPainter {
  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.cardCount,
    this.scrollPercent
  }) : 
  trackPaint = Paint()
    ..color = const Color(0xFF444444)
    ..style = PaintingStyle.fill,
  thumbPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Track
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0)
      ), 
      trackPaint
    );

    // Draw Thumb
    final thumbWidth = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(thumbLeft, 0.0, thumbWidth, size.height),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0)
      ), 
      thumbPaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}


class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  ScrollIndicator({
    this.cardCount,
    this.scrollPercent
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
        cardCount: cardCount,
        scrollPercent: scrollPercent
      ),
    );
  }
}


class BottomBar extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  BottomBar({
    this.cardCount,
    this.scrollPercent
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              height: 5.0,
              child: ScrollIndicator(
                cardCount: cardCount,
                scrollPercent: scrollPercent
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ]
      ),
    );
  }
}


class CardFlipCarousel extends StatefulWidget {
  final AnimationController controller;
  final Function toggleMenu;

  CardFlipCarousel({
    this.controller,
    this.toggleMenu
  });

  @override
  _CardFlipCarouselState createState() => _CardFlipCarouselState();
}

class _CardFlipCarouselState extends State<CardFlipCarousel> {
  double scrollPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CardFlipper(
                  cards: demoCards,
                  controller: widget.controller,
                  onMenuTapped: widget.toggleMenu,
                  onScroll: (double scrollPercent) {
                    setState(() {
                      this.scrollPercent = scrollPercent;
                    });
                  }
                ),
              ),
              
              BottomBar(
                cardCount: demoCards.length,
                scrollPercent: scrollPercent,
              )
            ]
          ),
        ),
      ),
    );
  }
}


final Screen cardFlipCarouselScreen = Screen(
  title: null,
  contentBuilder: (BuildContext context, AnimationController controller, Function toggle) {
    return CardFlipCarousel(
      controller: controller,
      toggleMenu: toggle
    );
  }
);