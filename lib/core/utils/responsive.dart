import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    // Use 390 as reference width (iPhone 13/14)
    scaleFactor = screenWidth / 390;
    
    // Cap the scale factor to prevent extreme scaling on tablets
    if (scaleFactor > 1.2) scaleFactor = 1.2;
    if (scaleFactor < 0.8) scaleFactor = 0.8;
  }

  static double scale(double size) {
    return size * scaleFactor;
  }
  
  static double sp(double size) {
    return size * scaleFactor;
  }
}

extension ResponsiveExtension on num {
  double get s => Responsive.scale(toDouble());
  double get sp => Responsive.sp(toDouble());
}
