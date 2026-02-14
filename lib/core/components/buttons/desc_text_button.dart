import '../../core.dart';

/// A compact row with descriptive text followed by a tappable action.
class DescTextButton extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Non-interactive description text.
  final String desc;

  /// Action text shown as a tappable label.
  final String title;

  /// Tap callback for the action text.
  final GestureTapCallback? onTap;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [DescTextButton] with the given parameters.
  const DescTextButton({
    super.key,
    required this.desc,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          desc,
          style: AppColors.spunPearl.regular(fontSize: 12),
        ),
        if (onTap != null)
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: Text(
                title,
                style: AppColors.white.black(fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }
}
