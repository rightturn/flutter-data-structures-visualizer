import '../models/base_data_structure.dart';
import '../utils/constants.dart';
import 'visualization_helpers.dart';

abstract class HeapDataStructure extends BaseDataStructure {
  HeapDataStructure({required this.isMinHeap});

  final bool isMinHeap;
  final List<int> values = [];

  @override
  void reset() {
    values.clear();
    super.reset();
  }

  String get heapName => isMinHeap ? 'Min Heap' : 'Max Heap';
  bool _ordered(int parent, int child) =>
      isMinHeap ? parent <= child : parent >= child;
  Map<int, int> get _indexedValues => {
    for (var index = 0; index < values.length; index++) index: values[index],
  };

  void _syncNodes() => setNodes(buildTreeNodes(_indexedValues));

  @override
  void insert(int value) {
    clearAnimationSteps();
    values.add(value);
    var index = values.length - 1;
    addAnimationStep(
      visualizationStep(
        description: '$heapName: append $value at the next open leaf.',
        code: 'heap.add($value);',
        nodes: buildTreeNodes(
          _indexedValues,
          highlightedIndex: index,
          highlightColor: AppConstants.insertionNodeColor,
        ),
      ),
    );
    while (index > 0) {
      final parent = (index - 1) ~/ 2;
      if (_ordered(values[parent], values[index])) break;
      final parentValue = values[parent];
      values[parent] = values[index];
      values[index] = parentValue;
      index = parent;
      addAnimationStep(
        visualizationStep(
          description: 'Swap upward to restore the $heapName property.',
          code: 'swap(child, parent);',
          nodes: buildTreeNodes(_indexedValues, highlightedIndex: index),
        ),
      );
    }
    _syncNodes();
    currentStep = 0;
  }

  int? extractRoot() {
    if (values.isEmpty) return null;
    clearAnimationSteps();
    final result = values.first;
    addAnimationStep(
      visualizationStep(
        description: '$heapName: remove root value $result.',
        code: 'root = heap.first;',
        nodes: buildTreeNodes(
          _indexedValues,
          highlightedIndex: 0,
          highlightColor: AppConstants.checkedNodeColor,
        ),
      ),
    );
    if (values.length == 1) {
      values.removeLast();
    } else {
      values[0] = values.removeLast();
      _siftDown(0, recordSteps: true);
    }
    addAnimationStep(
      visualizationStep(
        description: '$heapName property restored.',
        code: 'heapifyDown(0);',
        nodes: buildTreeNodes(_indexedValues),
      ),
    );
    _syncNodes();
    currentStep = 0;
    return result;
  }

  int? peekRoot() {
    if (values.isEmpty) return null;
    clearAnimationSteps();
    addAnimationStep(
      visualizationStep(
        description: '$heapName root is ${values.first}.',
        code: 'return heap.first;',
        nodes: buildTreeNodes(
          _indexedValues,
          highlightedIndex: 0,
          highlightColor: AppConstants.foundNodeColor,
        ),
      ),
    );
    currentStep = 0;
    return values.first;
  }

  void buildHeap(List<int> input) {
    values
      ..clear()
      ..addAll(input);
    clearAnimationSteps();
    for (var index = values.length ~/ 2 - 1; index >= 0; index--) {
      _siftDown(index, recordSteps: true);
    }
    addAnimationStep(
      visualizationStep(
        description: 'Built a valid $heapName from ${input.length} values.',
        code: 'buildHeap(values);',
        nodes: buildTreeNodes(_indexedValues),
      ),
    );
    _syncNodes();
    currentStep = 0;
  }

  void heapify() {
    buildHeap(List<int>.from(values));
  }

  void _siftDown(int start, {required bool recordSteps}) {
    var index = start;
    while (true) {
      final left = index * 2 + 1;
      final right = index * 2 + 2;
      var candidate = index;
      if (left < values.length && !_ordered(values[candidate], values[left]))
        candidate = left;
      if (right < values.length && !_ordered(values[candidate], values[right]))
        candidate = right;
      if (candidate == index) break;
      final value = values[index];
      values[index] = values[candidate];
      values[candidate] = value;
      index = candidate;
      if (recordSteps) {
        addAnimationStep(
          visualizationStep(
            description: 'Swap downward with the preferred child.',
            code: 'swap(parent, child);',
            nodes: buildTreeNodes(_indexedValues, highlightedIndex: index),
          ),
        );
      }
    }
  }

  @override
  void delete(int value) => extractRoot();

  @override
  void search(int value) {
    clearAnimationSteps();
    final index = values.indexOf(value);
    addAnimationStep(
      visualizationStep(
        description: index == -1
            ? '$value is not present in the $heapName.'
            : 'Found $value at heap index $index.',
        code: 'heap.indexOf($value);',
        nodes: buildTreeNodes(
          _indexedValues,
          highlightedIndex: index == -1 ? null : index,
          highlightColor: AppConstants.foundNodeColor,
        ),
      ),
    );
    currentStep = 0;
  }

  @override
  void traverse() {
    clearAnimationSteps();
    for (var index = 0; index < values.length; index++) {
      addAnimationStep(
        visualizationStep(
          description: 'Level-order heap visit: ${values[index]}.',
          code: 'visit(heap[$index]);',
          nodes: buildTreeNodes(_indexedValues, highlightedIndex: index),
        ),
      );
    }
    currentStep = 0;
  }
}
