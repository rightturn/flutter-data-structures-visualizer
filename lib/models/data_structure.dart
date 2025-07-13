import 'package:flutter/material.dart';

enum DataStructureType {
  array,
  linkedList,
  stack,
  queue,
  binaryTree,
  binarySearchTree,
  minHeap,
  maxHeap,
  graph,
}

class DataStructureInfo {
  final DataStructureType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> operations;

  const DataStructureInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.operations,
  });
}

class DataStructureNode {
  final int value;
  final String? label;
  final Color? color;
  final Offset position;
  final List<DataStructureNode> children;
  final DataStructureNode? next;
  final DataStructureNode? prev;

  DataStructureNode({
    required this.value,
    this.label,
    this.color,
    required this.position,
    this.children = const [],
    this.next,
    this.prev,
  });

  DataStructureNode copyWith({
    int? value,
    String? label,
    Color? color,
    Offset? position,
    List<DataStructureNode>? children,
    DataStructureNode? next,
    DataStructureNode? prev,
  }) {
    return DataStructureNode(
      value: value ?? this.value,
      label: label ?? this.label,
      color: color ?? this.color,
      position: position ?? this.position,
      children: children ?? this.children,
      next: next ?? this.next,
      prev: prev ?? this.prev,
    );
  }
}

class AnimationStep {
  final String description;
  final String code;
  final List<DataStructureNode> nodes;
  final int highlightedLine;
  final Duration duration;
  final String insights;

  const AnimationStep({
    required this.description,
    required this.code,
    required this.nodes,
    required this.highlightedLine,
    this.duration = const Duration(milliseconds: 1000),
    this.insights = '',
  });
}

abstract class DataStructure {
  List<DataStructureNode> get nodes;
  List<AnimationStep> get animationSteps;
  int get currentStep;
  
  void reset();
  void nextStep();
  void previousStep();
  void goToStep(int step);
  bool get isAtEnd;
  bool get isAtStart;
  
  // Common operations
  void insert(int value);
  void delete(int value);
  void search(int value);
  void traverse();
  
  // Default implementation for resetColors
  void resetColors() {
    // Default implementation - clear colors from all nodes
    // This will be overridden by specific implementations
  }
}

class ArrayDataStructure implements DataStructure {
  List<DataStructureNode> _nodes = [];
  List<AnimationStep> _animationSteps = [];
  int _currentStep = 0;

  @override
  List<DataStructureNode> get nodes => _nodes;

  @override
  List<AnimationStep> get animationSteps => _animationSteps;

  @override
  int get currentStep => _currentStep;

  @override
  bool get isAtEnd => _currentStep >= _animationSteps.length - 1;

  @override
  bool get isAtStart => _currentStep <= 0;

  @override
  void reset() {
    _currentStep = 0;
    _nodes = [];
    _animationSteps = [];
  }

  void resetColors() {
    // Clear all colors from nodes while preserving their values
    _nodes = _nodes.map((node) => node.copyWith(color: null)).toList();
    // Clear animation steps
    _animationSteps.clear();
    _currentStep = 0;
  }

  @override
  void nextStep() {
    if (!isAtEnd) {
      _currentStep++;
      _updateNodes();
    }
  }

  @override
  void previousStep() {
    if (!isAtStart) {
      _currentStep--;
      _updateNodes();
    }
  }

  @override
  void goToStep(int step) {
    debugPrint('ArrayDataStructure.goToStep called with step: $step, animation steps length: ${_animationSteps.length}');
    if (step >= 0 && step < _animationSteps.length) {
      _currentStep = step;
      _updateNodes();
      debugPrint('Successfully went to step: $_currentStep');
    } else {
      debugPrint('Invalid step: $step (must be between 0 and ${_animationSteps.length - 1})');
    }
  }

  void _updateNodes() {
    debugPrint('_updateNodes called. Current step:  [36m$_currentStep [0m, animation steps:  [36m${_animationSteps.length} [0m');
    if (_currentStep < _animationSteps.length) {
      _nodes = _animationSteps[_currentStep].nodes;
      debugPrint('Nodes updated from animation step. New count:  [36m${_nodes.length} [0m');
    } else {
      debugPrint('No animation step available, keeping current nodes. Count:  [36m${_nodes.length} [0m');
    }
  }

