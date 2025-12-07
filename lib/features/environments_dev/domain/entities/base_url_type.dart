/// Defines the type of base URL to use for API requests.
enum BaseUrlType {
  /// Use the default base URL defined for the current environment.
  defaultUrl,

  /// Use a custom, user-defined base URL.
  custom;

  /// Returns `true` if using a custom URL.
  bool get isCustom => this == BaseUrlType.custom;

  /// Returns `true` if using the environment's default URL.
  bool get isDefault => this == BaseUrlType.defaultUrl;
}
