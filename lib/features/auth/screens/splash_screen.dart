import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import './login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _phase = 1;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images to prevent jank during transition
    precacheImage(const AssetImage('assets/images/app_logo.png'), context);
    precacheImage(const AssetImage('assets/images/bpi_icon.png'), context);
  }

  void _startSequence() async {
    // Phase 1: White screen with icon (3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _phase = 2);

    // Phase 2: Red patterned screen (3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Phase 2 (Bottom layer, fades in)
          IgnorePointer(
            ignoring: _phase == 1,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _phase == 2 ? 1.0 : 0.0,
              curve: Curves.easeOut,
              child: _buildPhase2(),
            ),
          ),
          // Phase 1 (Top layer, fades out)
          IgnorePointer(
            ignoring: _phase == 2,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _phase == 1 ? 1.0 : 0.0,
              curve: Curves.easeIn,
              child: _buildPhase1(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase1() {
    return Container(
      key: const ValueKey(1),
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildPhase2() {
    return SizedBox.expand(
      key: const ValueKey(2),
      child: Stack(
        children: [
          // Pattern Background
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: BPIPatternPainter(),
              ),
            ),
          ),
          // Logo and Regulatory
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  // Bank Name as Text (BPI) - Matches User Request
                  Text(
                    'BPI',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 100,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -4,
                    ),
                  ),
                  const Spacer(flex: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        // BPI Icon (Gold Crest) - Matches Screenshot
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, bottom: 20),
                            child: Image.asset(
                              'assets/images/bpi_icon.png',
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error_outline, color: Colors.white24, size: 20),
                            ),
                          ),
                        ),
                        _buildRegulatoryText('Deposits are insured by PDIC up to P1 Million per depositor.'),
                        _buildRegulatoryText('For inquiries and comments please send us a message through'),
                        _buildRegulatoryText('www.bpi.com.ph/about-bpi/contact-us or call our 24-hour BPI Contact Center at'),
                        _buildRegulatoryText('(+632) 889-10000.', isBold: true),
                        const SizedBox(height: 15),
                        _buildRegulatoryText('BPI is a proud member of BancNet.'),
                        _buildRegulatoryText('BPI is regulated by the Bangko Sentral ng Pilipinas. https://www.bsp.gov.ph'),
                        const SizedBox(height: 20),
                        _buildRegulatoryText('Copyright © 2023 BPI. All rights reserved.'),
                        const SizedBox(height: 10),
                        _buildRegulatoryText('v17.1 (171) TECNO TECNO CL6 (15)'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegulatoryText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 10,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class BPIPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.bpiRed
      ..style = PaintingStyle.fill;

    // Background base
    canvas.drawRect(Offset.zero & size, paint);

    // Overlay shapes for the "woven" look
    final patternPaint = Paint()
      ..color = const Color(0xFFB71C1C).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    double barWidth = 60;
    double spacing = 120;
    double angle = 0.8; // 45 degrees approx

    canvas.save();
    canvas.rotate(-angle);
    
    // Draw diagonal bars
    for (double i = -size.height; i < size.width * 2; i += spacing) {
      canvas.drawRect(Rect.fromLTWH(i, -size.height, barWidth, size.height * 3), patternPaint);
    }
    
    canvas.restore();
    
    // Draw cross diagonals for the woven effect
    final crossPaint = Paint()
      ..color = const Color(0xFFD32F2F).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
      
    canvas.save();
    canvas.rotate(angle);
    for (double i = -size.width; i < size.width * 2; i += spacing * 1.5) {
      canvas.drawRect(Rect.fromLTWH(i, -size.height, barWidth * 0.8, size.height * 3), crossPaint);
    }
    canvas.restore();
    
    // Gradient overlay matching Image 1
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.2),
        Colors.transparent,
        Colors.black.withValues(alpha: 0.5),
      ],
    );
    
    canvas.drawRect(Offset.zero & size, Paint()..shader = gradient.createShader(Offset.zero & size));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
