import 'package:flutter/material.dart';

import '../widgets/section_label.dart';
import 'tokens.dart';

/// `context.colors` gives quick access to the current theme's [AppColors].
extension AppColorsContext on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColorsExtension>()!.colors;
}
