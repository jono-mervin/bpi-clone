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
    // Use 430 as reference width (iPhone 14 Pro Max) and apply a 0.85x multiplier for a more compact UI
    scaleFactor = (screenWidth / 430) * 0.95;
    
    // Cap the scale factor to prevent extreme scaling
    if (scaleFactor > 1.0) scaleFactor = 1.0;
    if (scaleFactor < 0.65) scaleFactor = 0.65;
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
