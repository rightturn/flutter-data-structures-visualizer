import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/linked_list_data_structure.dart';

void main() {
  group('LinkedListDataStructure', () {
    late LinkedListDataStructure list;

    setUp(() => list = LinkedListDataStructure());

    test('inserts at head and tail in the expected order', () {
      list.insert(2);
      list.insertAtHead(1);
      list.insert(3);

      expect(list.nodes.map((node) => node.value), [1, 2, 3]);
      expect(list.animationSteps, isNotEmpty);
    });

    test('deletes the first matching value', () {
      list.addNodesDirectly([1, 2, 3]);
      list.delete(2);

      expect(list.nodes.map((node) => node.value), [1, 3]);
    });

    test('search and traversal preserve values and create steps', () {
      list.addNodesDirectly([4, 5, 6]);
      list.search(5);
      expect(list.nodes.map((node) => node.value), [4, 5, 6]);
      expect(
        list.animationSteps.last.description.toLowerCase(),
        contains('found'),
      );

      list.traverse();
      expect(list.animationSteps.length, greaterThanOrEqualTo(4));
      expect(list.nodes.map((node) => node.value), [4, 5, 6]);
    });
  });
}
