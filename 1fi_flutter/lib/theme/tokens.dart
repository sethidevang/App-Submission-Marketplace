import 'package:flutter/material.dart';

/// Design tokens mirroring the CSS custom properties in the web prototype,
/// so the Flutter app reads as the same visual system in both themes.
class AppColors {
  final Color bg;
  final Color surface;
  final Color surfaceTint;
  final Color track;
  final Color border;
  final Color text;
  final Color text2;
  final Color text3;
  final Color accent600;
  final Color accent500;
  final Color accent400;
  final Color accent50;
  final Color gold;
  final Color goldSoft;
  final List<Color> hero;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceTint,
    required this.track,
    required this.border,
    required this.text,
    required this.text2,
    required this.text3,
    required this.accent600,
    required this.accent500,
    required this.accent400,
    required this.accent50,
    required this.gold,
    required this.goldSoft,
    required this.hero,
  });

  static const light = AppColors(
    bg: Color(0xFFF6F6F6),
    surface: Color(0xFFFFFFFF),
    surfaceTint: Color(0xFFEFEAFB),
    track: Color(0xFFEEEAF7),
    border: Color(0xFFE7E3F2),
    text: Color(0xFF18151F),
    text2: Color(0xFF6B6875),
    text3: Color(0xFF9C99A6),
    accent600: Color(0xFF4B22C9),
    accent500: Color(0xFF6C3CE0),
    accent400: Color(0xFF8C63EA),
    accent50: Color(0xFFF1ECFD),
    gold: Color(0xFFE8A317),
    goldSoft: Color(0xFFFCEFD1),
    hero: [Color(0xFF1D1046), Color(0xFF4B22C9), Color(0xFF7A3FE4)],
  );

  static const dark = AppColors(
    bg: Color(0xFF131019),
    surface: Color(0xFF1D1926),
    surfaceTint: Color(0xFF241F32),
    track: Color(0xFF221D2E),
    border: Color(0xFF2C273A),
    text: Color(0xFFF3F1F8),
    text2: Color(0xFFACA8B8),
    text3: Color(0xFF7C7889),
    accent600: Color(0xFF8C63EA),
    accent500: Color(0xFF9B7BFF),
    accent400: Color(0xFFB29CFF),
    accent50: Color(0xFF241F3A),
    gold: Color(0xFFF0B429),
    goldSoft: Color(0xFF3A2E12),
    hero: [Color(0xFF0E0824), Color(0xFF341A85), Color(0xFF5B31C9)],
  );
}

/// Maps a product's `icon` string (from the API) to a Material icon,
/// matching the icon set used in the web prototype's tile artwork.
IconData iconForProduct(String icon) {
  switch (icon) {
    case 'phone':
      return Icons.smartphone_rounded;
    case 'laptop':
      return Icons.laptop_mac_rounded;
    case 'tv':
      return Icons.tv_rounded;
    case 'headphones':
      return Icons.headphones_rounded;
    case 'washer':
      return Icons.local_laundry_service_rounded;
    case 'watch':
      return Icons.watch_rounded;
    case 'wind':
      return Icons.air_rounded;
    default:
      return Icons.shopping_bag_rounded;
  }
}

/// Parses a "#RRGGBB" string (as returned by the API) into a Color.
Color hexToColor(String hex) {
  final clean = hex.replaceAll('#', '');
  return Color(int.parse('FF$clean', radix: 16));
}
