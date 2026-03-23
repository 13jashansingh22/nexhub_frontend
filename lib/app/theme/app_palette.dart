import 'package:flutter/material.dart';

class AppPalette {
  static const Color bgDeep = Color(0xFF090814);
  static const Color bgMid = Color(0xFF121026);
  static const Color bgSoft = Color(0xFF1B1734);

  static const Color cyan = Color(0xFF00E5FF);
  static const Color purple = Color(0xFF8A63FF);
  static const Color pink = Color(0xFFFF4FD8);
  static const Color blue = Color(0xFF3C7DFF);
  static const Color lime = Color(0xFF8BFF7A);
  static const Color orange = Color(0xFFFFA24D);

  static const Color textPrimary = Color(0xFFF8F7FF);
  static const Color textMuted = Color(0xFFACA9C8);
}

class AppGradients {
  static const LinearGradient appBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppPalette.bgDeep, AppPalette.bgMid, Color(0xFF120D2A)],
  );

  static const LinearGradient glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x12FFFFFF)],
  );

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppPalette.purple, AppPalette.blue, AppPalette.cyan],
  );

  static const LinearGradient casual = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D1F69), Color(0xFF0086FF)],
  );

  static const LinearGradient arcade = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A1D62), Color(0xFFFF4D85)],
  );

  static const LinearGradient puzzle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF104B5B), Color(0xFF2CD6C4)],
  );

  static const LinearGradient action = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF671B1B), Color(0xFFFF8235)],
  );

  static const LinearGradient multiplayer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D1A7A), Color(0xFF8C43FF)],
  );

  static const LinearGradient unique = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF173563), Color(0xFF12D7FA)],
  );
}

class AppGlow {
  static List<BoxShadow> neonCyan([double blur = 24]) => [
    BoxShadow(
      color: AppPalette.cyan.withValues(alpha: 0.45),
      blurRadius: blur,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> softPurple([double blur = 30]) => [
    BoxShadow(
      color: AppPalette.purple.withValues(alpha: 0.32),
      blurRadius: blur,
      spreadRadius: 1,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppSpace {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadius {
  static const BorderRadius sm = BorderRadius.all(Radius.circular(12));
  static const BorderRadius md = BorderRadius.all(Radius.circular(18));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(24));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(32));
}
