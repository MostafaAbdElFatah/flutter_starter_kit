import 'dart:math';

import '../../core.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.buttonColor,
    required this.childTextColor,
  });

  final String label;
  final Function onPressed;
  final Color buttonColor;
  final Color childTextColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as VoidCallback,
      child: Container(
        height: 40,
        width: min(200, MediaQuery.of(context).size.width / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: buttonColor,
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: childTextColor.regular(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
