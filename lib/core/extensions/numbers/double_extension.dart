import 'package:intl/intl.dart';

extension DoubleFormatting on double {
  String get formattedWithComma => NumberFormat('#,##0.0').format(this);

  String get formatPrice {
    if (this == roundToDouble()) {
      return toStringAsFixed(0);
    }
    return toStringAsFixed(2);
  }
}
