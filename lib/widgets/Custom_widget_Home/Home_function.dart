// snackbar_util.dart
import 'package:flutter/material.dart';
import 'dart:ui';

void showCustomSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: double.infinity,
                color: Colors.transparent, // Transparent background
              ),
            ),
          ),
          // SnackBar content with rounded corners
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Text(
                "اضغط مرة أخرى للخروج",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
    ),
  );
}