  @override
  void insert(int value) {
    debugPrint('ArrayDataStructure.insert called with value: $value');
    debugPrint('Current nodes count before insert: ${_nodes.length}');
    
    final insertIndex = _nodes.length; // Insert at the end
    _animationSteps.clear();
    _currentStep = 0;
    
    // Step 1: Show current array state
    final currentNodes = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
    _animationSteps.add(AnimationStep(
      description: 'Array Insertion: Step 1 of 3\nAnalyzing current array state (${_nodes.length} elements)\nPreparing to insert $value at the end (index $insertIndex)\nO(1) operation: Direct insertion at end',
      code: 'array.add($value)',
      nodes: currentNodes,
      highlightedLine: 1,
      insights: 'Inserting at the end of an array is the most efficient insertion operation. It requires no shifting of existing elements and has O(1) time complexity.',
    ));
    
    // Step 2: Highlight the insertion position
    final highlightNodes = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
    // Add a placeholder node at the insertion position with a different color
    final placeholderNode = DataStructureNode(
      value: value,
      position: Offset(50.0 + (insertIndex * 80.0), 100.0),
      color: Colors.orange, // Orange to indicate insertion position
    );
    highlightNodes.add(placeholderNode);
    
    _animationSteps.add(AnimationStep(
      description: 'Array Insertion: Step 2 of 3\nOrange highlight: Insertion position identified\nAllocating space for new element $value\nMemory allocation: O(1) operation',
      code: 'array.add($value)',
      nodes: highlightNodes,
      highlightedLine: 1,
      insights: 'The orange color indicates where the new element will be placed. Arrays automatically expand to accommodate new elements at the end.',
    ));
    
    // Step 3: Show the final result with the new node in green
    final finalNodes = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
    final newNode = DataStructureNode(
      value: value,
      position: Offset(50.0 + (insertIndex * 80.0), 100.0),
      color: Colors.green, // Green to show successful insertion
    );
    finalNodes.add(newNode);
    
    _animationSteps.add(AnimationStep(
      description: 'Array Insertion: Step 3 of 3\nGreen highlight: Element $value successfully inserted\nArray size increased to ${_nodes.length + 1}\nInsertion completed in O(1) time',
      code: 'array.add($value)',
      nodes: finalNodes,
      highlightedLine: 1,
      insights: 'The green color confirms successful insertion. End insertion is optimal for arrays as it doesn\'t require shifting existing elements.',
    ));
    
    // Actually add the node to the data structure
    _nodes.add(DataStructureNode(
      value: value,
      position: Offset(50.0 + (insertIndex * 80.0), 100.0),
      color: Colors.green,
    ));
    
    _currentStep = 0;
    _updateNodes();
    debugPrint('Insert completed. Final nodes count: ${_nodes.length}');
  }

