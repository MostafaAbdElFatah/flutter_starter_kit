import '../../core.dart';

class IconTextRow extends StatelessWidget {
  final String text;
  final bool prefix;
  final double? fontSize;
  final double? iconSize;
  final String svgIcon;
  final TextStyle? style;
  final MainAxisSize mainAxisSize;
  const IconTextRow({
    super.key,
    required this.svgIcon,
    required this.text,
    this.prefix = true,
    this.mainAxisSize = MainAxisSize.min,
    this.style,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      children: [
        if (prefix) ...[
          SvgIcon(
            size: iconSize,
            svgAssetPath: svgIcon,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 10),
        ],
        Text(
          text,
          style: style ?? AppColors.white.medium(fontSize: fontSize ?? 12),
        ),
        if (!prefix) ...[
          const SizedBox(width: 10),
          SvgIcon(
            size: iconSize,
            svgAssetPath: svgIcon,
            padding: EdgeInsets.zero,
          ),
        ],
      ],
    );
  }
}
