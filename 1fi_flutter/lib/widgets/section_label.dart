import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColorsExtension>()!.colors;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: c.text2,
      ),
    );
  }
}

/// Makes [AppColors] reachable from any BuildContext via Theme.of(context).
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final AppColors colors;
  const AppColorsExtension(this.colors);

  @override
  AppColorsExtension copyWith({AppColors? colors}) =>
      AppColorsExtension(colors ?? this.colors);

  @override
  AppColorsExtension lerp(
      covariant ThemeExtension<AppColorsExtension>? other, double t) {
    return this;
  }
}
