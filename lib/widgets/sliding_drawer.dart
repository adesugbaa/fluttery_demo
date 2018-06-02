import 'package:flutter/material.dart';
import 'package:fluttery_demo/widgets/openable_controller.dart';



class SlidingDrawer extends StatelessWidget {

  final Widget drawer;
  final OpenableController openableController;

  SlidingDrawer({
    @required this.drawer,
    @required this.openableController
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: openableController.isOpen()
            ? openableController.close
            : null,
        ),

        FractionalTranslation(
          translation: Offset(1.0 - openableController.percentOpen, 0.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: drawer
          ),
        ),
      ],
    );
  }
}