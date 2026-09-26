import 'package:flutter/material.dart';

/// Darkens [c] by [percent] (100 = black), keeping its opacity.
Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  return Color.lerp(c, Colors.black.withValues(alpha: c.a), percent / 100)!;
}

/// Lightens [c] by [percent] (100 = white), keeping its opacity.
Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  return Color.lerp(c, Colors.white.withValues(alpha: c.a), percent / 100)!;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${toARGB32().toRadixString(16).padLeft(8, '0')}';
}
