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
  late final AnimationController opacityAnimationController;
  late final Animation opacityAnimation;
  late final Animation sizeAnimation;

  animate() async {
    sizeAnimationController.forward();
    opacityAnimationController.forward();
    await Future.delayed(widget.duration);
    opacityAnimationController.reverse();
    sizeAnimationController.reverse();
  }

  reverseAnimate() {
    sizeAnimationController.forward(from: 1);
    opacityAnimationController.forward(from: 1);
    sizeAnimationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    sizeAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    opacityAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    sizeAnimation = Tween<double>(begin: 0, end: widget.fullScreenSize).animate(
      CurvedAnimation(
        parent: sizeAnimationController,
        curve: widget.curve,
      ),
    );
    opacityAnimation = Tween<double>(begin: .5, end: 1).animate(
      CurvedAnimation(parent: opacityAnimationController, curve: widget.curve),
    );

    sizeAnimation.addListener(() => setState(() {}));
    opacityAnimation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.currentPosition.dy - (sizeAnimation.value / 2),
      left: widget.currentPosition.dx - (sizeAnimation.value / 2),
      child: Opacity(
        opacity: opacityAnimation.value > 1 ? 1.0 : opacityAnimation.value,
        child: Container(
          height: sizeAnimation.value,
          width: sizeAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.rippleColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
