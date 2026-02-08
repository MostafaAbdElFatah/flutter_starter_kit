import '../../core.dart';

class RatingView extends StatefulWidget {
  final int rate;
  final void Function(int rate) onValueChange;
  const RatingView(
      {super.key, required this.rate, required this.onValueChange});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  int _rating = 0;

  @override
  void initState() {
    _rating = widget.rate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            _rating = index + 1;
            widget.onValueChange(_rating);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SvgIcon(
              size: 15,
              padding: EdgeInsets.zero,
              svgAssetPath:
                  index < _rating ? SvgIcons.halfStar : SvgIcons.starBorder,
            ),
          ),
        );
      }).reversed.toList(),
    );
  }
}
