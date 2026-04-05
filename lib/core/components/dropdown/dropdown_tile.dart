import '../../core.dart';

class DropdownTile extends StatelessWidget {
  final String item;
  final bool isSelected;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const DropdownTile({
    super.key,
    required this.item,
    required this.isSelected,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BorderedContainer(
      margin: margin,
      padding: padding ?? EdgeInsets.all(10.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item,
              style: AppColors.white.regular(fontSize: 12),
            ),
          ),
          SizedBox(width: 20.w),
          if (isSelected)
            CircleAvatar(
              radius: 5.w,
              backgroundColor: AppColors.white,
            )
        ],
      ),
    );
  }
}
