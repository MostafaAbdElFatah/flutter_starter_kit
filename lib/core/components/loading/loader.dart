
import '../../core.dart';

class Loader extends StatelessWidget {
  final bool dismissible;
  const Loader({super.key, required this.dismissible});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.black.withValues(alpha: 0.4),
        body: InkWell(
          onTap: dismissible ? () => Navigator.of(context).pop() : null,
          child: Center(
              child: OrbitLoadingView(
            colors: [
              AppColors.white,
              AppColors.white,
              Theme.of(context).primaryColor
            ],
          )),
        ),
      ),
    );
  }

  static dismiss(BuildContext context) => Navigator.pop(context);
  static show(BuildContext context, {bool dismissible = false}) =>
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return Loader(
              dismissible: dismissible,
            );
          },
        ),
      );
}
