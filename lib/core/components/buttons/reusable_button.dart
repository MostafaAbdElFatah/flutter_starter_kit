import 'dart:math';

import '../../core.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.buttonColor,
    required this.childTextColor,
    this.fontSize = 16,
    this.width,
    this.height = 40,
  });

  final String label;
  final Function onPressed;
  final Color buttonColor;
  final Color childTextColor;
  final double fontSize;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final maxWidth = min(200.0, MediaQuery.of(context).size.width / 2);
    final resolvedWidth = width == null ? maxWidth : min(width!, maxWidth);

    return InkWell(
      onTap: onPressed as VoidCallback,
      child: Container(
        height: height,
        width: resolvedWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: childTextColor.regular(fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
