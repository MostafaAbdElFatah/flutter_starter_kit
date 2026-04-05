import '../../../utils/log.dart';

mixin EnumKey<T> {
  T get value;
}

extension EnumKeyListX<E extends EnumKey<V>, V> on List<E> {
  /// Returns the enum matching [value].
  /// If [fallback] is provided, returns it when no match is found.
  /// Otherwise throws ArgumentError.
  E byValue(V? value, {E? fallback, String? name}) {
    return firstWhere(
      (e) => e.value == value,
      orElse: () {
        if (fallback != null) {
          Log.error(
            'Unknown ${name ?? E.toString()}: $value. Using fallback: ${fallback.value}',
          );
          return fallback;
        } else {
          throw ArgumentError('Unknown ${name ?? E.toString()}: $value');
        }
      },
    );
  }
}
