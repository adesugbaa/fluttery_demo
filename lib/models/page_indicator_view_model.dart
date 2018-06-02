import 'package:fluttery_demo/models/page_view_model.dart';
import 'package:fluttery_demo/screens/reveal/enums.dart';



class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  );
}