  @override
  void delete(int value) {
    debugPrint('ArrayDataStructure.delete called with value: $value');
    debugPrint('Current nodes count: ${_nodes.length}');
    
    if (_nodes.isEmpty) {
      debugPrint('No nodes to delete from');
      return;
    }
    
    _animationSteps.clear();
    _currentStep = 0;
    
    // Step 1: all gray
    final allGray = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
    _animationSteps.add(AnimationStep(
      description: 'Array Deletion: Step 1 of ${_nodes.length + 1}\nLinear Search Algorithm: Finding element $value to delete\nGray elements: Not yet examined\nO(n) operation: Sequential search through array',
      code: 'delete($value)',
      nodes: allGray,
      highlightedLine: 1,
    ));
    
    debugPrint('Created ${_animationSteps.length} animation steps so far');
    
    // Step 2+: check each node one by one
    for (int i = 0; i < _nodes.length; i++) {
      final node = _nodes[i];
      final isMatch = node.value == value;
      
      final deleteNodes = _nodes.asMap().entries.map((entry) {
        final idx = entry.key;
        final currentNode = entry.value;
        
        if (idx < i) {
          // Previously checked nodes that didn't match - keep gray
          return currentNode.copyWith(color: Colors.grey);
        } else if (idx == i) {
          // Current node being checked
          return currentNode.copyWith(
            color: isMatch ? Colors.red : Colors.blue, // red if match, blue outline if not
          );
        } else {
          // Future nodes - keep gray
          return currentNode.copyWith(color: Colors.grey);
        }
      }).toList();
      
      _animationSteps.add(AnimationStep(
        description: isMatch 
          ? 'Array Deletion: Step ${i + 2} of ${_nodes.length + 1}\nRed highlight: Found $value at index $i!\nTarget element identified for deletion\nLinear search: O(n) worst case complexity' 
          : 'Array Deletion: Step ${i + 2} of ${_nodes.length + 1}\nBlue highlight: Checking index $i (value: ${node.value})\n${node.value} ≠ $value, continue searching\nLinear search: Examining next element',
        code: isMatch 
          ? 'if (array[$i] == $value) delete $i' 
          : 'if (array[$i] == $value) delete $i',
        nodes: deleteNodes,
        highlightedLine: 1,
      ));
      
      // If we found the value, add deletion animation and stop
      if (isMatch) {
        debugPrint('Found $value at index $i, creating deletion animation');
        
        // Create a copy of nodes without the deleted item
        final nodesAfterDelete = <DataStructureNode>[];
        for (int j = 0; j < _nodes.length; j++) {
          if (j != i) {
            // Adjust position for nodes after the deleted one
            final newIndex = j > i ? j - 1 : j;
            nodesAfterDelete.add(_nodes[j].copyWith(
              position: Offset(50.0 + (newIndex * 80.0), 100.0),
              color: null, // Show remaining nodes in default state
            ));
          }
        }
        
        _animationSteps.add(AnimationStep(
          description: 'Array Deletion: Step ${i + 3} of ${_nodes.length + 1}\nDeletion completed: Element $value removed from index $i\nArray size reduced to ${_nodes.length - 1}\nShifting elements: O(n) operation for array reorganization',
          code: 'array.removeAt($i)',
          nodes: nodesAfterDelete,
          highlightedLine: 1,
        ));
        
        // Actually remove the node from the data structure
        _nodes.removeAt(i);
        
        break;
      }
    }
    
    // If we didn't find the value, add a final step showing all gray
    if (!_nodes.any((node) => node.value == value)) {
      final allGray = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
      _animationSteps.add(AnimationStep(
        description: 'Array Deletion: Step ${_nodes.length + 1} of ${_nodes.length + 1}\nSearch completed: Value $value not found in array\nAll elements examined without finding target\nLinear search: O(n) operation completed unsuccessfully',
        code: 'return -1',
        nodes: allGray,
        highlightedLine: 1,
      ));
      debugPrint('Value $value not found in array for deletion');
    }
    
    debugPrint('Total animation steps created: ${_animationSteps.length}');
    
    if (_animationSteps.isNotEmpty) {
      _updateNodes();
      debugPrint('Delete completed. Current step: $_currentStep');
    } else {
      debugPrint('No animation steps created');
    }
  }

