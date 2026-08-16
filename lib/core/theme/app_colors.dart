import 'package:flutter/material.dart';

/// Centralized Color palette for RimRid Shopping.
/// Light theme focused with rich, vibrant premium tones.
class AppColors {
  AppColors._();

  // Brand Primary & Accent Colors
  static const Color primary = Color(0xFF6366F1);       // Indigo primary
  static const Color primaryDark = Color(0xFF4F46E5);   // Deep Indigo
  static const Color primaryLight = Color(0xFFEEF2FF);  // Soft Indigo tint
  static const Color secondary = Color(0xFFF59E0B);     // Vibrant Amber
  static const Color secondaryLight = Color(0xFFFEF3C7);// Soft Amber

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);   // Cool Off-white
  static const Color surface = Color(0xFFFFFFFF);      // Pure White
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color modalBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);   // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8);     // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);        // Slate 200
  static const Color borderLight = Color(0xFFF1F5F9);   // Slate 100
  static const Color divider = Color(0xFFE2E8F0);

  // Functional & State Colors
  static const Color success = Color(0xFF10B981);       // Emerald
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444);         // Rose Red
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);       // Amber
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);          // Blue
  static const Color infoLight = Color(0xFFDBEAFE);

  // E-commerce Special Colors
  static const Color ratingStar = Color(0xFFFBBF24);    // Amber Star
  static const Color discountTag = Color(0xFFEC4899);   // Pink Accent Tag
  static const Color wishlistActive = Color(0xFFEF4444); // Red Heart
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Overlays
  static const Color overlayDark = Color(0x66000000);
}
