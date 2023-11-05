import 'package:flutter/material.dart';

class RippleCircle extends StatefulWidget {
  final Duration duration;
  final Offset currentPosition;
  final Curve curve;
  final GlobalKey<RippleCircleState> rippleController;
  final double fullScreenSize;
  final Color? rippleColor;

  const RippleCircle({
    required this.duration,
    required this.currentPosition,
    required this.rippleController,
    required this.fullScreenSize,
    this.curve = Curves.linearToEaseOut,
    this.rippleColor,
  }) : super(key: rippleController);

  @override
  RippleCircleState createState() => RippleCircleState();
}

class RippleCircleState extends State<RippleCircle>
    with TickerProviderStateMixin {
  late final AnimationController sizeAnimationController;
  late final Animation sizeAnimation;

  void animate() async {
    await forwardAnimate();
    reverseAnimate();
  }

  Future<void> forwardAnimate() async => sizeAnimationController.forward();

  void reverseAnimate() => sizeAnimationController.reverse();

  @override
  void initState() {
    super.initState();
    sizeAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    sizeAnimation = Tween<double>(begin: 0, end: widget.fullScreenSize).animate(
      CurvedAnimation(
        parent: sizeAnimationController,
        curve: widget.curve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: sizeAnimation,
      builder: (context, size, _) {
        return Positioned(
          top: widget.currentPosition.dy - (size / 2),
          left: widget.currentPosition.dx - (size / 2),
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  widget.rippleColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
