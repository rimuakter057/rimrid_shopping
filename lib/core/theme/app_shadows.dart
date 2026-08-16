import 'package:flutter/material.dart';

/// Centralized Shadow definitions.
class AppShadows {
  AppShadows._();

  static const BoxShadow soft = BoxShadow(
    color: Color(0x0A0F172A),
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const BoxShadow card = BoxShadow(
    color: Color(0x0F0F172A),
    blurRadius: 16,
    offset: Offset(0, 6),
    spreadRadius: -2,
  );

  static const BoxShadow elevated = BoxShadow(
    color: Color(0x1A6366F1),
    blurRadius: 20,
    offset: Offset(0, 8),
  );

  static const BoxShadow bottomNav = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 20,
    offset: Offset(0, -4),
  );

  static const List<BoxShadow> cardShadowList = [card];
  static const List<BoxShadow> softShadowList = [soft];
  static const List<BoxShadow> elevatedShadowList = [elevated];
  static const List<BoxShadow> bottomNavShadowList = [bottomNav];
}
