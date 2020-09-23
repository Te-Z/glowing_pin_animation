import 'package:flutter/material.dart';

class Pin extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Brightness brightness;
  final bool glow;

  const Pin({
    @required this.text,
    this.textStyle,
    this.brightness = Brightness.light,
    this.glow = false,
  });

  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;


  Color _pinColor(BuildContext context) {
    if (widget.glow) {
      return Colors.orange;
    } else if (widget.brightness == Brightness.dark) {
      return Theme.of(context).colorScheme.onPrimary.withAlpha(60);
    } else {
      return Colors.grey;
    }
  }

  List<BoxShadow> _shadow(BuildContext context) {
    if (widget.glow) {
      if(!_animationController.isAnimating){
        _animationController.repeat(reverse: true);
      }
      return [
        BoxShadow(
            color: _pinColor(context),
            blurRadius: _animation.value,
            spreadRadius: _animation.value)
      ];
    } else {
      _animationController.reset();
      return null;
    }
  }

  Color _textColor(BuildContext context) {
    if (widget.brightness == Brightness.dark) {
      return Theme.of(context).colorScheme.onPrimary;
    } else {
      return Colors.white;
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0.1, end: 4.0).animate(_animationController)..addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _pinColor(context),
          boxShadow: _shadow(context)),
      child: Text(
        widget.text,
        style:
            (widget.textStyle ?? Theme.of(context).textTheme.caption).copyWith(
          color: _textColor(context),
        ),
      ),
    );
  }
}

class CounterPin extends Pin {
  final int leftValue;
  final int rightValue;

  CounterPin({
    @required this.leftValue,
    @required this.rightValue,
    final bool glow = false,
    final Brightness brightness,
  }) : super(
          text:
              '${leftValue.toString().padLeft(2, '0')}/${rightValue.toString().padLeft(2, '0')}',
          brightness: brightness,
          glow: glow,
        );
}
