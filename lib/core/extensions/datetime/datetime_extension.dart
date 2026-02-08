import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../di/injection.dart' as di;

String _twoDigits(int n) => n.toString().padLeft(2, '0');

/// Date/time formatting and comparison helpers for [DateTime].
extension DateTimeToString on DateTime {
  /// True when this [DateTime] is on the same local calendar day as now.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  Locale get _currentLocate => di.appLocaleState.current;

  /// True when this [DateTime] is before now and not the same day.
  bool get isPassed => isBefore(DateTime.now()) && !isToday;

  /// True when this [DateTime] matches [date] in year, month, and day.
  bool isSameDay(DateTime date) =>
      year == date.year && month == date.month && day == date.day;

  /// Month name and year, localized (e.g. "February 2026").
  String get yMMMM =>
      DateFormat('MMMM yyyy', _currentLocate.languageCode).format(this);

  /// Day, month name, and year, localized (e.g. "5 February 2026").
  String yMMMMd(Locale locale) =>
      DateFormat('d MMMM yyyy', _currentLocate.languageCode).format(this);

  /// Localized abbreviated date with weekday.
  String get yMMMEd =>
      DateFormat.yMMMEd(_currentLocate.languageCode).format(this);

  /// Localized abbreviated date (e.g. "Feb 5, 2026").
  String get yMMMd =>
      DateFormat.yMMMd(_currentLocate.languageCode).format(this);

  /// ISO-like date string: `yyyy-MM-dd`.
  String get yMMdd =>
      DateFormat('yyyy-MM-dd', _currentLocate.languageCode).format(this);

  /// 12-hour time with AM/PM, localized.
  String get aMMHH =>
      DateFormat('hh:mm a', _currentLocate.languageCode).format(this);

  /// Manual ISO-like date string without locale: `yyyy-MM-dd`.
  String get yMMd =>
      "${year.toString().padLeft(4, '0')}-${_twoDigits(month)}-${_twoDigits(day)}";

  /// Milliseconds between now and this [DateTime]. Positive if in the past.
  int get inMillisecondsPassedDifference =>
      DateTime.now().difference(this).inMilliseconds;

  /// Whole days between this and [toDate] (defaults to now).
  /// Negative values indicate that [toDate] is earlier than this.
  int daysLeft({DateTime? toDate}) =>
      difference(toDate ?? DateTime.now()).inDays;
}

/// Convenience formatting for an integer interpreted as seconds.
extension IntToString on int {
  String get formattedString => Duration(seconds: this).secondFormattedString;
}

/// String formatting helpers for [Duration].
extension DurationToString on Duration {
  /// Returns a clock-like string: `DD HH:MM:SS` when days > 0,
  /// otherwise a leading space is preserved before `HH:MM:SS`.
  String get formattedString {
    final twoDigitHours = _twoDigits(inHours.remainder(24));
    final twoDigitMinutes = _twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = _twoDigits(inSeconds.remainder(60));
    final result =
        "${inDays > 0 ? _twoDigits(inDays) : ''} $twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    //if (kDebugMode) print("result $result");
    return result;
  }

  /// Returns a `MM:SS` string, suitable for short durations.
  String get secondFormattedString {
    final twoDigitMinutes = _twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = _twoDigits(inSeconds.remainder(60));
    final result = "$twoDigitMinutes:$twoDigitSeconds";
    return result;
  }
}
