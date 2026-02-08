import 'package:flutter/material.dart';

class CircleAvatarImage extends StatelessWidget {
  final String url;
  final double size;
  const CircleAvatarImage({
    super.key,
    required this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(url, fit: BoxFit.contain,),
      ),
    );
  }
}
