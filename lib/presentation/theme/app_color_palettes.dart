import 'package:flutter/material.dart';

/// Available pastel palettes to customize the look & feel of the app.
enum AppColorPalette {
  /// Warm sunrise inspired pinks.
  dawnBlush,

  /// Fresh mint and eucalyptus tones.
  mintWhisper,

  /// Calm light blue combination.
  skyBreeze,

  /// Soft lavender inspired hues.
  lavenderField,
}

/// Defines the primary colors used for a palette.
class PaletteColors {
  const PaletteColors({
    required this.seed,
    required this.light,
    required this.dark,
  });

  /// Seed color used to generate the material color scheme.
  final Color seed;

  /// Light mode variant for the palette.
  final PaletteVariant light;

  /// Dark mode variant for the palette.
  final PaletteVariant dark;
}

/// Represents a color variant that adapts to a specific brightness.
class PaletteVariant {
  const PaletteVariant({
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onSurface,
    required this.accent,
    required this.onAccent,
  });

  /// Background color applied to scaffolds and large surfaces.
  final Color background;

  /// Surface color used for cards and app bars.
  final Color surface;

  /// Text/icon color displayed on top of [background].
  final Color onBackground;

  /// Text/icon color displayed on top of [surface].
  final Color onSurface;

  /// Accent color for buttons and prominent actions.
  final Color accent;

  /// Text/icon color displayed on top of [accent].
  final Color onAccent;
}

const Map<AppColorPalette, PaletteColors> _paletteTable = {
  AppColorPalette.dawnBlush: PaletteColors(
    seed: Color(0xFFE58A8C),
    light: PaletteVariant(
      background: Color(0xFFFFF4F1),
      surface: Color(0xFFFFFBFA),
      onBackground: Color(0xFF4A2E33),
      onSurface: Color(0xFF4A2E33),
      accent: Color(0xFFDD6B72),
      onAccent: Color(0xFFFFFFFF),
    ),
    dark: PaletteVariant(
      background: Color(0xFF2D1A1F),
      surface: Color(0xFF352126),
      onBackground: Color(0xFFF9E8EA),
      onSurface: Color(0xFFF9E8EA),
      accent: Color(0xFFFF8C94),
      onAccent: Color(0xFF3C1115),
    ),
  ),
  AppColorPalette.mintWhisper: PaletteColors(
    seed: Color(0xFF6CB59F),
    light: PaletteVariant(
      background: Color(0xFFF2FBF6),
      surface: Color(0xFFFAFFFC),
      onBackground: Color(0xFF1E4036),
      onSurface: Color(0xFF1E4036),
      accent: Color(0xFF4C9B88),
      onAccent: Color(0xFFFFFFFF),
    ),
    dark: PaletteVariant(
      background: Color(0xFF142522),
      surface: Color(0xFF1B2D28),
      onBackground: Color(0xFFE4F4ED),
      onSurface: Color(0xFFE4F4ED),
      accent: Color(0xFF6AC0A8),
      onAccent: Color(0xFF06211A),
    ),
  ),
  AppColorPalette.skyBreeze: PaletteColors(
    seed: Color(0xFF7BA6E6),
    light: PaletteVariant(
      background: Color(0xFFF3F7FF),
      surface: Color(0xFFF9FBFF),
      onBackground: Color(0xFF1F2E4C),
      onSurface: Color(0xFF1F2E4C),
      accent: Color(0xFF5F85D6),
      onAccent: Color(0xFFFFFFFF),
    ),
    dark: PaletteVariant(
      background: Color(0xFF121C2E),
      surface: Color(0xFF182335),
      onBackground: Color(0xFFE1ECFF),
      onSurface: Color(0xFFE1ECFF),
      accent: Color(0xFF8FB4FF),
      onAccent: Color(0xFF0A1629),
    ),
  ),
  AppColorPalette.lavenderField: PaletteColors(
    seed: Color(0xFFA59AD6),
    light: PaletteVariant(
      background: Color(0xFFF7F4FF),
      surface: Color(0xFFFCFAFF),
      onBackground: Color(0xFF332D4D),
      onSurface: Color(0xFF332D4D),
      accent: Color(0xFF7E6FB7),
      onAccent: Color(0xFFFFFFFF),
    ),
    dark: PaletteVariant(
      background: Color(0xFF1A182A),
      surface: Color(0xFF221F34),
      onBackground: Color(0xFFECE7FF),
      onSurface: Color(0xFFECE7FF),
      accent: Color(0xFFB2A2F0),
      onAccent: Color(0xFF181136),
    ),
  ),
};

extension AppColorPaletteX on AppColorPalette {
  /// Returns the color definition for the palette.
  PaletteColors get colors => _paletteTable[this]!;
}
