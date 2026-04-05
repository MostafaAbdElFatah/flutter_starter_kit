import 'package:flutter/widgets.dart';

extension ScrollControllerX on ScrollController {
  /// Returns true when the scroll position has passed [thresholdFactor]
  /// of the max scroll extent.
  bool isNearBottom({double thresholdFactor = 0.8}) {
    if (!hasClients) return false;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    return currentScroll >= maxScroll * thresholdFactor;
  }
}
