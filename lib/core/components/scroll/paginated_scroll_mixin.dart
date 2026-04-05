import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../extensions/scroll/scroll_controller_extension.dart';


/// A reusable mixin for screens that need paginated scrolling.
mixin PaginatedScrollMixin<T extends StatefulWidget> on State<T> {
  bool _initialized = false;
  late final ScrollController scrollController;

  /// Called once after dependencies are available.
  @protected
  void onInit() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  /// Whether more data can be loaded when reaching the end.
  @protected
  bool get canLoadMore;

  /// Called when the user scrolls near the bottom.
  @protected
  void onLoadMore();

  /// Scroll threshold factor used to trigger pagination.
  @protected
  double get loadMoreThresholdFactor => 0.8;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    onInit();
  }

  void _handleScroll() {
    if (!scrollController.isNearBottom(
      thresholdFactor: loadMoreThresholdFactor,
    )) {
      return;
    }
    if (!canLoadMore) return;
    onLoadMore();
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.dispose();
  }
}
