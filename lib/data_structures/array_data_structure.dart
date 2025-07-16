import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_node.dart';
import '../models/animation_step.dart';
import '../utils/logger.dart';
import '../utils/constants.dart';
import '../services/animation_step_builder.dart';
import '../services/error_handler.dart';
import '../services/validation_service.dart';

class ArrayDataStructure extends BaseDataStructure {
  final List<int> _data = [];

  @override
  void insert(int value) {
    AppLogger.dataStructure('ArrayDataStructure.insert called with value: $value');
    
    try {
      // Validate input
      final validation = ValidationService.validateDataStructureState(
        nodes: _data,
        operationType: 'insert',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure('Insert validation failed: ${validation.errorMessage}');
        return;
      }
      
      AppLogger.dataStructure('Current data count before insert: ${_data.length}');
      final insertIndex = _data.length;
      clearAnimationSteps();

      // Step 1: Show current array state
      final currentNodes = AnimationStepBuilder.createPositionedArrayNodes(
        values: _data,
        startX: 50.0,
        startY: AppConstants.nodeStartY,
        spacing: AppConstants.nodeBoxWidth,
      ).map((node) => node.copyWith(color: AppConstants.defaultNodeColor)).toList();
      
      addAnimationStep(AnimationStepBuilder.buildArrayInsertStep(
        stepNumber: 1,
        totalSteps: 3,
        operationType: 'Array Insertion',
        nodes: currentNodes,
        code: 'array.add($value)',
        customDescription: 'Array Insertion: Step 1 of 3\nAnalyzing current array state (${_data.length} elements)\nPreparing to insert $value at the end (index $insertIndex)\nO(1) operation: Direct insertion at end',
        insights: 'Inserting at the end of an array is the most efficient insertion operation. It requires no shifting of existing elements and has O(1) time complexity.',
      ));
    
    // Step 2: Highlight the insertion position
    final highlightNodes = List<DataStructureNode>.from(currentNodes);
    final placeholderNode = DataStructureNode(
      value: value,
      position: Offset(50.0 + (insertIndex * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
      color: AppConstants.insertionNodeColor,
    );
    highlightNodes.add(placeholderNode);
    
    addAnimationStep(AnimationStep(
      description: 'Array Insertion: Step 2 of 3\nOrange highlight: Insertion position identified\nAllocating space for new element $value\nMemory allocation: O(1) operation',
      code: 'array.add($value)',
      nodes: highlightNodes,
      highlightedLine: 1,
      insights: 'The orange color indicates where the new element will be placed. Arrays automatically expand to accommodate new elements at the end.',
    ));
    
    // Step 3: Show the final result with the new node in green
    final finalNodes = List<DataStructureNode>.from(currentNodes);
    final newNode = DataStructureNode(
      value: value,
      position: Offset(50.0 + (insertIndex * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
      color: AppConstants.foundNodeColor,
    );
    finalNodes.add(newNode);
    
    addAnimationStep(AnimationStep(
      description: 'Array Insertion: Step 3 of 3\nGreen highlight: Element $value successfully inserted\nArray size increased to ${_data.length + 1}\nInsertion completed in O(1) time',
      code: 'array.add($value)',
      nodes: finalNodes,
      highlightedLine: 1,
      insights: 'The green color confirms successful insertion. End insertion is optimal for arrays as it doesn\'t require shifting existing elements.',
    ));
    
    // Actually add the value to the true data
    _data.add(value);

      // After operation, set nodes to reflect the true data (for tests and logic)
      setNodes(AnimationStepBuilder.createPositionedArrayNodes(
        values: _data,
        startX: 50.0,
        startY: AppConstants.nodeStartY,
        spacing: AppConstants.nodeBoxWidth,
      ));
      currentStep = 0;
      AppLogger.dataStructure('Insert completed. Final data count: ${_data.length}');
    } catch (e) {
      final errorMessage = ErrorHandler.handleDataStructureError('Array', 'Insert', e as Exception);
      AppLogger.dataStructure('Insert error: $errorMessage');
    }
  }

  @override
  void delete(int value) {
    AppLogger.dataStructure('ArrayDataStructure.delete called with value: $value');
    
    try {
      // Validate input and state
      final validation = ValidationService.validateDataStructureState(
        nodes: _data,
        operationType: 'delete',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure('Delete validation failed: ${validation.errorMessage}');
        return;
      }
      
      AppLogger.dataStructure('Current data count: ${_data.length}');
      clearAnimationSteps();

    // Step 1: all gray
    final allGray = _data
        .asMap()
        .entries
        .map((entry) => DataStructureNode(
              value: entry.value,
              position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: AppConstants.defaultNodeColor,
            ))
        .toList();
    addAnimationStep(AnimationStep(
      description: 'Array Deletion: Step 1 of ${_data.length + 1}\nLinear Search Algorithm: Finding element $value to delete\nGray elements: Not yet examined\nO(n) operation: Sequential search through array',
      code: 'delete($value)',
      nodes: allGray,
      highlightedLine: 1,
      insights: 'Linear search examines each element sequentially until the target is found. It\'s simple but not the most efficient for large datasets.',
    ));

    bool found = false;
    int foundIndex = -1;
    // Step 2+: check each value one by one
    for (int i = 0; i < _data.length; i++) {
      final isMatch = _data[i] == value;
      final deleteNodes = _data.asMap().entries.map((entry) {
        final idx = entry.key;
        final val = entry.value;
        if (idx < i) {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.defaultNodeColor,
          );
        } else if (idx == i) {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: isMatch ? AppConstants.checkedNodeColor : AppConstants.currentNodeColor,
          );
        } else {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.defaultNodeColor,
          );
        }
      }).toList();
      addAnimationStep(AnimationStep(
        description: isMatch
            ? 'Array Deletion: Step ${i + 2} of ${_data.length + 1}\nRed highlight: Found $value at index $i!\nTarget element identified for deletion\nLinear search: O(n) worst case complexity'
            : 'Array Deletion: Step ${i + 2} of ${_data.length + 1}\nBlue highlight: Checking index $i (value: ${_data[i]})\n${_data[i]} ≠ $value, continue searching\nLinear search: Examining next element',
        code: isMatch ? 'if (array[$i] == $value) delete $i' : 'if (array[$i] == $value) delete $i',
        nodes: deleteNodes,
        highlightedLine: 1,
      ));
      if (isMatch) {
        found = true;
        foundIndex = i;
        // Create a copy of nodes without the deleted item
        final nodesAfterDelete = <DataStructureNode>[];
        for (int j = 0; j < _data.length; j++) {
          if (j != i) {
            final newIndex = j > i ? j - 1 : j;
            nodesAfterDelete.add(DataStructureNode(
              value: _data[j],
              position: Offset(50.0 + (newIndex * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: null,
            ));
          }
        }
        addAnimationStep(AnimationStep(
          description: 'Array Deletion: Step ${i + 3} of ${_data.length + 1}\nDeletion completed: Element $value removed from index $i\nArray size reduced to ${_data.length - 1}\nShifting elements: O(n) operation for array reorganization',
          code: 'array.removeAt($i)',
          nodes: nodesAfterDelete,
          highlightedLine: 1,
        ));
        break;
      }
    }
    if (found) {
      _data.removeAt(foundIndex);
    }
    // If not found, add a final step showing all gray
    if (!found) {
      final allGray = _data
          .asMap()
          .entries
          .map((entry) => DataStructureNode(
                value: entry.value,
                position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
                color: AppConstants.defaultNodeColor,
              ))
          .toList();
      addAnimationStep(AnimationStep(
        description: 'Array Deletion: Step ${_data.length + 1} of ${_data.length + 1}\nSearch completed: Value $value not found in array\nAll elements examined without finding target\nLinear search: O(n) operation completed unsuccessfully',
        code: 'return -1',
        nodes: allGray,
        highlightedLine: 1,
      ));
      AppLogger.dataStructure('Value $value not found in array for deletion');
    }
      // After operation, set nodes to reflect the true data
      setNodes(AnimationStepBuilder.createPositionedArrayNodes(
        values: _data,
        startX: 50.0,
        startY: AppConstants.nodeStartY,
        spacing: AppConstants.nodeBoxWidth,
      ));
      currentStep = 0;
      AppLogger.dataStructure('Delete completed. Final data count: ${_data.length}');
    } catch (e) {
      final errorMessage = ErrorHandler.handleDataStructureError('Array', 'Delete', e as Exception);
      AppLogger.dataStructure('Delete error: $errorMessage');
    }
  }

  @override
  void search(int value) {
    AppLogger.dataStructure('ArrayDataStructure.search called with value: $value');
    AppLogger.dataStructure('Current data count: ${_data.length}');

    if (_data.isEmpty) {
      AppLogger.dataStructure('No data to search');
      return;
    }

    clearAnimationSteps();

    // Step 1: all gray
    final allGray = _data
        .asMap()
        .entries
        .map((entry) => DataStructureNode(
              value: entry.value,
              position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: AppConstants.defaultNodeColor,
            ))
        .toList();
    addAnimationStep(AnimationStep(
      description: 'Array Search: Step 1 of ${_data.length * 2 + 1}\nLinear Search Algorithm: Finding element $value\nGray elements: Not yet examined\nO(n) operation: Sequential search through array',
      code: 'search($value)',
      nodes: allGray,
      highlightedLine: 1,
      insights: 'Linear search examines each element sequentially until the target is found. It\'s simple but not the most efficient for large datasets.',
    ));

    bool found = false;
    // Step 2+: check each value one by one
    for (int i = 0; i < _data.length; i++) {
      final isMatch = _data[i] == value;
      // Step 2a: Highlight current node in blue while checking
      final checkingNodes = _data.asMap().entries.map((entry) {
        final idx = entry.key;
        final val = entry.value;
        if (idx < i) {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.checkedNodeColor,
          );
        } else if (idx == i) {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.currentNodeColor,
          );
        } else {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.defaultNodeColor,
          );
        }
      }).toList();
      addAnimationStep(AnimationStep(
        description: 'Array Search: Step ${i * 2 + 2} of ${_data.length * 2 + 1}\nBlue highlight: Examining element at index $i\nRed elements: Previously checked (no match)\nGray elements: Not yet examined\nComparing: ${_data[i]} == $value?',
        code: 'if (array[$i] == $value) return $i',
        nodes: checkingNodes,
        highlightedLine: 1,
      ));
      // Step 2b: Show result of the check
      final resultNodes = _data.asMap().entries.map((entry) {
        final idx = entry.key;
        final val = entry.value;
        if (idx < i) {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.checkedNodeColor,
          );
        } else if (idx == i) {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: isMatch ? AppConstants.foundNodeColor : AppConstants.checkedNodeColor,
          );
        } else {
          return DataStructureNode(
            value: val,
            position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
            color: AppConstants.defaultNodeColor,
          );
        }
      }).toList();
      addAnimationStep(AnimationStep(
        description: isMatch
            ? 'Array Search: Step ${i * 2 + 3} of ${_data.length * 2 + 1}\nGreen highlight: Found $value at index $i!\nSearch successful - element located\nLinear search: O(n) operation completed successfully'
            : 'Array Search: Step ${i * 2 + 3} of ${_data.length * 2 + 1}\nRed highlight: ${_data[i]} ≠ $value\nElement at index $i doesn\'t match target\nContinuing search to next element',
        code: isMatch ? 'return $i' : 'continue',
        nodes: resultNodes,
        highlightedLine: 1,
      ));
      if (isMatch) {
        found = true;
        break;
      }
    }
    // If not found, add a final step showing all red
    if (!found) {
      final allRed = _data
          .asMap()
          .entries
          .map((entry) => DataStructureNode(
                value: entry.value,
                position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
                color: AppConstants.checkedNodeColor,
              ))
          .toList();
      addAnimationStep(AnimationStep(
        description: 'Array Search: Step ${_data.length * 2 + 1} of ${_data.length * 2 + 1}\nSearch completed: Value $value not found\nRed elements: All elements examined without match\nLinear search: O(n) operation completed unsuccessfully\nReturn value: -1 (not found)',
        code: 'return -1',
        nodes: allRed,
        highlightedLine: 1,
      ));
      AppLogger.dataStructure('Value $value not found in array');
    }
    // After operation, set nodes to reflect the true data
    setNodes(_data
        .asMap()
        .entries
        .map((entry) => DataStructureNode(
              value: entry.value,
              position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: null,
            ))
        .toList());
    currentStep = 0;
    AppLogger.dataStructure('Search completed. Final data count: ${_data.length}');
  }

  @override
  void traverse() {
    AppLogger.dataStructure('ArrayDataStructure.traverse called');
    AppLogger.dataStructure('Current data count: ${_data.length}');

    if (_data.isEmpty) {
      AppLogger.dataStructure('No data to traverse');
      return;
    }

    clearAnimationSteps();

    // Step 1: all gray
    final allGray = _data
        .asMap()
        .entries
        .map((entry) => DataStructureNode(
              value: entry.value,
              position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: AppConstants.defaultNodeColor,
            ))
        .toList();
    addAnimationStep(AnimationStep(
      description: 'Array Traversal: Step 1 of ${_data.length + 1}\nSequential Traversal Algorithm: Visiting all elements\nGray elements: Not yet visited\nO(n) operation: Must visit every element once\nTraversal pattern: Left to right (index 0 to ${_data.length - 1})',
      code: 'for (int i = 0; i < array.length; i++)',
      nodes: allGray,
      highlightedLine: 1,
      insights: 'Sequential traversal visits every element exactly once. This is the most common way to process all elements in an array.',
    ));
    // Step 2+: highlight each node blue, rest gray
    for (int i = 0; i < _data.length; i++) {
      final highlightedNodes = _data.asMap().entries.map((entry) {
        final idx = entry.key;
        final val = entry.value;
        return DataStructureNode(
          value: val,
          position: Offset(50.0 + (idx * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
          color: idx == i ? AppConstants.currentNodeColor : AppConstants.defaultNodeColor,
        );
      }).toList();
      addAnimationStep(AnimationStep(
        description: 'Array Traversal: Step ${i + 2} of ${_data.length + 1}\nBlue highlight: Visiting element at index $i (value: ${_data[i]})\nGray elements: Not yet visited\nSequential access: Processing element ${i + 1} of ${_data.length}\nO(1) operation: Direct array access',
        code: 'visit(array[$i])',
        nodes: highlightedNodes,
        highlightedLine: 1,
        insights: 'Direct array access at index $i is an O(1) operation. Arrays provide constant-time access to any element by index.',
      ));
    }
    // After operation, set nodes to reflect the true data
    setNodes(_data
        .asMap()
        .entries
        .map((entry) => DataStructureNode(
              value: entry.value,
              position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: null,
            ))
        .toList());
    currentStep = 0;
    AppLogger.dataStructure('Traverse completed. Final data count: ${_data.length}');
  }

  // Method to add nodes directly without animation (for bulk operations)
  void addNodesDirectly(List<int> values) {
    AppLogger.dataStructure('ArrayDataStructure.addNodesDirectly called with ${values.length} values');
    
    // Clear existing nodes and animation steps
    _data.clear();
    clearAnimationSteps();
    
    // Add all nodes directly
    for (int i = 0; i < values.length; i++) {
      _data.add(values[i]);
    }
    
    AppLogger.dataStructure('Added ${_data.length} nodes directly');
    // After operation, set nodes to reflect the true data
    setNodes(_data
        .asMap()
        .entries
        .map((entry) => DataStructureNode(
              value: entry.value,
              position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
              color: null,
            ))
        .toList());
    currentStep = 0;
  }

  // Method to update a node's value directly
  void updateNodeValue(int index, int newValue) {
    AppLogger.dataStructure('ArrayDataStructure.updateNodeValue called with index: $index, newValue: $newValue');
    
    if (index >= 0 && index < _data.length) {
      // Update the node's value while preserving other properties
      final oldValue = _data[index];
      _data[index] = newValue;
      
      AppLogger.dataStructure('Updated node at index $index from $oldValue to $newValue');
      // After operation, set nodes to reflect the true data
      setNodes(_data
          .asMap()
          .entries
          .map((entry) => DataStructureNode(
                value: entry.value,
                position: Offset(50.0 + (entry.key * AppConstants.nodeBoxWidth), AppConstants.nodeStartY),
                color: null,
              ))
          .toList());
      currentStep = 0;
    } else {
      AppLogger.dataStructure('Invalid index: $index (must be between 0 and ${_data.length - 1})');
    }
  }
} 