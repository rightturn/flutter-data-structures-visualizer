import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/binary_tree_data_structure.dart';
import 'package:data_structures/data_structures/binary_search_tree_data_structure.dart';

void main() {
  test('binary tree uses level-order insertion and deepest-node deletion', () {
    final tree = BinaryTreeDataStructure();
    for (final value in [1, 2, 3, 4]) {
      tree.insert(value);
    }
    expect(tree.nodes.map((node) => node.value), [1, 2, 3, 4]);

    tree.delete(2);
    expect(tree.nodes.map((node) => node.value), [1, 4, 3]);
    tree.search(4);
    expect(tree.animationSteps.last.description, contains('Found'));
  });

  test('BST preserves ordering and handles two-child deletion', () {
    final tree = BinarySearchTreeDataStructure();
    for (final value in [8, 3, 10, 1, 6, 9, 14]) {
      tree.insert(value);
    }
    tree.delete(8);
    expect(tree.nodes.map((node) => node.value), isNot(contains(8)));
    expect(tree.nodes.first.value, 9);

    tree.search(6);
    expect(tree.animationSteps.last.description, contains('Found'));
    tree.traverse();
    expect(
      tree.animationSteps.map((step) => step.description),
      containsAllInOrder([
        'In-order visit: 1.',
        'In-order visit: 3.',
        'In-order visit: 6.',
      ]),
    );
  });
}
