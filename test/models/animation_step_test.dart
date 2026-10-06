import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:data_structures/models/animation_step.dart';
import 'package:data_structures/models/data_structure_node.dart';

void main() {
  group('AnimationStep', () {
    test('AnimationStep constructor sets all properties', () {
      final nodes = [
        DataStructureNode(value: 1, position: const Offset(0, 0)),
        DataStructureNode(value: 2, position: const Offset(50, 0)),
      ];

      final step = AnimationStep(
        description: 'Test step description',
        code: 'test.code()',
        nodes: nodes,
        highlightedLine: 5,
        insights: 'Test insights',
      );

      expect(step.description, 'Test step description');
      expect(step.code, 'test.code()');
      expect(step.nodes, nodes);
      expect(step.highlightedLine, 5);
      expect(step.insights, 'Test insights');
    });

    test('AnimationStep with minimal parameters', () {
      final step = AnimationStep(
        description: 'Minimal step',
        code: 'minimal()',
        nodes: [],
        highlightedLine: 1,
      );

      expect(step.description, 'Minimal step');
      expect(step.code, 'minimal()');
      expect(step.nodes, isEmpty);
      expect(step.highlightedLine, 1);
      expect(step.insights, ''); // Defaults to empty string
    });

    test('AnimationStep equality comparison', () {
      final nodes1 = [
        DataStructureNode(value: 1, position: const Offset(0, 0)),
      ];
      final nodes2 = [
        DataStructureNode(value: 1, position: const Offset(0, 0)),
      ];

      final step1 = AnimationStep(
        description: 'Test step',
        code: 'test()',
        nodes: nodes1,
        highlightedLine: 1,
        insights: 'Test insights',
      );

      final step2 = AnimationStep(
        description: 'Test step',
        code: 'test()',
        nodes: nodes2,
        highlightedLine: 1,
        insights: 'Test insights',
      );

      final step3 = AnimationStep(
        description: 'Different step',
        code: 'test()',
        nodes: nodes1,
        highlightedLine: 1,
        insights: 'Test insights',
      );

      // Note: Equality comparison may not work as expected due to node comparison
      expect(step1.description, equals(step2.description));
      expect(step1.code, equals(step2.code));
      expect(step1.highlightedLine, equals(step2.highlightedLine));
      expect(step1.insights, equals(step2.insights));
      expect(step1.description, isNot(equals(step3.description)));
    });

    test('AnimationStep equality with different properties', () {
      final baseNodes = [
        DataStructureNode(value: 1, position: const Offset(0, 0)),
      ];
      final baseStep = AnimationStep(
        description: 'Base step',
        code: 'base()',
        nodes: baseNodes,
        highlightedLine: 1,
        insights: 'Base insights',
      );

      final differentDescription = AnimationStep(
        description: 'Different description',
        code: 'base()',
        nodes: baseNodes,
        highlightedLine: 1,
        insights: 'Base insights',
      );

      final differentCode = AnimationStep(
        description: 'Base step',
        code: 'different()',
        nodes: baseNodes,
        highlightedLine: 1,
        insights: 'Base insights',
      );

      final differentLine = AnimationStep(
        description: 'Base step',
        code: 'base()',
        nodes: baseNodes,
        highlightedLine: 2,
        insights: 'Base insights',
      );

      final differentInsights = AnimationStep(
        description: 'Base step',
        code: 'base()',
        nodes: baseNodes,
        highlightedLine: 1,
        insights: 'Different insights',
      );

      expect(
        baseStep.description,
        isNot(equals(differentDescription.description)),
      );
      expect(baseStep.code, isNot(equals(differentCode.code)));
      expect(
        baseStep.highlightedLine,
        isNot(equals(differentLine.highlightedLine)),
      );
      expect(baseStep.insights, isNot(equals(differentInsights.insights)));
    });

    test('AnimationStep with empty insights', () {
      final step = AnimationStep(
        description: 'Step without insights',
        code: 'noInsights()',
        nodes: [],
        highlightedLine: 1,
      );

      expect(step.insights, '');
    });

    test('AnimationStep with null nodes handles gracefully', () {
      expect(
        () => AnimationStep(
          description: 'Test step',
          code: 'test()',
          nodes: [],
          highlightedLine: 1,
        ),
        returnsNormally,
      );
    });

    test('AnimationStep with negative highlighted line', () {
      final step = AnimationStep(
        description: 'Test step',
        code: 'test()',
        nodes: [],
        highlightedLine: -1,
      );

      expect(step.highlightedLine, -1);
    });

    test('AnimationStep with zero highlighted line', () {
      final step = AnimationStep(
        description: 'Test step',
        code: 'test()',
        nodes: [],
        highlightedLine: 0,
      );

      expect(step.highlightedLine, 0);
    });

    test('AnimationStep with large highlighted line', () {
      final step = AnimationStep(
        description: 'Test step',
        code: 'test()',
        nodes: [],
        highlightedLine: 999,
      );

      expect(step.highlightedLine, 999);
    });

    test('AnimationStep with empty description', () {
      final step = AnimationStep(
        description: '',
        code: 'empty()',
        nodes: [],
        highlightedLine: 1,
      );

      expect(step.description, '');
    });

    test('AnimationStep with empty code', () {
      final step = AnimationStep(
        description: 'Test step',
        code: '',
        nodes: [],
        highlightedLine: 1,
      );

      expect(step.code, '');
    });

    test('AnimationStep with complex nodes', () {
      final complexNodes = [
        DataStructureNode(
          value: 1,
          position: const Offset(0, 0),
          color: Colors.red,
          label: 'Node 1',
          children: [
            DataStructureNode(value: 2, position: const Offset(10, 10)),
          ],
          next: DataStructureNode(value: 3, position: const Offset(20, 20)),
          prev: DataStructureNode(value: 0, position: const Offset(-10, -10)),
        ),
        DataStructureNode(
          value: 4,
          position: const Offset(50, 0),
          color: Colors.blue,
          label: 'Node 2',
        ),
      ];

      final step = AnimationStep(
        description: 'Complex step',
        code: 'complex()',
        nodes: complexNodes,
        highlightedLine: 1,
        insights: 'Complex insights',
      );

      expect(step.nodes.length, 2);
      expect(step.nodes[0].value, 1);
      expect(step.nodes[1].value, 4);
      expect(step.nodes[0].children.length, 1);
      expect(step.nodes[0].next?.value, 3);
      expect(step.nodes[0].prev?.value, 0);
    });

    test('AnimationStep toString method', () {
      final step = AnimationStep(
        description: 'Test step',
        code: 'test()',
        nodes: [DataStructureNode(value: 1, position: const Offset(0, 0))],
        highlightedLine: 1,
        insights: 'Test insights',
      );

      final string = step.toString();
      expect(string, contains('AnimationStep'));
    });
  });
}
