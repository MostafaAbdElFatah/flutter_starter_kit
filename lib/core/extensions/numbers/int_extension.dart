
import '../datetime/datetime_extension.dart';

extension IntToString on int {
  String get formattedString => Duration(seconds: this).secondFormattedString;
}
