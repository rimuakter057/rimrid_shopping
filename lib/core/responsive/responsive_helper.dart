import 'package:flutter/material.dart';

/// Reusable Responsive Helper class for screen dimensions, breakpoints,
/// responsive paddings, font sizing, and grid column calculations.
class ResponsiveHelper {
  ResponsiveHelper._();

  static const double mobileMax = 600;
  static const double tabletMax = 1100;

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static Orientation orientation(BuildContext context) {
    return MediaQuery.orientationOf(context);
  }

  static bool isMobile(BuildContext context) {
    return width(context) < mobileMax;
  }

  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= tabletMax;
  }

  /// Calculates responsive horizontal padding for screens and containers
  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w >= tabletMax) return 40.0;
    if (w >= mobileMax) return 24.0;
    return 16.0;
  }

  /// Responsive vertical padding
  static double verticalPadding(BuildContext context) {
    final w = width(context);
    if (w >= tabletMax) return 24.0;
    if (w >= mobileMax) return 20.0;
    return 16.0;
  }

  /// Responsive spacing based on device width multiplier
  static double responsiveSpacing(BuildContext context, double baseSpacing) {
    if (isDesktop(context)) return baseSpacing * 1.4;
    if (isTablet(context)) return baseSpacing * 1.2;
    return baseSpacing;
  }

  /// Calculates responsive grid columns for product grids
  static int gridColumns(BuildContext context) {
    final w = width(context);
    if (w >= 1400) return 5;
    if (w >= 1100) return 4;
    if (w >= 750) return 3;
    if (w >= 450) return 2;
    return 2; // Mobile default grid columns
  }

  /// Responsive font sizing multiplier to scale fonts comfortably
  static double responsiveFontSize(BuildContext context, double baseSize) {
    final w = width(context);
    if (w >= tabletMax) return baseSize * 1.15;
    if (w >= mobileMax) return baseSize * 1.08;
    return baseSize;
  }

  /// Reusable responsive widget sizing helper
  static double valueByDevice<T extends double>({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 1.3;
    if (isTablet(context)) return tablet ?? mobile * 1.15;
    return mobile;
  }
}
