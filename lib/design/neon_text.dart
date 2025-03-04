import 'package:flutter/material.dart';

class NeonText extends StatefulWidget {
  const NeonText({
    super.key,
    required this.text,
    required this.color,
    this.style = const TextStyle(fontSize: 60),
  });
  final String text;
  final Color color;
  final TextStyle style;
  @override
  State<NeonText> createState() => _NeonTextState();
}

class _NeonTextState extends State<NeonText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.text,
          style: widget.style.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(color: widget.color, blurRadius: 7 * _animation.value),
              Shadow(
                color: widget.color.withOpacity(0.7),
                blurRadius: 14 * _animation.value,
              ),
              Shadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 21 * _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
