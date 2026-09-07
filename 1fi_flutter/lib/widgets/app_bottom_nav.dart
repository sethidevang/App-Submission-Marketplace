import 'package:flutter/material.dart';

import '../theme/context_ext.dart';

/// Bottom navigation matching the reference app: Home / Shop / EMI Dues /
/// Limit / Profile. Only Shop is implemented in this build, so the other
/// tabs are inert — tapping them does nothing, same as the web prototype.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final items = const [
      (Icons.home_outlined, 'Home'),
      (Icons.storefront_outlined, 'Shop'),
      (Icons.receipt_long_outlined, 'EMI Dues'),
      (Icons.show_chart_rounded, 'Limit'),
      (Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (i) {
            final active = i == 1;
            final (icon, label) = items[i];
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 22, color: active ? c.accent500 : c.text3),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: active ? c.accent500 : c.text3,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