  @override
  void search(int value) {
    debugPrint('ArrayDataStructure.search called with value: $value');
    debugPrint('Current nodes count: ${_nodes.length}');
    
    if (_nodes.isEmpty) {
      debugPrint('No nodes to search');
      return;
    }
    
    _animationSteps.clear();
    _currentStep = 0;
    
    // Step 1: all gray
    final allGray = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
    _animationSteps.add(AnimationStep(
      description: 'Array Search: Step 1 of ${_nodes.length * 2 + 1}\nLinear Search Algorithm: Finding element $value\nGray elements: Not yet examined\nO(n) operation: Sequential search through array',
      code: 'search($value)',
      nodes: allGray,
      highlightedLine: 1,
      insights: 'Linear search examines each element sequentially until the target is found. It\'s simple but not the most efficient for large datasets.',
    ));
    
    debugPrint('Created ${_animationSteps.length} animation steps so far');
    
    // Step 2+: check each node one by one
    for (int i = 0; i < _nodes.length; i++) {
      final node = _nodes[i];
      final isMatch = node.value == value;
      
      // Step 2a: Highlight current node in blue while checking
      final checkingNodes = _nodes.asMap().entries.map((entry) {
        final idx = entry.key;
        final currentNode = entry.value;
        
        if (idx < i) {
          // Previously checked nodes that didn't match - mark as red
          return currentNode.copyWith(color: Colors.red);
        } else if (idx == i) {
          // Current node being checked - highlight in blue
          return currentNode.copyWith(color: Colors.blue);
        } else {
          // Future nodes - keep gray
          return currentNode.copyWith(color: Colors.grey);
        }
      }).toList();
      
      _animationSteps.add(AnimationStep(
        description: 'Array Search: Step ${i * 2 + 2} of ${_nodes.length * 2 + 1}\nBlue highlight: Examining element at index $i\nRed elements: Previously checked (no match)\nGray elements: Not yet examined\nComparing: ${node.value} == $value?',
        code: 'if (array[$i] == $value) return $i',
        nodes: checkingNodes,
        highlightedLine: 1,
      ));
      
      // Step 2b: Show result of the check
      final resultNodes = _nodes.asMap().entries.map((entry) {
        final idx = entry.key;
        final currentNode = entry.value;
        
        if (idx < i) {
          // Previously checked nodes that didn't match - mark as red
          return currentNode.copyWith(color: Colors.red);
        } else if (idx == i) {
          // Current node result
          return currentNode.copyWith(
            color: isMatch ? Colors.green : Colors.red,
          );
        } else {
          // Future nodes - keep gray
          return currentNode.copyWith(color: Colors.grey);
        }
      }).toList();
      
      _animationSteps.add(AnimationStep(
        description: isMatch 
          ? 'Array Search: Step ${i * 2 + 3} of ${_nodes.length * 2 + 1}\nGreen highlight: Found $value at index $i!\nSearch successful - element located\nLinear search: O(n) operation completed successfully' 
          : 'Array Search: Step ${i * 2 + 3} of ${_nodes.length * 2 + 1}\nRed highlight: ${node.value} ≠ $value\nElement at index $i doesn\'t match target\nContinuing search to next element',
        code: isMatch 
          ? 'return $i' 
          : 'continue',
        nodes: resultNodes,
        highlightedLine: 1,
      ));
      
      // If we found the value, stop searching
      if (isMatch) {
        debugPrint('Found $value at index $i, stopping search');
        break;
      }
    }
    
    // If we didn't find the value, add a final step showing all red
    if (!_nodes.any((node) => node.value == value)) {
      final allRed = _nodes.map((node) => node.copyWith(color: Colors.red)).toList();
      _animationSteps.add(AnimationStep(
        description: 'Array Search: Step ${_nodes.length * 2 + 1} of ${_nodes.length * 2 + 1}\nSearch completed: Value $value not found\nRed elements: All elements examined without match\nLinear search: O(n) operation completed unsuccessfully\nReturn value: -1 (not found)',
        code: 'return -1',
        nodes: allRed,
        highlightedLine: 1,
      ));
      debugPrint('Value $value not found in array');
    }
    
    debugPrint('Total animation steps created: ${_animationSteps.length}');
    
    if (_animationSteps.isNotEmpty) {
      _updateNodes();
      debugPrint('Search completed. Current step: $_currentStep');
    } else {
      debugPrint('No animation steps created');
    }
  }

  @override
  void traverse() {
    debugPrint('ArrayDataStructure.traverse called');
    debugPrint('Current nodes count: ${_nodes.length}');
    
    if (_nodes.isEmpty) {
      debugPrint('No nodes to traverse');
      return;
    }
    
    _animationSteps.clear();
    _currentStep = 0;
    
    // Step 1: all gray
    final allGray = _nodes.map((node) => node.copyWith(color: Colors.grey)).toList();
    _animationSteps.add(AnimationStep(
      description: 'Array Traversal: Step 1 of ${_nodes.length + 1}\nSequential Traversal Algorithm: Visiting all elements\nGray elements: Not yet visited\nO(n) operation: Must visit every element once\nTraversal pattern: Left to right (index 0 to ${_nodes.length - 1})',
      code: 'for (int i = 0; i < array.length; i++)',
      nodes: allGray,
      highlightedLine: 1,
      insights: 'Sequential traversal visits every element exactly once. This is the most common way to process all elements in an array.',
    ));
    
    debugPrint('Created ${_animationSteps.length} animation steps so far');
    
    // Step 2+: highlight each node blue, rest gray
    for (int i = 0; i < _nodes.length; i++) {
      final highlightedNodes = _nodes.asMap().entries.map((entry) {
        final idx = entry.key;
        final node = entry.value;
        return node.copyWith(
          color: idx == i ? Colors.blue : Colors.grey,
        );
      }).toList();
      _animationSteps.add(AnimationStep(
        description: 'Array Traversal: Step ${i + 2} of ${_nodes.length + 1}\nBlue highlight: Visiting element at index $i (value: ${_nodes[i].value})\nGray elements: Not yet visited\nSequential access: Processing element ${i + 1} of ${_nodes.length}\nO(1) operation: Direct array access',
        code: 'visit(array[$i])',
        nodes: highlightedNodes,
        highlightedLine: 1,
        insights: 'Direct array access at index $i is an O(1) operation. Arrays provide constant-time access to any element by index.',
      ));
    }
    
    debugPrint('Total animation steps created: ${_animationSteps.length}');
    
    if (_animationSteps.isNotEmpty) {
      _updateNodes();
      debugPrint('Traverse completed. Current step: $_currentStep');
    } else {
      debugPrint('No animation steps created');
    }
  }

