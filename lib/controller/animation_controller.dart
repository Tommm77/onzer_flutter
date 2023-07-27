import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimationController extends StatefulWidget {
  int delay;
  Widget child;
  double offsetBegingX;
  double offsetBegingY;
  MyAnimationController(
      {required this.offsetBegingX,
      required this.offsetBegingY,
      required this.delay,
      required this.child,
      super.key});

  @override
  State<MyAnimationController> createState() => _MyAnimationControllerState();
}

class _MyAnimationControllerState extends State<MyAnimationController>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animationOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this);
    CurvedAnimation animationCurved =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    animationOffset = Tween<Offset>(
            begin: Offset(widget.offsetBegingX, widget.offsetBegingY),
            end: Offset.zero)
        .animate(animationCurved);

    Timer(
      Duration(seconds: widget.delay),
      () {
        _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: animationOffset,
          child: widget.child,
        ));
  }
}
