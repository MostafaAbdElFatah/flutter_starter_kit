import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core.dart';

enum ErrorStateType {
  notFound404,
  articleNotFound,
  brokenLink,
  connectionFailed,
  noConnection,
  wrongConnection,
  fileNotFound,
  fileNotFoundDark,
  locationError,
  locationErrorDark,
  noCameraAccess,
  noSearchResult,
  paymentFailed,
  routerOffline,
  certainError,
  fixingError,
  somethingWentWrong,
  somethingWrong,
  storageNotEnough,
  timeError,
}

class ErrorStatePage extends StatelessWidget {
  static const double _compactSearchControlWidth = 100;
  static const double _defaultActionFontSize = 16;
  static const double _actionHorizontalPadding = 24;

  final ErrorStateType type;
  final VoidCallback? onActionPressed;

  const ErrorStatePage({super.key, required this.type, this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    final config = type.config;
    final size = MediaQuery.of(context).size;
    final layoutMetrics = _ErrorLayoutMetrics(size);
    final centerTextsAndActions = type.centerTextsAndActions;
    final compactAction = type.compactActionButton;
    final compactSearchField = type.compactSearchField;
    final contentPaddingValue = centerTextsAndActions
        ? 30.0
        : math.min(config.titleStart, config.messageEnd);
    final contentPadding = layoutMetrics.horizontal(contentPaddingValue);
    final titleAlign = centerTextsAndActions
        ? TextAlign.center
        : TextAlign.start;
    final messageAlign = centerTextsAndActions
        ? TextAlign.center
        : config.messageAlign;
    final titleStyle = config.titleColor.medium(
      fontSize: layoutMetrics.font(config.titleFontSize),
    );
    final messageStyle = config.messageColor.medium(
      fontSize: layoutMetrics.font(config.messageFontSize),
    );
    final actionHeight = config.showSearchField
        ? layoutMetrics.vertical(60).clamp(52.0, 76.0).toDouble()
        : 40.0;
    final actionFontSize = layoutMetrics
        .font(_defaultActionFontSize)
        .clamp(14.0, 20.0)
        .toDouble();

    final crossAxisAlignment = centerTextsAndActions
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.stretch;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(config.imagePath),
            fit: BoxFit.cover,
            matchTextDirection: true,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: contentPadding,
            end: contentPadding,
          ),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Expanded(child: SizedBox()),
              Text(config.title, textAlign: titleAlign, style: titleStyle),
              10.verticalSpace,
              AutoSizeText(
                config.message,
                textAlign: messageAlign,
                style: messageStyle,
              ),
              40.verticalSpace,
              config.showSearchField
                  ? _SearchField(
                      onActionPressed: onActionPressed,
                      height: actionHeight,
                      compactWidth: compactSearchField,
                      centerContent: centerTextsAndActions,
                      hintStyle: Colors.black45.medium(
                        fontSize: layoutMetrics.font(16),
                      ),
                    )
                  : _ActionButton(
                      config: config,
                      onActionPressed: onActionPressed,
                      centerContent: centerTextsAndActions,
                      compactWidth: compactAction,
                      actionFontSize: actionFontSize,
                    ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  // Font-size suitability table for compact action button widths.
  static const List<_ActionWidthRule> _widthSuitabilityTable = [
    _ActionWidthRule(maxFontSize: 14, compactWidth: 96),
    _ActionWidthRule(maxFontSize: 16, compactWidth: 108),
    _ActionWidthRule(maxFontSize: 18, compactWidth: 122),
    _ActionWidthRule(maxFontSize: 20, compactWidth: 136),
    _ActionWidthRule(maxFontSize: double.infinity, compactWidth: 150),
  ];

  final _ErrorStateConfig config;
  final VoidCallback? onActionPressed;
  final bool centerContent;
  final bool compactWidth;
  final double actionFontSize;

  const _ActionButton({
    required this.config,
    this.onActionPressed,
    required this.centerContent,
    required this.compactWidth,
    required this.actionFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final compactActionWidth = compactWidth
        ? _resolveCompactWidth(context)
        : null;
    final button = SizedBox(
      width: compactActionWidth,
      child: ReusableButton(
        label: config.actionLabel!,
        buttonColor: config.actionColor!,
        childTextColor: config.actionTextColor!,
        fontSize: actionFontSize,
        width: compactActionWidth,
        onPressed: onActionPressed ?? () {},
      ),
    );

    return Align(
      alignment: centerContent
          ? AlignmentDirectional.center
          : AlignmentDirectional.centerStart,
      child: button,
    );
  }

  double _resolveCompactWidth(BuildContext context) {
    final baseWidth = _baseWidthForFontSize(actionFontSize);
    final labelWidth = _measureActionLabelWidth(context);
    final targetWidth = math.max(
      baseWidth,
      labelWidth + (ErrorStatePage._actionHorizontalPadding * 2),
    );
    final maxWidth = math.min(200.0, MediaQuery.of(context).size.width / 2);
    return targetWidth.clamp(baseWidth, maxWidth).toDouble();
  }

  double _baseWidthForFontSize(double fontSize) {
    for (final rule in _widthSuitabilityTable) {
      if (fontSize <= rule.maxFontSize) return rule.compactWidth;
    }
    return _widthSuitabilityTable.last.compactWidth;
  }

  double _measureActionLabelWidth(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(
        text: config.actionLabel!.toUpperCase(),
        style: config.actionTextColor!.regular(fontSize: actionFontSize),
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.width;
  }
}

class _ActionWidthRule {
  final double maxFontSize;
  final double compactWidth;

  const _ActionWidthRule({
    required this.maxFontSize,
    required this.compactWidth,
  });
}

class _SearchField extends StatelessWidget {
  final VoidCallback? onActionPressed;
  final double height;
  final bool compactWidth;
  final bool centerContent;
  final TextStyle hintStyle;

  const _SearchField({
    this.onActionPressed,
    required this.height,
    required this.compactWidth,
    required this.centerContent,
    required this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    final searchField = SizedBox(
      width: compactWidth ? ErrorStatePage._compactSearchControlWidth : null,
      height: height,
      child: SizedBox(
        child: TextFormField(
          enabled: false,
          onTap: onActionPressed,
          decoration: InputDecoration(
            hintText: LocalizationKeys.search,
            hintStyle: hintStyle,
            suffixIcon: const Icon(Icons.search, color: Colors.black45),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );

    return Align(
      alignment: centerContent
          ? AlignmentDirectional.center
          : AlignmentDirectional.centerStart,
      child: searchField,
    );
  }
}

class _ErrorLayoutMetrics {
  static const double _baseWidth = 390;
  static const double _baseHeight = 844;

  final Size size;

  _ErrorLayoutMetrics(this.size);

  bool get isTablet => size.shortestSide >= 600;

  double get _horizontalScale {
    final maxScale = isTablet ? 1.95 : 1.15;
    return (size.width / _baseWidth).clamp(0.88, maxScale).toDouble();
  }

  double get _verticalScale {
    final maxScale = isTablet ? 1.35 : 1.12;
    return (size.height / _baseHeight).clamp(0.85, maxScale).toDouble();
  }

  double get _fontScale {
    if (isTablet) {
      return (size.shortestSide / 600).clamp(1.05, 1.25).toDouble();
    }
    return (size.width / _baseWidth).clamp(0.9, 1.08).toDouble();
  }

  double horizontal(double value) => (value * _horizontalScale).toDouble();
  double vertical(double value) => (value * _verticalScale).toDouble();
  double font(double value) => (value * _fontScale).toDouble();
}

class _ErrorStateConfig {
  final String imagePath;
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final double titleBottom;
  final double titleStart;
  final String message;
  final Color messageColor;
  final double messageFontSize;
  final double messageBottom;
  final double messageEnd;
  final TextAlign messageAlign;
  final String? actionLabel;
  final Color? actionColor;
  final Color? actionTextColor;
  final double? actionBottom;
  final double? actionStart;
  final double? actionEnd;
  final bool showSearchField;

  _ErrorStateConfig({
    required this.imagePath,
    required this.title,
    required this.titleColor,
    required this.titleFontSize,
    required this.titleBottom,
    required this.titleStart,
    required this.message,
    required this.messageColor,
    required this.messageFontSize,
    required this.messageBottom,
    required this.messageEnd,
    required this.messageAlign,
    this.actionLabel,
    this.actionColor,
    this.actionTextColor,
    this.actionBottom,
    this.actionStart,
    this.actionEnd,
    this.showSearchField = false,
  });
}

extension _ErrorStateTypeX on ErrorStateType {
  _ErrorStateConfig get config {
    switch (this) {
      case ErrorStateType.notFound404:
        return _ErrorStateConfig(
          imagePath: Images.notFound404Error,
          title: LocalizationKeys.deadEnd,
          titleColor: Colors.white,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.pageNotFoundMessage,
          messageColor: Colors.white54,
          messageFontSize: 25,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.homeTitle,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.articleNotFound:
        return _ErrorStateConfig(
          imagePath: Images.articleNotFoundError,
          title: LocalizationKeys.articleNotFound,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 260,
          titleStart: 100,
          message: LocalizationKeys.articleNotFoundMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 190,
          messageEnd: 50,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.retry,
          actionColor: Colors.green,
          actionTextColor: Colors.white,
          actionBottom: 120,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.brokenLink:
        return _ErrorStateConfig(
          imagePath: Images.brokenLinkError,
          title: LocalizationKeys.brokenLink,
          titleColor: Colors.black,
          titleFontSize: 16,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.brokenLinkMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.goBack,
          actionColor: const Color(0xFF1565C0),
          actionTextColor: Colors.white,
          actionBottom: 60,
          actionStart: 40,
          actionEnd: 40,
        );
      case ErrorStateType.connectionFailed:
        return _ErrorStateConfig(
          imagePath: Images.connectionFailedError,
          title: LocalizationKeys.connectionFailed,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 100,
          message: LocalizationKeys.connectionFailedMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 70,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.retry,
          actionColor: Colors.green,
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.noConnection:
        return _ErrorStateConfig(
          imagePath: Images.connectionLostError,
          title: LocalizationKeys.noConnection,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 200,
          titleStart: 30,
          message: LocalizationKeys.noConnectionMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 150,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.retry,
          actionColor: const Color(0xFF1565C0),
          actionTextColor: Colors.white,
          actionBottom: 50,
          actionStart: 40,
          actionEnd: 40,
        );
      case ErrorStateType.wrongConnection:
        return _ErrorStateConfig(
          imagePath: Images.wrongConnectionError,
          title: LocalizationKeys.oops,
          titleColor: AppColors.white,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.wrongNetwork,
          messageColor: Colors.white54,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.retry,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.fileNotFound:
        return _ErrorStateConfig(
          imagePath: Images.fileNotFoundError,
          title: LocalizationKeys.noFiles,
          titleColor: AppColors.white,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.noFilesMessage,
          messageColor: Colors.white54,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.homeTitle,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.fileNotFoundDark:
        return _ErrorStateConfig(
          imagePath: Images.fileNotFoundError2,
          title: LocalizationKeys.fileNotFound,
          titleColor: AppColors.white,
          titleFontSize: 25,
          titleBottom: 200,
          titleStart: 30,
          message: LocalizationKeys.fileNotFoundMessage,
          messageColor: Colors.white54,
          messageFontSize: 25,
          messageBottom: 140,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.homeTitle,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 70,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.locationError:
        return _ErrorStateConfig(
          imagePath: Images.locationError,
          title: LocalizationKeys.locationAccess,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 260,
          titleStart: 120,
          message: LocalizationKeys.locationAccessMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 190,
          messageEnd: 70,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.enable,
          actionColor: Colors.green,
          actionTextColor: Colors.white,
          actionBottom: 120,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.locationErrorDark:
        return _ErrorStateConfig(
          imagePath: Images.locationError2,
          title: LocalizationKeys.locationAccess,
          titleColor: AppColors.white,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.locationAccessMessage,
          messageColor: Colors.white54,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.refresh,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.noCameraAccess:
        return _ErrorStateConfig(
          imagePath: Images.noCameraAccessError,
          title: LocalizationKeys.noCameraAccess,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.noCameraAccessMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.retry,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.noSearchResult:
        return _ErrorStateConfig(
          imagePath: Images.noSearchResultError,
          title: LocalizationKeys.noResults,
          titleColor: AppColors.white,
          titleFontSize: 35,
          titleBottom: 260,
          titleStart: 30,
          message: LocalizationKeys.noResultsMessage,
          messageColor: Colors.white54,
          messageFontSize: 16,
          messageBottom: 200,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          showSearchField: true,
        );
      case ErrorStateType.paymentFailed:
        return _ErrorStateConfig(
          imagePath: Images.paymentFailedError,
          title: LocalizationKeys.paymentFailed,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.paymentFailedMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.tryAgain,
          actionColor: const Color(0xFF00A2A5),
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.routerOffline:
        return _ErrorStateConfig(
          imagePath: Images.routerOfflineError,
          title: LocalizationKeys.routerOffline,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 120,
          message: LocalizationKeys.routerOfflineMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 70,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.retry,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.certainError:
        return _ErrorStateConfig(
          imagePath: Images.certainError,
          title: LocalizationKeys.uhOh,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 160,
          message: LocalizationKeys.somethingWentWrong,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 100,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.tryAgain,
          actionColor: Colors.green,
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.fixingError:
        return _ErrorStateConfig(
          imagePath: Images.fixingError,
          title: LocalizationKeys.hmmm,
          titleColor: AppColors.white,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.fixingIssue,
          messageColor: Colors.white54,
          messageFontSize: 25,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.tryAgain,
          actionColor: Colors.white,
          actionTextColor: Colors.black,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.somethingWentWrong:
        return _ErrorStateConfig(
          imagePath: Images.somethingWentWrongError,
          title: LocalizationKeys.ohNo,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 160,
          message: LocalizationKeys.somethingWentWrong,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 100,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.tryAgain,
          actionColor: Colors.green,
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.somethingWrong:
        return _ErrorStateConfig(
          imagePath: Images.somethingWrongError,
          title: LocalizationKeys.oops,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 160,
          message: LocalizationKeys.somethingWentWrong,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 100,
          messageAlign: TextAlign.center,
          actionLabel: LocalizationKeys.tryAgain,
          actionColor: Colors.green,
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 130,
          actionEnd: 130,
        );
      case ErrorStateType.storageNotEnough:
        return _ErrorStateConfig(
          imagePath: Images.storageNotEnoughError,
          title: LocalizationKeys.storageNotEnough,
          titleColor: AppColors.purpleNavy,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.storageNotEnoughMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.manage,
          actionColor: const Color.fromARGB(255, 131, 131, 180),
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
      case ErrorStateType.timeError:
        return _ErrorStateConfig(
          imagePath: Images.timeError,
          title: LocalizationKeys.somethingNotRight,
          titleColor: AppColors.black,
          titleFontSize: 25,
          titleBottom: 230,
          titleStart: 30,
          message: LocalizationKeys.somethingNotRightMessage,
          messageColor: Colors.black38,
          messageFontSize: 16,
          messageBottom: 170,
          messageEnd: 30,
          messageAlign: TextAlign.start,
          actionLabel: LocalizationKeys.retry,
          actionColor: AppColors.pastelIndigo,
          actionTextColor: Colors.white,
          actionBottom: 100,
          actionStart: 30,
          actionEnd: 250,
        );
    }
  }
}

extension _ErrorStateTypeLayoutX on ErrorStateType {
  bool get centerTextsAndActions {
    switch (this) {
      case ErrorStateType.articleNotFound:
      case ErrorStateType.connectionFailed:
      case ErrorStateType.locationError:
      case ErrorStateType.routerOffline:
      case ErrorStateType.certainError:
      case ErrorStateType.somethingWentWrong:
      case ErrorStateType.somethingWrong:
        return true;
      default:
        return false;
    }
  }

  bool get compactActionButton {
    switch (this) {
      case ErrorStateType.notFound404:
      case ErrorStateType.brokenLink:
      case ErrorStateType.noConnection:
      case ErrorStateType.wrongConnection:
      case ErrorStateType.fileNotFound:
      case ErrorStateType.fileNotFoundDark:
      case ErrorStateType.locationErrorDark:
      case ErrorStateType.noCameraAccess:
      case ErrorStateType.paymentFailed:
      case ErrorStateType.fixingError:
      case ErrorStateType.storageNotEnough:
      case ErrorStateType.timeError:
        return true;
      default:
        return false;
    }
  }

  bool get compactSearchField => this == ErrorStateType.noSearchResult;
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.notFound404)')
class NotFound404ErrorPage extends StatelessWidget {
  const NotFound404ErrorPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.notFound404);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.articleNotFound)')
class ArticleNotFoundPage extends StatelessWidget {
  const ArticleNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.articleNotFound);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.brokenLink)')
class BrokenLinkPage extends StatelessWidget {
  const BrokenLinkPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.brokenLink);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.connectionFailed)')
class ConnectionFailedPage extends StatelessWidget {
  const ConnectionFailedPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.connectionFailed);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.noConnection)')
class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.noConnection);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.wrongConnection)')
class WrongConnectionPage extends StatelessWidget {
  const WrongConnectionPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.wrongConnection);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.fileNotFound)')
class FileNotFoundPage extends StatelessWidget {
  const FileNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.fileNotFound);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.fileNotFoundDark)')
class FileNotFoundDarkPage extends StatelessWidget {
  const FileNotFoundDarkPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.fileNotFoundDark);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.locationError)')
class LocationErrorPage extends StatelessWidget {
  const LocationErrorPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.locationError);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.locationErrorDark)')
class LocationErrorDarkPage extends StatelessWidget {
  const LocationErrorDarkPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.locationErrorDark);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.noCameraAccess)')
class NoCameraAccessPage extends StatelessWidget {
  const NoCameraAccessPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.noCameraAccess);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.noSearchResult)')
class NoSearchResultFoundPage extends StatelessWidget {
  const NoSearchResultFoundPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.noSearchResult);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.paymentFailed)')
class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.paymentFailed);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.routerOffline)')
class RouterOfflinePage extends StatelessWidget {
  const RouterOfflinePage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.routerOffline);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.certainError)')
class CertainErrorPage extends StatelessWidget {
  final FlutterErrorDetails? details;

  const CertainErrorPage({super.key, this.details});
  const CertainErrorPage.flutterError(this.details, {super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.certainError);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.fixingError)')
class FixingErrorPage extends StatelessWidget {
  const FixingErrorPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.fixingError);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.somethingWentWrong)')
class SomethingWentWrongPage extends StatelessWidget {
  const SomethingWentWrongPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.somethingWentWrong);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.somethingWrong)')
class SomethingWrongPage extends StatelessWidget {
  const SomethingWrongPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.somethingWrong);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.storageNotEnough)')
class StorageNotEnoughPage extends StatelessWidget {
  const StorageNotEnoughPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.storageNotEnough);
}

@Deprecated('Use ErrorStatePage(type: ErrorStateType.timeError)')
class TimeErrorPage extends StatelessWidget {
  const TimeErrorPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ErrorStatePage(type: ErrorStateType.timeError);
}
