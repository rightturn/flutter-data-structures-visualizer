import 'package:flutter/material.dart';

class AppConstants {
  // Animation
  static const Duration animationDuration = Duration(milliseconds: 500);
  static const Duration stepDuration = Duration(milliseconds: 1000);
  static const Duration scrollDuration = Duration(milliseconds: 300);

  // UI Dimensions
  static const double nodeBoxWidth = 80.0;
  static const double nodeBoxHeight = 40.0;
  static const double nodeSpacing = 0.0; // No spacing for continuous block
  static const double minCanvasHeight = 300.0;
  static const double nodeStartY = 40.0;
  static const double nodeBorderWidth = 2.0;
  static const double nodeBorderRadius = 8.0;

  // Colors
  static const Color defaultNodeColor = Colors.grey;
  static const Color currentNodeColor = Colors.blue;
  static const Color foundNodeColor = Colors.green;
  static const Color checkedNodeColor = Colors.red;
  static const Color insertionNodeColor = Colors.orange;

  // Text Styles
  static const double nodeTextSize = 18.0;
  static const FontWeight nodeTextWeight = FontWeight.bold;

  // Scroll
  static const double scrollTargetRatio = 0.75; // Show node at 75% from bottom

  // Dialog
  static const double dialogWidth = 300.0;
  static const double dialogHeight = 200.0;

  // Random Data Generation
  static const int defaultNodeCount = 8;
  static const int minNodeValue = 1;
  static const int maxNodeValue = 100;
}

class AnimationColors {
  static const Color current = Colors.blue;
  static const Color found = Colors.green;
  static const Color checked = Colors.red;
  static const Color unvisited = Colors.grey;
  static const Color insertion = Colors.orange;
}
