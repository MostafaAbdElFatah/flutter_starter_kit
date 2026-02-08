import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedImage extends StatelessWidget {
  final BoxFit? fit;
  final String imageUrl;
  final double? radius;
  final ColorFilter? colorFilter;
  final BorderRadiusGeometry? borderRadius;
  const CachedImage({
    super.key,
    required this.imageUrl,
    this.radius,
    this.borderRadius,
    this.colorFilter,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) {
        if (kDebugMode) print("error => $error");
        return const Center(child: CircularProgressIndicator());
        //return const Center(child: Icon(Icons.error, color: Colors.red));
      },
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ??
              (radius == 0
                  ? BorderRadius.zero
                  : BorderRadius.circular(radius ?? 10.w)),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
            colorFilter: colorFilter,
          ),
        ),
      ),
    );
  }
}
