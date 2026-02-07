import 'package:flutter/material.dart';

/// Build a MaterialColor that includes standard Material shade keys (50..900)
/// by sampling/interpolating your custom 0..100 palette. Returns a concise
/// and predictable map so Flutter can safely look up standard shades.
MaterialColor materialColorWithStandardShades(MaterialColor src) {
  final keys = src.keys.toList()..sort();

  Color sampleAt(double percent) {
    if (keys.isEmpty) return Color(src.toARGB32());
    final lower = keys.lastWhere((k) => k <= percent, orElse: () => keys.first);
    final upper = keys.firstWhere((k) => k >= percent, orElse: () => keys.last);
    final a = src[lower];
    final b = src[upper];
    if (a == null) return b ?? Color(src.toARGB32());
    if (b == null) return a;
    if (lower == upper) return a;
    final t = (percent - lower) / (upper - lower);
    return Color.lerp(a, b, t)!;
  }

  final map = {for (final k in keys) k: src[k]!};
  const standard = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  for (final s in standard) {
    final percent = (s / 900.0) * 100.0; // 50..900 -> 0..100
    map.putIfAbsent(s, () => sampleAt(percent));
  }

  return MaterialColor(src.toARGB32(), map);
}

/// Interpolate two MaterialColor instances in a concise way and avoid nulls.
MaterialColor lerpMaterialColor(MaterialColor a, MaterialColor b, double t) {
  final primary =
      Color.lerp(Color(a.toARGB32()), Color(b.toARGB32()), t) ??
      Color(a.toARGB32());
  final keys = {...a.keys, ...b.keys}.toList()..sort();
  final map = {
    for (final k in keys)
      k: (Color.lerp(a[k], b[k], t) ?? a[k] ?? b[k] ?? primary),
  };
  return MaterialColor(primary.toARGB32(), map);
}
