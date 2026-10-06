import '../models/base_data_structure.dart';
import '../utils/constants.dart';
import 'visualization_helpers.dart';

class _BstNode {
  _BstNode(this.value);
  int value;
  _BstNode? left;
  _BstNode? right;
}

class BinarySearchTreeDataStructure extends BaseDataStructure {
  _BstNode? _root;

  @override
  void reset() {
    _root = null;
    super.reset();
  }

  Map<int, int> _indexedValues() {
    final result = <int, int>{};
    void visit(_BstNode? node, int index) {
      if (node == null) return;
      result[index] = node.value;
      visit(node.left, index * 2 + 1);
      visit(node.right, index * 2 + 2);
    }

    visit(_root, 0);
    return result;
  }

  void _syncNodes() => setNodes(buildTreeNodes(_indexedValues()));

  @override
  void insert(int value) {
    clearAnimationSteps();
    if (_root == null) {
      _root = _BstNode(value);
      addAnimationStep(
        visualizationStep(
          description: 'Inserted $value as the BST root.',
          code: 'root = Node($value);',
          nodes: buildTreeNodes(
            _indexedValues(),
            highlightedIndex: 0,
            highlightColor: AppConstants.insertionNodeColor,
          ),
        ),
      );
      _syncNodes();
      return;
    }

    var current = _root!;
    var index = 0;
    while (true) {
      addAnimationStep(
        visualizationStep(
          description: 'Compare $value with ${current.value}.',
          code: '$value < ${current.value}',
          nodes: buildTreeNodes(_indexedValues(), highlightedIndex: index),
        ),
      );
      if (value == current.value) {
        addAnimationStep(
          visualizationStep(
            description: '$value already exists; duplicate ignored.',
            code: 'return;',
            nodes: buildTreeNodes(
              _indexedValues(),
              highlightedIndex: index,
              highlightColor: AppConstants.foundNodeColor,
            ),
          ),
        );
        break;
      }
      if (value < current.value) {
        if (current.left == null) {
          current.left = _BstNode(value);
          final childIndex = index * 2 + 1;
          addAnimationStep(
            visualizationStep(
              description:
                  'Inserted $value as the left child of ${current.value}.',
              code: 'node.left = Node($value);',
              nodes: buildTreeNodes(
                _indexedValues(),
                highlightedIndex: childIndex,
                highlightColor: AppConstants.insertionNodeColor,
              ),
            ),
          );
          break;
        }
        current = current.left!;
        index = index * 2 + 1;
      } else {
        if (current.right == null) {
          current.right = _BstNode(value);
          final childIndex = index * 2 + 2;
          addAnimationStep(
            visualizationStep(
              description:
                  'Inserted $value as the right child of ${current.value}.',
              code: 'node.right = Node($value);',
              nodes: buildTreeNodes(
                _indexedValues(),
                highlightedIndex: childIndex,
                highlightColor: AppConstants.insertionNodeColor,
              ),
            ),
          );
          break;
        }
        current = current.right!;
        index = index * 2 + 2;
      }
    }
    _syncNodes();
    currentStep = 0;
  }

  @override
  void delete(int value) {
    clearAnimationSteps();
    if (!_contains(value)) {
      addAnimationStep(
        visualizationStep(
          description: '$value was not found in the BST.',
          code: 'return root;',
          nodes: buildTreeNodes(_indexedValues()),
        ),
      );
      return;
    }
    addAnimationStep(
      visualizationStep(
        description: 'Delete $value and reconnect its subtree.',
        code: 'root = delete(root, $value);',
        nodes: buildTreeNodes(_indexedValues()),
      ),
    );
    _root = _deleteNode(_root, value);
    addAnimationStep(
      visualizationStep(
        description: 'BST deletion complete.',
        code: 'return root;',
        nodes: buildTreeNodes(_indexedValues()),
      ),
    );
    _syncNodes();
    currentStep = 0;
  }

  @override
  void search(int value) {
    clearAnimationSteps();
    var current = _root;
    var index = 0;
    while (current != null) {
      final found = current.value == value;
      addAnimationStep(
        visualizationStep(
          description: found
              ? 'Found $value in the BST.'
              : 'Compare $value with ${current.value}.',
          code: found
              ? 'return node;'
              : (value < current.value
                    ? 'node = node.left;'
                    : 'node = node.right;'),
          nodes: buildTreeNodes(
            _indexedValues(),
            highlightedIndex: index,
            highlightColor: found
                ? AppConstants.foundNodeColor
                : AppConstants.currentNodeColor,
          ),
        ),
      );
      if (found) break;
      if (value < current.value) {
        current = current.left;
        index = index * 2 + 1;
      } else {
        current = current.right;
        index = index * 2 + 2;
      }
    }
    if (current == null) {
      addAnimationStep(
        visualizationStep(
          description: '$value was not found in the BST.',
          code: 'return null;',
          nodes: buildTreeNodes(_indexedValues()),
        ),
      );
    }
    currentStep = 0;
  }

  @override
  void traverse() {
    clearAnimationSteps();
    final indexed = _indexedValues();
    void visit(_BstNode? node, int index) {
      if (node == null) return;
      visit(node.left, index * 2 + 1);
      addAnimationStep(
        visualizationStep(
          description: 'In-order visit: ${node.value}.',
          code: 'visit(node.value);',
          nodes: buildTreeNodes(indexed, highlightedIndex: index),
        ),
      );
      visit(node.right, index * 2 + 2);
    }

    visit(_root, 0);
    currentStep = 0;
  }

  bool _contains(int value) {
    var current = _root;
    while (current != null) {
      if (current.value == value) return true;
      current = value < current.value ? current.left : current.right;
    }
    return false;
  }

  _BstNode? _deleteNode(_BstNode? node, int value) {
    if (node == null) return null;
    if (value < node.value) {
      node.left = _deleteNode(node.left, value);
    } else if (value > node.value) {
      node.right = _deleteNode(node.right, value);
    } else if (node.left == null) {
      return node.right;
    } else if (node.right == null) {
      return node.left;
    } else {
      var successor = node.right!;
      while (successor.left != null) {
        successor = successor.left!;
      }
      node.value = successor.value;
      node.right = _deleteNode(node.right, successor.value);
    }
    return node;
  }
}
