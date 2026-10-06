import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/stack_data_structure.dart';

void main() {
  group('StackDataStructure', () {
    late StackDataStructure stack;

    setUp(() => stack = StackDataStructure());

    test('push and pop follow LIFO order', () {
      stack.insert(1);
      stack.insert(2);
      stack.insert(3);
      stack.pop();

      expect(stack.nodes.map((node) => node.value), [1, 2]);
    });

    test('peek does not mutate the stack', () {
      stack.addNodesDirectly([1, 2]);
      stack.peek();

      expect(stack.nodes.map((node) => node.value), [1, 2]);
      expect(stack.animationSteps.last.description, contains('Top value is 2'));
    });

    test('empty stack reports its state', () {
      expect(stack.isEmpty(), isTrue);
      stack.insert(1);
      expect(stack.isEmpty(), isFalse);
    });
  });
}
