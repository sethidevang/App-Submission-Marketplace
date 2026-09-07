import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/shop_page.dart';
import 'state/app_state.dart';
import 'theme/tokens.dart';
import 'widgets/section_label.dart';

void main() {
  runApp(const OneFiApp());
}

class OneFiApp extends StatelessWidget {
  const OneFiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, app, _) {
          return MaterialApp(
            title: '1Fi Marketplace',
            debugShowCheckedModeBanner: false,
            themeMode: app.themeMode,
            theme: _buildTheme(AppColors.light),
            darkTheme: _buildTheme(AppColors.dark),
            home: const ShopPage(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(AppColors c) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: c == AppColors.dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.accent500,
        brightness: c == AppColors.dark ? Brightness.dark : Brightness.light,
        surface: c.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(
        c == AppColors.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(bodyColor: c.text, displayColor: c.text),
    );
    return base.copyWith(
      extensions: [AppColorsExtension(c)],
    );
  }
}
