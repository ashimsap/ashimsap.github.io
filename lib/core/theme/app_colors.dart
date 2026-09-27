import 'package:flutter/material.dart';

/// Centralized color palette for the Ashim Sapkota Portfolio.
/// Preserves the dark/cyber identity while establishing subtle section accent distinctions.
class AppColors {
  // Base Dark Theme Colors
  static const Color background = Color(0xFF030303);
  static const Color surface = Color(0xFF0D1117);
  static const Color cardBg = Color(0x08FFFFFF); // ~3% opacity white
  static const Color border = Color(0x1AFFFFFF); // ~10% opacity white

  // Section Accent Colors (Rule 13)
  static const Color cyan = Color(0xFF00F0FF); // Primary / BUILD (Development)
  static const Color purple = Color(0xFF7000FF); // GROW (Digital Marketing)
  static const Color green = Color(0xFF28C840); // OPERATE (DevOps)
  static const Color amber = Color(0xFFFFB000); // LAB (Experiments)

  // GitHub Dark Mode Palette
  static const Color githubBg = Color(0xFF0D1117);
  static const Color githubBorder = Color(0xFF30363D);
  static const List<Color> githubLevels = [
    Color(0xFF161B22), // Level 0
    Color(0xFF0E4429), // Level 1
    Color(0xFF006D32), // Level 2
    Color(0xFF26A641), // Level 3
    Color(0xFF39D353), // Level 4
  ];

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white60;
  static const Color textMuted = Colors.white30;
}
