import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Appbutton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final double? fontSize;
  final double? verticalPadding;
  final double? borderRadius;
  final double? width; // ⬅️ new optional param
  final IconData? icon; // ✅ optional icon
  final Color? iconColor;

  const Appbutton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFFFF5252),
    this.fontSize,
    this.verticalPadding,
    this.borderRadius,
    this.width,
    this.icon,
    this.iconColor = Colors.white, // ✅ default white
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final widthScreen = size.width;

    return SizedBox(
      width: width ?? double.infinity, // ⬅️ use param OR expand full width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? height * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? widthScreen * 0.03,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: height * 0.025),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? height * 0.022,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
