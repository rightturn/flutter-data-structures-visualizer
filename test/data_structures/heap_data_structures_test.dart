import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/min_heap_data_structure.dart';
import 'package:data_structures/data_structures/max_heap_data_structure.dart';

void main() {
  test('min heap keeps the smallest value at the root', () {
    final heap = MinHeapDataStructure();
    for (final value in [8, 3, 10, 1, 6]) {
      heap.insert(value);
    }
    expect(heap.nodes.first.value, 1);
    expect(heap.extractRoot(), 1);
    expect(heap.nodes.first.value, 3);
  });

  test('max heap keeps the largest value at the root', () {
    final heap = MaxHeapDataStructure();
    heap.buildHeap([8, 3, 10, 1, 14, 6]);
    expect(heap.nodes.first.value, 14);
    expect(heap.extractRoot(), 14);
    expect(heap.nodes.first.value, 10);
  });
}
