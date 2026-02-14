import '../../../../core.dart';

class ErrorPage extends StatelessWidget {
  final Exception? exception;
  final FlutterErrorDetails? details;
  const ErrorPage({super.key, this.details, this.exception});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
            //stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bug_report_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  LocalizationKeys.ohNo,
                  textAlign: TextAlign.center,
                  style: AppColors.white
                      .bold(fontSize: 24)
                      .copyWith(letterSpacing: 0.5),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        maxLines: 4,
                        exception?.toString() ?? details?.exceptionAsString() ?? LocalizationKeys.oopsSomethingWrong,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Colors.white70
                            .bold(fontSize: 14)
                            .copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    // if (Navigator.of(context).canPop())
                    Expanded(
                      child: IconTextElevatedButton(
                        iconSize: 20,
                        title: LocalizationKeys.close,
                        icon: Icons.exit_to_app,
                        iconColor: Colors.amber,
                        titleColor: AppColors.black,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: IconTextElevatedButton(
                        iconSize: 20,
                        title: LocalizationKeys.technicalSupport,
                        icon: Icons.lightbulb_outline_rounded,
                        iconColor: Colors.amber,
                        titleColor: AppColors.black,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
