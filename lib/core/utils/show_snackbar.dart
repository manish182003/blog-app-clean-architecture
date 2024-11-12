import 'package:flutter/material.dart';

OverlayEntry? _overlayEntry;

void showFloatingSnackBar(BuildContext context, String message) {
  _overlayEntry?.remove();
  // Define the entry for the overlay
  _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height *
          0.82, // Adjust position as needed
      left: 15.0,
      right: 15.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black87, // Background color
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Add the overlay to the screen
  Overlay.of(context).insert(_overlayEntry!);

  // Remove the overlay after a delay
  Future.delayed(Duration(seconds: 3), () {
    _overlayEntry?.remove();
    _overlayEntry = null;
  });
}
