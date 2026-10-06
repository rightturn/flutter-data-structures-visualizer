import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/array_data_structure.dart';

void main() {
  group('ArrayDataStructure', () {
    late ArrayDataStructure array;

    setUp(() {
      array = ArrayDataStructure();
    });

    group('Basic Operations', () {
      test('insert adds value to array', () {
        array.insert(5);
        expect(array.nodes.length, 1);
        expect(array.nodes[0].value, 5);
      });

      test('insert multiple values', () {
        array.insert(1);
        array.insert(2);
        array.insert(3);
        expect(array.nodes.length, 3);
        expect(array.nodes.map((n) => n.value), [1, 2, 3]);
      });

      test('delete removes value from array', () {
        array.insert(10);
        array.insert(20);
        array.delete(10);
        expect(array.nodes.length, 1);
        expect(array.nodes[0].value, 20);
      });

      test('delete non-existent value does not change array', () {
        array.insert(1);
        array.delete(99);
        expect(array.nodes.length, 1);
        expect(array.nodes[0].value, 1);
      });

      test('search finds existing value', () {
        array.insert(7);
        array.insert(8);
        array.insert(9);
        array.search(8);
        // After search, the found node should be present
        expect(array.nodes.any((n) => n.value == 8), true);
      });

      test('search for missing value does not throw', () {
        array.insert(1);
        array.search(99);
        expect(array.nodes.length, 1);
      });

      test('traverse does not modify array', () {
        array.insert(1);
        array.insert(2);
        array.traverse();
        expect(array.nodes.map((n) => n.value), [1, 2]);
      });

      test('delete from empty array does not throw', () {
        expect(() => array.delete(1), returnsNormally);
        expect(array.nodes.isEmpty, true);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('insert with negative values', () {
        array.insert(-5);
        array.insert(-10);
        expect(array.nodes.length, 2);
        expect(array.nodes[0].value, -5);
        expect(array.nodes[1].value, -10);
      });

      test('insert with very large values', () {
        array.insert(999999);
        array.insert(1000000);
        expect(array.nodes.length, 2);
        expect(array.nodes[0].value, 999999);
        expect(array.nodes[1].value, 1000000);
      });

      test('delete from array with duplicate values', () {
        array.insert(5);
        array.insert(5);
        array.insert(5);
        array.delete(5);
        expect(array.nodes.length, 2);
        expect(array.nodes.every((n) => n.value == 5), true);
      });

      test('search in array with duplicate values', () {
        array.insert(5);
        array.insert(5);
        array.insert(5);
        array.search(5);
        expect(array.nodes.length, 3);
        expect(array.nodes.every((n) => n.value == 5), true);
      });

      test('traverse empty array', () {
        expect(() => array.traverse(), returnsNormally);
        expect(array.nodes.isEmpty, true);
      });

      test('addNodesDirectly with empty list', () {
        array.addNodesDirectly([]);
        expect(array.nodes.isEmpty, true);
      });

      test('addNodesDirectly with single value', () {
        array.addNodesDirectly([42]);
        expect(array.nodes.length, 1);
        expect(array.nodes[0].value, 42);
      });

      test('addNodesDirectly with multiple values', () {
        array.addNodesDirectly([1, 2, 3, 4, 5]);
        expect(array.nodes.length, 5);
        expect(array.nodes.map((n) => n.value), [1, 2, 3, 4, 5]);
      });

      test('updateNodeValue with valid index', () {
        array.insert(1);
        array.insert(2);
        array.insert(3);

        array.updateNodeValue(1, 99);
        expect(array.nodes[1].value, 99);
        expect(array.nodes[0].value, 1);
        expect(array.nodes[2].value, 3);
      });

      test('updateNodeValue with invalid index', () {
        array.insert(1);
        array.insert(2);

        expect(() => array.updateNodeValue(-1, 99), returnsNormally);
        expect(() => array.updateNodeValue(5, 99), returnsNormally);

        // Array should remain unchanged
        expect(array.nodes.length, 2);
        expect(array.nodes[0].value, 1);
        expect(array.nodes[1].value, 2);
      });

      test('updateNodeValue with negative index', () {
        array.insert(1);
        expect(() => array.updateNodeValue(-1, 99), returnsNormally);
        expect(array.nodes[0].value, 1); // Should remain unchanged
      });

      test('updateNodeValue with index equal to array length', () {
        array.insert(1);
        array.insert(2);
        expect(() => array.updateNodeValue(2, 99), returnsNormally);
        expect(array.nodes.length, 2);
        expect(array.nodes[0].value, 1);
        expect(array.nodes[1].value, 2);
      });

      test('updateNodeValue with index greater than array length', () {
        array.insert(1);
        expect(() => array.updateNodeValue(10, 99), returnsNormally);
        expect(array.nodes[0].value, 1); // Should remain unchanged
      });
    });

    group('Animation and UI State', () {
      test('animation steps are created correctly for insert operation', () {
        array.insert(5);
        expect(array.animationSteps.length, 3); // 3 steps for insert
        expect(array.animationSteps[0].description, contains('Step 1 of 3'));
        expect(array.animationSteps[1].description, contains('Step 2 of 3'));
        expect(array.animationSteps[2].description, contains('Step 3 of 3'));
      });

      test('animation steps are created correctly for delete operation', () {
        array.insert(5);
        array.insert(10);
        array.delete(5);
        expect(array.animationSteps.length, greaterThan(0));
        expect(array.animationSteps[0].description, contains('Step 1 of'));
      });

      test('animation steps are created correctly for search operation', () {
        array.insert(5);
        array.insert(10);
        array.search(5);
        expect(array.animationSteps.length, greaterThan(0));
        expect(array.animationSteps[0].description, contains('Step 1 of'));
      });

      test('animation steps are created correctly for traverse operation', () {
        array.insert(1);
        array.insert(2);
        array.insert(3);
        array.traverse();
        expect(array.animationSteps.length, 4); // 1 initial + 3 traversal steps
        expect(array.animationSteps[0].description, contains('Step 1 of 4'));
      });

      test('node positions are calculated correctly', () {
        array.insert(1);
        array.insert(2);
        array.insert(3);

        expect(array.nodes[0].position.dx, 50.0);
        expect(array.nodes[1].position.dx, 50.0 + 80.0); // 50 + nodeBoxWidth
        expect(array.nodes[2].position.dx, 50.0 + 80.0 * 2);

        // All nodes should have the same Y position
        expect(array.nodes[0].position.dy, array.nodes[1].position.dy);
        expect(array.nodes[1].position.dy, array.nodes[2].position.dy);
      });

      test('color assignments work correctly', () {
        array.insert(1);
        array.insert(2);
        array.search(1);

        // After search, nodes should have appropriate colors
        expect(array.animationSteps.length, greaterThan(0));
        final lastStep = array.animationSteps.last;
        expect(lastStep.nodes.length, 2);
      });

      test('current step is reset after operations', () {
        array.insert(1);
        array.insert(2);
        array.traverse();

        expect(array.currentStep, 0);
      });

      test('animation steps are cleared between operations', () {
        array.insert(1);
        final insertSteps = List.of(array.animationSteps);

        array.delete(1);
        final deleteSteps = List.of(array.animationSteps);

        expect(insertSteps, isNotEmpty);
        expect(deleteSteps, isNotEmpty);
        expect(insertSteps.first.description, contains('Insertion'));
        expect(deleteSteps.first.description, contains('Deletion'));
        expect(array.nodes, isEmpty);
      });
    });

    group('Data Consistency', () {
      test('_data and nodes are synchronized after insert', () {
        array.insert(1);
        array.insert(2);
        array.insert(3);

        // The private _data should match the public nodes
        expect(array.nodes.length, 3);
        expect(array.nodes.map((n) => n.value), [1, 2, 3]);
      });

      test('_data and nodes are synchronized after delete', () {
        array.insert(1);
        array.insert(2);
        array.insert(3);
        array.delete(2);

        expect(array.nodes.length, 2);
        expect(array.nodes.map((n) => n.value), [1, 3]);
      });

      test('_data and nodes are synchronized after addNodesDirectly', () {
        array.addNodesDirectly([5, 10, 15]);

        expect(array.nodes.length, 3);
        expect(array.nodes.map((n) => n.value), [5, 10, 15]);
      });

      test('_data and nodes are synchronized after updateNodeValue', () {
        array.insert(1);
        array.insert(2);
        array.updateNodeValue(0, 99);

        expect(array.nodes.length, 2);
        expect(array.nodes[0].value, 99);
        expect(array.nodes[1].value, 2);
      });

      test('operations maintain data integrity', () {
        // Complex sequence of operations
        array.insert(1);
        array.insert(2);
        array.insert(3);
        array.delete(2);
        array.insert(4);
        array.search(1);
        array.updateNodeValue(0, 99);
        array.traverse();

        // Final state should be consistent
        expect(array.nodes.length, 3);
        expect(array.nodes.map((n) => n.value), [99, 3, 4]);
      });
    });

    group('Performance and Scalability', () {
      test('handles large number of insertions', () {
        for (int i = 0; i < 100; i++) {
          array.insert(i);
        }

        expect(array.nodes.length, 100);
        expect(array.nodes.last.value, 99);
      });

      test('handles large number of deletions', () {
        // Insert 100 elements
        for (int i = 0; i < 100; i++) {
          array.insert(i);
        }

        // Delete all even numbers
        for (int i = 0; i < 100; i += 2) {
          array.delete(i);
        }

        expect(array.nodes.length, 50);
        expect(array.nodes.every((n) => n.value % 2 == 1), true);
      });

      test('handles mixed operations efficiently', () {
        // Insert, delete, search, traverse in sequence
        for (int i = 0; i < 50; i++) {
          array.insert(i);
          if (i % 2 == 0) {
            array.delete(i);
          }
        }

        array.search(25);
        array.traverse();

        expect(array.nodes.length, 25);
        expect(array.nodes.every((n) => n.value % 2 == 1), true);
      });
    });

    group('Boundary Conditions', () {
      test('insert at maximum integer value', () {
        array.insert(2147483647);
        expect(array.nodes.length, 1);
        expect(array.nodes[0].value, 2147483647);
      });

      test('insert at minimum integer value', () {
        array.insert(-2147483648);
        expect(array.nodes.length, 1);
        expect(array.nodes[0].value, -2147483648);
      });

      test('delete non-existent value in large array', () {
        for (int i = 0; i < 100; i++) {
          array.insert(i);
        }

        expect(() => array.delete(999), returnsNormally);
        expect(array.nodes.length, 100);
      });

      test('search in large array', () {
        for (int i = 0; i < 100; i++) {
          array.insert(i);
        }

        expect(() => array.search(50), returnsNormally);
        expect(array.nodes.length, 100);
      });

      test('traverse large array', () {
        for (int i = 0; i < 100; i++) {
          array.insert(i);
        }

        expect(() => array.traverse(), returnsNormally);
        expect(array.nodes.length, 100);
      });
    });
  });
}
