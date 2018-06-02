import 'package:flutter/material.dart';
import 'package:fluttery_demo/models/screen.dart';
import 'package:fluttery_demo/ui/menu_list_item.dart';
import 'package:fluttery_demo/ui/zoom_scaffold.dart';



final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');
final containerKey = GlobalKey(debugLabel: 'Container');
final safeAreaKey = GlobalKey(debugLabel: 'SafeArea');


class MenuItem {
  final String id;
  final String title;
  final Screen screen;

  MenuItem({
    this.id,
    this.title,
    this.screen
  });
}


class Menu {
  final List<MenuItem> items;

  Menu({
    this.items
  });
}


class MenuScreen extends StatefulWidget {
  final Menu menu;
  final String selectedMenuId;
  final Function(String) onMenuSelected; 

  MenuScreen({
    @required this.menu,
    @required this.selectedMenuId,
    @required this.onMenuSelected
  }) : super(key: menuScreenKey);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {

  AnimationController _titleAnimationController;
  double _selectorYTop;
  double _selectorYBottom;

  setSelectedRenderBox(RenderBox newRenderBox) async {
    final safeAreaRenderObject = safeAreaKey.currentContext.findRenderObject();
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0), ancestor: safeAreaRenderObject).dy;
    final newYBottom = newYTop + newRenderBox.size.height;

    if (newYTop != _selectorYTop) {
      setState(() {
        _selectorYTop = newYTop;
        _selectorYBottom = newYBottom;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    ); 
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    
    super.dispose();
  }

  Widget _createMenuTitle(MenuController menuController) {

    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        _titleAnimationController.forward();
        break;

      case MenuState.closed:
      case MenuState.closing:
        _titleAnimationController.reverse();
        break;
    }

    return AnimatedBuilder(
      animation: _titleAnimationController,
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'Menu',
            style: TextStyle(
              color: const Color(0x88444444),
              fontFamily: 'mermaid',
              fontSize: 240.0,
            ),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            250.0 * (1.0 - _titleAnimationController.value) - 100.0,
            0.0,
            0.0
          ),
          child: child
        );
      },
    );
  }

  Widget _createMenuItems(MenuController menuController, Function toggle) {

    final animationDuration = menuController.state != MenuState.closing ? 0.5 : 1.0;
    final perListItemDelay = menuController.state != MenuState.closing ? ((1.0 - animationDuration) / widget.menu.items.length) : 0.0;
    final List<Widget> listItems = [];
    
    for (var i = 0; i < widget.menu.items.length; ++i) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd = animationIntervalStart + animationDuration;
      final currentMenu = widget.menu.items[i];
      final isSelected = (widget.selectedMenuId == currentMenu.id);

      listItems.add(
        AnimatedMenuListItem(
          menuState: menuController.state,
          duration: const Duration(milliseconds: 600),
          isSelected: isSelected,
          curve: Interval(
            animationIntervalStart,
            animationIntervalEnd,
            curve: Curves.easeOut
          ),
          menuListItem: MenuListItem(
            title: currentMenu.title,
            isSelected: isSelected,
            onTap: () {
              widget.onMenuSelected(currentMenu.id);
              toggle();
            },
          ),
        )
      );
    }

    return Transform(
      transform: Matrix4.translationValues(0.0, 225.0, 0.0),
      child: Column(
        children: listItems
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    

    return ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController, Function toggle) {
      
        var shouldRenderSelector = true;

        var actualSelectorYTop = _selectorYTop;
        var actualSelectorYBottom = _selectorYBottom;
        var selectorOpacity = 1.0;

        if (menuController.state == MenuState.closed 
          || menuController.state == MenuState.closing
          || _selectorYTop == null) {
          
          final RenderBox menuScreenRenderBox = context.findRenderObject() as RenderBox;

          if (menuScreenRenderBox != null) {
            final menuScreenHeight = menuScreenRenderBox.size.height;
            actualSelectorYTop = menuScreenHeight - 50.0;
            actualSelectorYBottom = menuScreenHeight;
            selectorOpacity = 0.0;
          } else {
            shouldRenderSelector = false;
          }
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dark_grunge_bk.jpg'),
              fit: BoxFit.cover,
            )
          ),
          child: SafeArea(
            key: safeAreaKey,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  _createMenuTitle(menuController),
                  _createMenuItems(menuController, toggle),
                  shouldRenderSelector 
                    ? ItemSelector(
                        topY: actualSelectorYTop,
                        bottomY: actualSelectorYBottom,
                        opacity: selectorOpacity,
                      )
                    : Container()
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}


class ItemSelector extends ImplicitlyAnimatedWidget {

  final double topY;
  final double bottomY;
  final double opacity;

  ItemSelector({
    this.topY,
    this.bottomY,
    this.opacity,
  }) : super(duration: const Duration(milliseconds: 250));

  @override
  _ItemSelectorState createState() => _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    _topY = visitor(
      _topY,
      widget.topY,
      (dynamic value) => Tween<double>(begin: value)
    );

    _bottomY = visitor(
      _bottomY,
      widget.bottomY,
      (dynamic value) => Tween<double>(begin: value)
    );

    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => Tween<double>(begin: value)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topY.evaluate(animation),
      child: Opacity(
        opacity: _opacity.evaluate(animation),
        child: Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}


class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {

  final MenuListItem menuListItem;
  final MenuState menuState;
  final Duration duration;
  final bool isSelected;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.duration,
    this.isSelected,
    curve
  }): super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  updateSelectedRenderBox() {
    final renderBox = context.findRenderObject() as RenderBox;

    if (renderBox != null && widget.isSelected) {
      (menuScreenKey.currentState as _MenuScreenState).setSelectedRenderBox(renderBox);
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;

      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => Tween<double>(begin: value)
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => Tween<double>(begin: value)
    );
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();

    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: Transform(
        transform: Matrix4.translationValues(0.0, _translation.evaluate(animation), 0.0),
        child: widget.menuListItem,
      ),
    );
  }
}