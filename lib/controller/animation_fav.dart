import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../view/player_music.dart';

class LikeAnimation extends StatefulWidget {
  final Function onpressed;
  late bool isFav;
  LikeAnimation({required this.isFav, required this.onpressed() ,super.key});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late ShakeEffect _shakeEffect;
  late ScaleEffect _scaleEffect;
  late ScaleEffect _scaleEffect2;

  double _size = 40;
  Color _color = Colors.red;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          }
        });

        _shakeEffect = ShakeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          hz: 8,
          offset:  Offset(0, 0),
          rotation: 0.262,
        );


        _scaleEffect = ScaleEffect(
          curve: Curves.bounceOut,
          delay: 200.ms,
          duration: 500.ms,
          begin:  Offset(1, 1),
          end:  Offset(2, 2),
        );

        _scaleEffect2 = ScaleEffect(
          curve: Curves.bounceOut,
          delay: 400.ms,
          duration: 500.ms,
          begin:  Offset(1, 1),
          end:  Offset(0.5,0.5),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [ _shakeEffect, _scaleEffect, _scaleEffect2 ],
      autoPlay: false,
      target: widget.isFav ? 1 : 0,
      child: IconButton(
        icon: FaIcon(
          (widget.isFav) ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: _color,
          size: _size,
        ),
        onPressed: () {
          setState(() {
            widget.isFav = !widget.isFav;
            _controller.forward();
            widget.onpressed();
          });
        },
      )
    );
  }
}

