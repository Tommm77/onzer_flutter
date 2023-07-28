import 'package:flutter/material.dart';

class AnimationMessage extends StatefulWidget {
  const AnimationMessage({super.key});

  @override
  State<AnimationMessage> createState() => _AnimationMessageState();
}

class _AnimationMessageState extends State<AnimationMessage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
