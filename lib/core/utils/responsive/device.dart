enum Device {
  mobile,
  miniTablet,
  largeTablet,
  desktop,
  web;

  bool get isMobile => this == mobile;
  bool get isTablet => this == miniTablet || this == largeTablet;
  bool get isMiniTablet => this == miniTablet;
  bool get isLargeTablet => this == largeTablet;
  bool get isDesktop => this == desktop;
  bool get isWeb => this == web;

  /// Factory to detect device based on screen width
  static Device fromWidth(double width) {
    if (width >= 1440) return web; // Web screens
    if (width >= 1200) return desktop; // Large desktop
    if (width >= 900) return largeTablet; // Large tablet
    if (width >= 600) return miniTablet; // Mini tablet
    return mobile; // Mobile
  }
}
