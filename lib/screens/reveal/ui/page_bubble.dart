import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/page_bubble_view_model.dart';



class PageBubble extends StatelessWidget {

  final PageBubbleViewModel viewModel;

  PageBubble({
    this.viewModel
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container (
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
              ? const Color(0x88FFFFFF).withAlpha((0x88 * viewModel.activePercent).round())
              : const Color(0x88FFFFFF),
            border: Border.all(
              color: viewModel.isHollow
                ? const Color(0x88FFFFFF).withAlpha((0x88 * (1.0 - viewModel.activePercent)).round())
                : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: Opacity(
            opacity: viewModel.activePercent,
            child: Image.asset(
              viewModel.iconAssetPath,
              color: viewModel.color,
            ),
          ),
        )
      )
    );
  }
}