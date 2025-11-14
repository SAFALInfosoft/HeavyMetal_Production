import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlinkingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const BlinkingIndicator({Key? key, this.color = Colors.green, this.size = 16})
      : super(key: key);

  @override
  State<BlinkingIndicator> createState() => _BlinkingIndicatorState();
}

class _BlinkingIndicatorState extends State<BlinkingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
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
      child: Icon(
        Icons.circle,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}
