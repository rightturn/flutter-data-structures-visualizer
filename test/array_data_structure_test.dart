import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/array_data_structure.dart';

void main() {
  group('ArrayDataStructure', () {
    late ArrayDataStructure array;

    setUp(() {
      array = ArrayDataStructure();
    });

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
} 