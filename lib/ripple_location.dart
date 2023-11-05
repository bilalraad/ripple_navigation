import 'package:flutter/material.dart';
import 'package:ripple_navigation/ripple_circle.dart';
import 'package:ripple_navigation/ripple_route_builder.dart';

class RippleLocation extends StatefulWidget {
  final Widget child;
  final GlobalKey<RippleLocationState> rippleController;
  final Duration animationDuration;
  final Duration pageTransitionDuration;

  final Color? rippleColor;
  final double? rippleSize;

  const RippleLocation({
    required this.child,
    required this.rippleController,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.pageTransitionDuration = const Duration(milliseconds: 200),
    this.rippleSize,
    this.rippleColor,
  }) : super(key: rippleController);

  @override
  RippleLocationState createState() => RippleLocationState();
}

class RippleLocationState extends State<RippleLocation> {
  GlobalKey _rippleLocationKey = GlobalKey();

  final _rippleCircleController = GlobalKey<RippleCircleState>();

  void pushRippleTransitionPage(Widget page) async {
    await startAnimation();
    Navigator.push(
      context,
      RippleRouteBuilder(
        page: page,
        duration: widget.pageTransitionDuration,
      ),
    );
  }

  void pushRippleTransitionWithRouteName({
    required String route,
    dynamic arguments,
  }) async {
    await startAnimation();
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  /// this method for only animating Ripple effect from the [RippleLocation] widget
  Future<void> startAnimation() async =>
      _rippleCircleController.currentState!.animate();

  void handleRippleAnimation() async {
    final findRenderObject =
        _rippleLocationKey.currentContext!.findRenderObject() as RenderBox?;
    final widgetSize = findRenderObject!.size;
    final localToGlobal = findRenderObject.localToGlobal(Offset(
      widgetSize.width / 2,
      widgetSize.height / 2,
    ));

    final fullScreenSize = 2 * MediaQuery.of(context).size.longestSide;
    Overlay.of(context).insert(
      OverlayEntry(builder: (_) {
        return RippleCircle(
          currentPosition: localToGlobal,
          rippleController: _rippleCircleController,
          duration: widget.animationDuration,
          fullScreenSize: widget.rippleSize ?? fullScreenSize,
          rippleColor: widget.rippleColor,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handleRippleAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _rippleLocationKey,
      child: widget.child,
    );
  }
}
