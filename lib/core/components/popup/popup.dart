import 'package:flutter/material.dart';

class Popup {
  static Popup? _instance;
  OverlayEntry? _overlayEntry;
  final BuildContext _context;
  Popup._(BuildContext context) : _context = context;

  static Popup? of(BuildContext context) {
    if(_instance != null){
      _instance?.dismissPopup();
      _instance = null;
    }
    _instance = Popup._(context);
    return _instance;
  }

  void showPopup({
    required Widget child,
    required Offset tapPosition,
    double popupWidth = 200.0,
    double popupHeight = 80.0,
  }) {
    // Remove any existing popup first.
    dismissPopup();

    final screenSize = MediaQuery.of(_context).size;
    const margin = 16.0;

    // Calculate horizontal (left) position.
    double left = tapPosition.dx;
    if (left + popupWidth > screenSize.width - margin) {
      left = screenSize.width - popupWidth - margin;
    }
    if (left < margin) left = margin;

    // Calculate vertical (top) position: by default, display above the tap.
    double top = tapPosition.dy - popupHeight - 10;
    // If there isn't enough space above, display below the tap.
    if (top < margin) {
      top = tapPosition.dy + 10;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Full-screen barrier to dismiss the popup on tapping anywhere.
          Positioned.fill(
            child: GestureDetector(
              onTap: dismissPopup,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Position the popup at the calculated position.
          Positioned(
            left: left,
            top: top,
            child: child,
          ),
        ],
      ),
    );

    Overlay.of(_context).insert(_overlayEntry!);
  }

  void dismissPopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
