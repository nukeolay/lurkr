import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotatingRefreshIcon extends StatefulWidget {
  const RotatingRefreshIcon({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<RotatingRefreshIcon> with TickerProviderStateMixin {
  static const rotatingWidget = Icon(
    Icons.refresh_rounded,
    size: 30,
    color: Colors.purple,
  );
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
          child: const Center(
        child: rotatingWidget,
      )),
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * math.pi,
          child: child,
        );
      },
    );
  }
}
