import '../models/base_data_structure.dart';
import '../utils/constants.dart';
import 'visualization_helpers.dart';

class BinaryTreeDataStructure extends BaseDataStructure {
  final List<int> _values = [];

  Map<int, int> get _indexedValues => {
    for (var index = 0; index < _values.length; index++) index: _values[index],
  };

  @override
  void reset() {
    _values.clear();
    super.reset();
  }

  @override
  void insert(int value) {
    clearAnimationSteps();
    addAnimationStep(
      visualizationStep(
        description:
            'Binary Tree Insert: locate the next level-order position.',
        code: 'queue.firstAvailableChild = $value;',
        nodes: buildTreeNodes(_indexedValues),
        insights: 'Level-order insertion keeps the tree complete.',
      ),
    );
    _values.add(value);
    final insertedIndex = _values.length - 1;
    addAnimationStep(
      visualizationStep(
        description: 'Inserted $value at tree index $insertedIndex.',
        code: 'nodes[$insertedIndex] = $value;',
        nodes: buildTreeNodes(
          _indexedValues,
          highlightedIndex: insertedIndex,
          highlightColor: AppConstants.insertionNodeColor,
        ),
      ),
    );
    setNodes(buildTreeNodes(_indexedValues));
    currentStep = 0;
  }

  @override
  void delete(int value) {
    clearAnimationSteps();
    final target = _values.indexOf(value);
    if (target == -1) {
      addAnimationStep(
        visualizationStep(
          description: 'Value $value was not found in the binary tree.',
          code: 'return false;',
          nodes: buildTreeNodes(_indexedValues),
        ),
      );
      return;
    }
    addAnimationStep(
      visualizationStep(
        description: 'Found $value. Replace it with the deepest node.',
        code: 'target.value = deepest.value;',
        nodes: buildTreeNodes(
          _indexedValues,
          highlightedIndex: target,
          highlightColor: AppConstants.checkedNodeColor,
        ),
      ),
    );
    _values[target] = _values.last;
    _values.removeLast();
    addAnimationStep(
      visualizationStep(
        description: 'Deleted $value and restored the complete-tree shape.',
        code: 'removeDeepestNode();',
        nodes: buildTreeNodes(_indexedValues),
      ),
    );
    setNodes(buildTreeNodes(_indexedValues));
    currentStep = 0;
  }

  @override
  void search(int value) {
    clearAnimationSteps();
    for (var index = 0; index < _values.length; index++) {
      final found = _values[index] == value;
      addAnimationStep(
        visualizationStep(
          description: found
              ? 'Found $value at tree index $index.'
              : 'Visited ${_values[index]}; continue level-order search.',
          code: 'if (node.value == $value)',
          nodes: buildTreeNodes(
            _indexedValues,
            highlightedIndex: index,
            highlightColor: found
                ? AppConstants.foundNodeColor
                : AppConstants.currentNodeColor,
          ),
        ),
      );
      if (found) break;
    }
    if (_values.isEmpty || !_values.contains(value)) {
      addAnimationStep(
        visualizationStep(
          description: 'Value $value was not found.',
          code: 'return null;',
          nodes: buildTreeNodes(_indexedValues),
        ),
      );
    }
    currentStep = 0;
  }

  @override
  void traverse() {
    clearAnimationSteps();
    for (var index = 0; index < _values.length; index++) {
      addAnimationStep(
        visualizationStep(
          description: 'Level-order visit: ${_values[index]}.',
          code: 'visit(queue.removeFirst());',
          nodes: buildTreeNodes(_indexedValues, highlightedIndex: index),
        ),
      );
    }
    currentStep = 0;
  }
}
