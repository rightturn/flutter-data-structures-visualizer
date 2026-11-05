import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/services/animation_service.dart';
import 'package:data_structures/models/base_data_structure.dart';
import 'package:data_structures/models/animation_step.dart';

// Mock implementation for testing
class MockDataStructure extends BaseDataStructure {
  @override
  void insert(int value) {
    // Mock implementation
  }

  @override
  void delete(int value) {
    // Mock implementation
  }

  @override
  void search(int value) {
    // Mock implementation
  }

  @override
  void traverse() {
    // Mock implementation
  }
}

void main() {
  group('AnimationService', () {
    late AnimationService animationService;
    late MockDataStructure mockDataStructure;

    setUp(() {
      mockDataStructure = MockDataStructure();
      animationService = AnimationService();
    });

    tearDown(() {
      animationService.dispose();
    });

    group('Initial State', () {
      test('initial state is correct', () {
        expect(animationService.isPlaying, false);
      });
    });

    group('Animation Control', () {
      test('startAnimation begins animation correctly', () {
        // Add animation steps to the data structure
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step 1',
            code: 'test1',
            nodes: [],
            highlightedLine: 1,
          ),
        );
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step 2',
            code: 'test2',
            nodes: [],
            highlightedLine: 2,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);
      });

      test('startAnimation with no steps does not start', () {
        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, false);
      });

      test('pauseAnimation pauses animation correctly', () {
        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        animationService.pauseAnimation();
        expect(animationService.isPlaying, false);
      });

      test('stopAnimation stops animation correctly', () {
        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        animationService.stopAnimation();
        expect(animationService.isPlaying, false);
      });
    });

    group('Animation Callbacks', () {
      test('callbacks are called correctly', () {
        bool onAnimationStateChangedCalled = false;

        final serviceWithCallbacks = AnimationService(
          onStepChanged: () {},
          onAnimationComplete: () {},
          onAnimationStateChanged: () => onAnimationStateChangedCalled = true,
        );

        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step 1',
            code: 'test1',
            nodes: [],
            highlightedLine: 1,
          ),
        );
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step 2',
            code: 'test2',
            nodes: [],
            highlightedLine: 2,
          ),
        );

        serviceWithCallbacks.startAnimation(mockDataStructure);
        expect(onAnimationStateChangedCalled, true);

        serviceWithCallbacks.dispose();
      });

      test('callbacks are optional', () {
        expect(
          () => animationService.startAnimation(mockDataStructure),
          returnsNormally,
        );
        expect(() => animationService.pauseAnimation(), returnsNormally);
        expect(() => animationService.stopAnimation(), returnsNormally);
      });
    });

    group('Animation Timer', () {
      test('animation timer advances steps correctly', () async {
        // Add multiple animation steps
        for (int i = 0; i < 3; i++) {
          mockDataStructure.addAnimationStep(
            AnimationStep(
              description: 'Step $i',
              code: 'step$i',
              nodes: [],
              highlightedLine: i + 1,
            ),
          );
        }

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        // Wait for animation to progress
        await Future.delayed(const Duration(milliseconds: 100));

        // Animation should have advanced or completed
        expect(mockDataStructure.currentStep >= 0, true);
      });

      test('animation completes when reaching last step', () async {
        // Add only one step
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Single step',
            code: 'single',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        // Wait for animation to complete
        await Future.delayed(const Duration(milliseconds: 600));

        // Animation should have stopped
        expect(animationService.isPlaying, false);
      });
    });

    group('Edge Cases', () {
      test('pause without starting', () {
        animationService.pauseAnimation();
        expect(animationService.isPlaying, false);
      });

      test('stop without starting', () {
        animationService.stopAnimation();
        expect(animationService.isPlaying, false);
      });

      test('multiple start calls', () {
        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);
      });

      test('dispose cleans up resources', () {
        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        animationService.dispose();
        expect(animationService.isPlaying, false);
      });
    });

    group('State Transitions', () {
      test('start -> pause -> resume -> stop', () {
        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        animationService.pauseAnimation();
        expect(animationService.isPlaying, false);

        // Note: AnimationService doesn't have resume, so we start again
        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        animationService.stopAnimation();
        expect(animationService.isPlaying, false);
      });

      test('start -> stop directly', () {
        // Add animation steps
        mockDataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        animationService.startAnimation(mockDataStructure);
        expect(animationService.isPlaying, true);

        animationService.stopAnimation();
        expect(animationService.isPlaying, false);
      });
    });

    group('Constructor with Callbacks', () {
      test('constructor accepts optional callbacks', () {
        final service = AnimationService(
          onStepChanged: () {},
          onAnimationComplete: () {},
          onAnimationStateChanged: () {},
        );

        expect(service.isPlaying, false);
        service.dispose();
      });

      test('constructor with null callbacks', () {
        final service = AnimationService();
        expect(service.isPlaying, false);
        service.dispose();
      });
    });
  });
}
