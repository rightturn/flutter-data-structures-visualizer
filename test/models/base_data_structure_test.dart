import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:data_structures/models/base_data_structure.dart';
import 'package:data_structures/models/animation_step.dart';
import 'package:data_structures/models/data_structure_node.dart';

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
  group('BaseDataStructure', () {
    late MockDataStructure dataStructure;

    setUp(() {
      dataStructure = MockDataStructure();
    });

    group('Animation Steps Management', () {
      test('clearAnimationSteps removes all animation steps', () {
        // Add some animation steps
        dataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step 1',
            code: 'test1',
            nodes: [],
            highlightedLine: 1,
          ),
        );
        dataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step 2',
            code: 'test2',
            nodes: [],
            highlightedLine: 2,
          ),
        );

        expect(dataStructure.animationSteps.length, 2);

        dataStructure.clearAnimationSteps();
        expect(dataStructure.animationSteps.length, 0);
      });

      test('addAnimationStep adds step to animation list', () {
        final step = AnimationStep(
          description: 'Test step',
          code: 'test',
          nodes: [],
          highlightedLine: 1,
        );

        dataStructure.addAnimationStep(step);
        expect(dataStructure.animationSteps.length, 1);
        expect(dataStructure.animationSteps.first, step);
      });

      test('addAnimationStep with multiple steps maintains order', () {
        final step1 = AnimationStep(
          description: 'Step 1',
          code: 'step1',
          nodes: [],
          highlightedLine: 1,
        );
        final step2 = AnimationStep(
          description: 'Step 2',
          code: 'step2',
          nodes: [],
          highlightedLine: 2,
        );

        dataStructure.addAnimationStep(step1);
        dataStructure.addAnimationStep(step2);

        expect(dataStructure.animationSteps.length, 2);
        expect(dataStructure.animationSteps[0], step1);
        expect(dataStructure.animationSteps[1], step2);
      });
    });

    group('Step Navigation', () {
      test('goToStep updates current step correctly', () {
        // Add animation steps
        for (int i = 0; i < 3; i++) {
          dataStructure.addAnimationStep(
            AnimationStep(
              description: 'Step $i',
              code: 'step$i',
              nodes: [],
              highlightedLine: i + 1,
            ),
          );
        }

        dataStructure.goToStep(1);
        expect(dataStructure.currentStep, 1);
      });

      test('goToStep with invalid step handles gracefully', () {
        // Add one animation step
        dataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );

        // Try to go to invalid steps
        expect(() => dataStructure.goToStep(-1), returnsNormally);
        expect(() => dataStructure.goToStep(5), returnsNormally);

        // Should stay at valid step
        expect(dataStructure.currentStep, 0);
      });

      test('goToStep with empty animation steps', () {
        expect(() => dataStructure.goToStep(0), returnsNormally);
        expect(dataStructure.currentStep, 0);
      });
    });

    group('Node Management', () {
      test('setNodes updates nodes list correctly', () {
        final testNodes = [
          DataStructureNode(value: 1, position: const Offset(0, 0)),
          DataStructureNode(value: 2, position: const Offset(50, 0)),
        ];

        dataStructure.setNodes(testNodes);
        expect(dataStructure.nodes.length, 2);
        expect(dataStructure.nodes[0].value, 1);
        expect(dataStructure.nodes[1].value, 2);
      });

      test('setNodes with empty list', () {
        dataStructure.setNodes([]);
        expect(dataStructure.nodes.isEmpty, true);
      });

      test('updateNodes with no animation steps', () {
        expect(() => dataStructure.updateNodes(), returnsNormally);
      });

      test('updateNodes with animation steps', () {
        final testNodes = [
          DataStructureNode(value: 1, position: const Offset(0, 0)),
        ];
        dataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: testNodes,
            highlightedLine: 1,
          ),
        );

        dataStructure.updateNodes();
        expect(dataStructure.nodes.length, 1);
        expect(dataStructure.nodes[0].value, 1);
      });
    });

    group('Reset Functionality', () {
      test('resetToDefault clears animation and resets step', () {
        // Add animation steps and change current step
        dataStructure.addAnimationStep(
          AnimationStep(
            description: 'Test step',
            code: 'test',
            nodes: [],
            highlightedLine: 1,
          ),
        );
        dataStructure.goToStep(0);

        dataStructure.resetToDefault();
        expect(dataStructure.animationSteps.isEmpty, true);
        expect(dataStructure.currentStep, 0);
      });

      test('resetToDefault with existing nodes preserves them', () {
        final testNodes = [
          DataStructureNode(value: 1, position: const Offset(0, 0)),
        ];
        dataStructure.setNodes(testNodes);

        dataStructure.resetToDefault();
        expect(dataStructure.nodes.length, 1);
        expect(dataStructure.nodes[0].value, 1);
      });
    });

    group('Initial State', () {
      test('initial state is correct', () {
        expect(dataStructure.nodes.isEmpty, true);
        expect(dataStructure.animationSteps.isEmpty, true);
        expect(dataStructure.currentStep, 0);
      });
    });
  });
}
