import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:data_structures/utils/constants.dart';

void main() {
  group('AppConstants', () {
    group('Node Dimensions', () {
      test('nodeBoxWidth is positive and reasonable', () {
        expect(AppConstants.nodeBoxWidth, greaterThan(0));
        expect(
          AppConstants.nodeBoxWidth,
          lessThan(200),
        ); // Reasonable max width
      });

      test('nodeBoxHeight is positive and reasonable', () {
        expect(AppConstants.nodeBoxHeight, greaterThan(0));
        expect(
          AppConstants.nodeBoxHeight,
          lessThan(200),
        ); // Reasonable max height
      });

      test('nodeSpacing is non-negative', () {
        expect(AppConstants.nodeSpacing, greaterThanOrEqualTo(0));
      });

      test('nodeStartY is reasonable', () {
        expect(AppConstants.nodeStartY, greaterThanOrEqualTo(0));
        expect(AppConstants.nodeStartY, lessThan(1000)); // Reasonable max Y
      });
    });

    group('Canvas Dimensions', () {
      test('minCanvasHeight is positive', () {
        expect(AppConstants.minCanvasHeight, greaterThan(0));
      });

      test('nodeBorderWidth is positive', () {
        expect(AppConstants.nodeBorderWidth, greaterThan(0));
      });

      test('nodeBorderRadius is positive', () {
        expect(AppConstants.nodeBorderRadius, greaterThan(0));
      });
    });

    group('Animation Timing', () {
      test('stepDuration is positive', () {
        expect(AppConstants.stepDuration.inMilliseconds, greaterThan(0));
      });

      test('stepDuration is reasonable', () {
        expect(
          AppConstants.stepDuration.inMilliseconds,
          lessThan(10000),
        ); // Max 10 seconds
      });

      test('scrollDuration is positive', () {
        expect(AppConstants.scrollDuration.inMilliseconds, greaterThan(0));
      });

      test('scrollDuration is reasonable', () {
        expect(
          AppConstants.scrollDuration.inMilliseconds,
          lessThan(5000),
        ); // Max 5 seconds
      });

      test('animationDuration is positive', () {
        expect(AppConstants.animationDuration.inMilliseconds, greaterThan(0));
      });

      test('animationDuration is reasonable', () {
        expect(
          AppConstants.animationDuration.inMilliseconds,
          lessThan(5000),
        ); // Max 5 seconds
      });
    });

    group('Scroll Behavior', () {
      test('scrollTargetRatio is between 0 and 1', () {
        expect(AppConstants.scrollTargetRatio, greaterThan(0));
        expect(AppConstants.scrollTargetRatio, lessThan(1));
      });

      test('scrollTargetRatio is reasonable', () {
        expect(AppConstants.scrollTargetRatio, greaterThan(0.1));
        expect(AppConstants.scrollTargetRatio, lessThan(0.9));
      });
    });

    group('Node Colors', () {
      test('defaultNodeColor is valid Color', () {
        expect(AppConstants.defaultNodeColor, isA<Color>());
      });

      test('insertionNodeColor is valid Color', () {
        expect(AppConstants.insertionNodeColor, isA<Color>());
      });

      test('foundNodeColor is valid Color', () {
        expect(AppConstants.foundNodeColor, isA<Color>());
      });

      test('currentNodeColor is valid Color', () {
        expect(AppConstants.currentNodeColor, isA<Color>());
      });

      test('checkedNodeColor is valid Color', () {
        expect(AppConstants.checkedNodeColor, isA<Color>());
      });
    });

    group('Color Consistency', () {
      test('all node colors are different', () {
        final colors = [
          AppConstants.defaultNodeColor,
          AppConstants.insertionNodeColor,
          AppConstants.foundNodeColor,
          AppConstants.currentNodeColor,
          AppConstants.checkedNodeColor,
        ];

        final uniqueColors = colors.toSet();
        expect(uniqueColors.length, colors.length);
      });

      test('node colors are not null', () {
        expect(AppConstants.defaultNodeColor, isNotNull);
        expect(AppConstants.insertionNodeColor, isNotNull);
        expect(AppConstants.foundNodeColor, isNotNull);
        expect(AppConstants.currentNodeColor, isNotNull);
        expect(AppConstants.checkedNodeColor, isNotNull);
      });
    });

    group('Text Styles', () {
      test('nodeTextSize is positive', () {
        expect(AppConstants.nodeTextSize, greaterThan(0));
      });

      test('nodeTextWeight is valid', () {
        expect(AppConstants.nodeTextWeight, isA<FontWeight>());
      });
    });

    group('Dialog Dimensions', () {
      test('dialogWidth is positive', () {
        expect(AppConstants.dialogWidth, greaterThan(0));
      });

      test('dialogHeight is positive', () {
        expect(AppConstants.dialogHeight, greaterThan(0));
      });
    });

    group('Random Data Generation', () {
      test('defaultNodeCount is positive', () {
        expect(AppConstants.defaultNodeCount, greaterThan(0));
      });

      test('minNodeValue is less than maxNodeValue', () {
        expect(AppConstants.minNodeValue, lessThan(AppConstants.maxNodeValue));
      });

      test('minNodeValue is positive', () {
        expect(AppConstants.minNodeValue, greaterThan(0));
      });

      test('maxNodeValue is reasonable', () {
        expect(AppConstants.maxNodeValue, lessThan(10000)); // Reasonable max
      });
    });

    group('Layout Constraints', () {
      test('node dimensions are proportional', () {
        expect(
          AppConstants.nodeBoxWidth,
          greaterThan(AppConstants.nodeBoxHeight * 0.5),
        );
        expect(
          AppConstants.nodeBoxWidth,
          lessThan(AppConstants.nodeBoxHeight * 3),
        );
      });

      test('spacing is reasonable relative to node size', () {
        expect(
          AppConstants.nodeSpacing,
          lessThan(AppConstants.nodeBoxWidth * 2),
        );
        expect(
          AppConstants.nodeSpacing,
          lessThan(AppConstants.nodeBoxHeight * 2),
        );
      });

      test('canvas height is reasonable', () {
        expect(
          AppConstants.minCanvasHeight,
          greaterThan(AppConstants.nodeBoxHeight * 2),
        );
      });
    });

    group('Performance Constraints', () {
      test('animation duration is not too short', () {
        expect(
          AppConstants.animationDuration.inMilliseconds,
          greaterThan(100),
        ); // Min 100ms
      });

      test('animation duration is not too long', () {
        expect(
          AppConstants.animationDuration.inMilliseconds,
          lessThan(5000),
        ); // Max 5 seconds
      });

      test('scroll duration is reasonable', () {
        expect(AppConstants.scrollDuration.inMilliseconds, greaterThan(100));
        expect(AppConstants.scrollDuration.inMilliseconds, lessThan(3000));
      });
    });

    group('Edge Cases', () {
      test('constants handle zero values appropriately', () {
        // These should not be zero for proper functionality
        expect(AppConstants.nodeBoxWidth, isNot(0));
        expect(AppConstants.nodeBoxHeight, isNot(0));
        expect(AppConstants.stepDuration.inMilliseconds, isNot(0));
        expect(AppConstants.scrollDuration.inMilliseconds, isNot(0));
      });

      test('constants handle negative values appropriately', () {
        // These should not be negative
        expect(AppConstants.nodeBoxWidth, greaterThan(0));
        expect(AppConstants.nodeBoxHeight, greaterThan(0));
        expect(AppConstants.nodeSpacing, greaterThanOrEqualTo(0));
        expect(AppConstants.nodeStartY, greaterThanOrEqualTo(0));
        expect(AppConstants.minCanvasHeight, greaterThan(0));
        expect(AppConstants.nodeBorderWidth, greaterThan(0));
        expect(AppConstants.nodeBorderRadius, greaterThan(0));
      });
    });

    group('Integration Tests', () {
      test('node positioning calculations work correctly', () {
        final nodeWidth = AppConstants.nodeBoxWidth;
        final nodeHeight = AppConstants.nodeBoxHeight;
        final spacing = AppConstants.nodeSpacing;
        final startY = AppConstants.nodeStartY;

        // Test that positioning calculations would work
        final firstNodeY = startY;
        final secondNodeY = startY + nodeHeight + spacing;
        final thirdNodeY = startY + (nodeHeight + spacing) * 2;

        expect(firstNodeY, greaterThanOrEqualTo(0));
        expect(secondNodeY, greaterThan(firstNodeY));
        expect(thirdNodeY, greaterThan(secondNodeY));
      });

      test('canvas sizing calculations work correctly', () {
        final minHeight = AppConstants.minCanvasHeight;
        final nodeHeight = AppConstants.nodeBoxHeight;

        // Test that canvas can accommodate at least one node
        expect(minHeight, greaterThanOrEqualTo(nodeHeight * 2));
      });
    });
  });

  group('AnimationColors', () {
    test('all animation colors are valid', () {
      expect(AnimationColors.current, isA<Color>());
      expect(AnimationColors.found, isA<Color>());
      expect(AnimationColors.checked, isA<Color>());
      expect(AnimationColors.unvisited, isA<Color>());
      expect(AnimationColors.insertion, isA<Color>());
    });

    test('animation colors are different', () {
      final colors = [
        AnimationColors.current,
        AnimationColors.found,
        AnimationColors.checked,
        AnimationColors.unvisited,
        AnimationColors.insertion,
      ];

      final uniqueColors = colors.toSet();
      expect(uniqueColors.length, colors.length);
    });
  });
}
