import 'package:equatable/equatable.dart';

import 'base_url_type.dart';

/// Manages the base URL configuration.
///
/// This class is immutable and supports serialization to/from JSON, allowing it
/// to be persisted locally. It uses [Equatable] for value-based comparison.
class BaseUrlConfig extends Equatable {
  /// The type of base URL configuration (default or custom).
  final BaseUrlType type;

  /// The custom URL, if [type] is [BaseUrlType.custom].
  final String? customUrl;

  /// Creates a [BaseUrlConfig] with the URL setting and custom URL.
  const BaseUrlConfig({
    required this.type,
    this.customUrl,
  });

  /// Creates a [BaseUrlConfig] with the default URL setting.
  const BaseUrlConfig.defaultUrl()
      : type = BaseUrlType.defaultUrl,
        customUrl = null;

  /// Creates a [BaseUrlConfig] with a custom URL.
  const BaseUrlConfig.custom(String url)
      : type = BaseUrlType.custom,
        customUrl = url;

  /// Returns `true` if using a custom URL.
  bool get isCustom => type == BaseUrlType.custom;

  /// Returns `true` if using the environment's default URL.
  bool get isDefault => type == BaseUrlType.defaultUrl;

  /// Creates a copy of this config with optional new values.
  BaseUrlConfig copyWith({BaseUrlType? type, String? customUrl}) {
    final effectiveType = type ?? this.type;
    if (effectiveType == BaseUrlType.custom) {
      // When copying to custom, use the provided URL or fall back to the existing one.
      return BaseUrlConfig.custom(customUrl ?? this.customUrl ?? '');
    }
    // Otherwise, always return a default config.
    return const BaseUrlConfig.defaultUrl();
  }

  @override
  List<Object?> get props => [type, customUrl];
}