  // Method to add nodes directly without animation (for bulk operations)
  void addNodesDirectly(List<int> values) {
    debugPrint('ArrayDataStructure.addNodesDirectly called with ${values.length} values');
    
    // Clear existing nodes and animation steps
    _nodes.clear();
    _animationSteps.clear();
    _currentStep = 0;
    
    // Add all nodes directly
    for (int i = 0; i < values.length; i++) {
      final node = DataStructureNode(
        value: values[i],
        position: Offset(50.0 + (i * 80.0), 100.0),
        color: Colors.grey,
      );
      _nodes.add(node);
    }
    
    debugPrint('Added ${_nodes.length} nodes directly');
  }

  // Method to update a node's value directly
  void updateNodeValue(int index, int newValue) {
    debugPrint('ArrayDataStructure.updateNodeValue called with index: $index, newValue: $newValue');
    
    if (index >= 0 && index < _nodes.length) {
      // Update the node's value while preserving other properties
      final oldNode = _nodes[index];
      _nodes[index] = DataStructureNode(
        value: newValue,
        position: oldNode.position,
        color: oldNode.color,
        label: oldNode.label,
        children: oldNode.children,
        next: oldNode.next,
        prev: oldNode.prev,
      );
      
      debugPrint('Updated node at index $index from ${oldNode.value} to $newValue');
    } else {
      debugPrint('Invalid index: $index (must be between 0 and ${_nodes.length - 1})');
    }
  }

  void clearNodeColors() {
    // Clear colors from nodes without clearing animation steps
    _nodes = _nodes.map((node) => node.copyWith(color: null)).toList();
  }

  void resetToDefault() {
    debugPrint('ArrayDataStructure.resetToDefault called');
    debugPrint('Before reset: ${_nodes.length} nodes, ${_animationSteps.length} animation steps');
    
    // Clear animation steps first
    _animationSteps.clear();
    _currentStep = 0;
    
    // Reset to default state: clear colors, preserve data
    _nodes = _nodes.map((node) => DataStructureNode(
      value: node.value,
      position: node.position,
      color: null, // Explicitly set to null
      label: node.label,
      children: node.children,
      next: node.next,
      prev: node.prev,
    )).toList();
    
    debugPrint('After reset: ${_nodes.length} nodes, ${_animationSteps.length} animation steps');
    debugPrint('Node colors after reset: ${_nodes.map((n) => n.color).toList()}');
  }
}

class LinkedListDataStructure implements DataStructure {
  List<DataStructureNode> _nodes = [];
  List<AnimationStep> _animationSteps = [];
  int _currentStep = 0;

  @override
  List<DataStructureNode> get nodes => _nodes;

  @override
  List<AnimationStep> get animationSteps => _animationSteps;

  @override
  int get currentStep => _currentStep;

  @override
  bool get isAtEnd => _currentStep >= _animationSteps.length - 1;

  @override
  bool get isAtStart => _currentStep <= 0;

  @override
  void reset() {
    _currentStep = 0;
    _nodes = [];
    _animationSteps = [];
  }

  @override
  void nextStep() {
    if (!isAtEnd) {
      _currentStep++;
      _updateNodes();
    }
  }

  @override
  void previousStep() {
    if (!isAtStart) {
      _currentStep--;
      _updateNodes();
    }
  }

  @override
  void goToStep(int step) {
    if (step >= 0 && step < _animationSteps.length) {
      _currentStep = step;
      _updateNodes();
    }
  }

  void _updateNodes() {
    if (_currentStep < _animationSteps.length) {
      _nodes = _animationSteps[_currentStep].nodes;
    }
  }

  @override
  void insert(int value) {
    // Implementation for linked list insertion
  }

  @override
  void delete(int value) {
    // Implementation for linked list deletion
  }

  @override
  void search(int value) {
    // Implementation for linked list search
  }

  @override
  void traverse() {
    // Implementation for linked list traversal
  }

  @override
  void resetColors() {
    // Clear all colors from nodes while preserving their values
    _nodes = _nodes.map((node) => node.copyWith(color: null)).toList();
    // Clear animation steps
    _animationSteps.clear();
    _currentStep = 0;
  }
} 