import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/context_ext.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final isDark = app.themeMode == ThemeMode.dark;

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.read<AppState>().toggleTheme(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                size: 14,
                color: c.text2,
              ),
              const SizedBox(width: 6),
              Text(
                isDark ? 'Light' : 'Dark',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: c.text2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
