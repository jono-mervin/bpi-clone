import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/colors.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: BPIApp(),
    ),
  );
}

class BPIApp extends StatelessWidget {
  const BPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.bpiRed,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.bpiRed,
          primary: AppColors.bpiRed,
          secondary: AppColors.navy,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
