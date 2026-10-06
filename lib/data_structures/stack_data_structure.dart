import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_node.dart';
import '../models/animation_step.dart';
import '../utils/constants.dart';
import '../services/validation_service.dart';
import '../services/error_handler.dart';
import '../utils/logger.dart';

class StackDataStructure extends BaseDataStructure {
  // Stack follows LIFO (Last In, First Out) principle
  // The top of the stack is the first element in the nodes list

  /// Push operation: Adds a new element to the top of the stack
  @override
  void insert(int value) {
    AppLogger.dataStructure(
      'StackDataStructure.insert (push) called with value: $value',
    );

    try {
      // Validate input
      final validation = ValidationService.validateDataStructureState(
        nodes: nodes,
        operationType: 'push',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure(
          'Push validation failed: ${validation.errorMessage}',
        );
        return;
      }

      clearAnimationSteps();
      final currentNodes = List<DataStructureNode>.from(this.nodes);

      // Step 1: Show current stack state
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Push: Step 1 of 3\nPreparing to push value $value onto the stack\nStack follows LIFO (Last In, First Out) principle\nNew element will become the new top',
          code: 'stack.push($value);',
          nodes: currentNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Push operation adds element to the top of the stack. Stack size: ${currentNodes.length}',
        ),
      );

      // Step 2: Show new node being added to top
      final newNode = DataStructureNode(
        value: value,
        position: const Offset(0, 0), // Let renderer handle positioning
        color: AppConstants.insertionNodeColor,
        next: null,
        prev: null,
      );
      final updatedNodes = [
        ...currentNodes,
        newNode,
      ]; // Add to end (grows upward)

      addAnimationStep(
        AnimationStep(
          description:
              'Stack Push: Step 2 of 3\nOrange highlight: New element $value added to top\nStack size increased to ${updatedNodes.length}\nO(1) time complexity: Constant time operation',
          code: 'stack.push($value);',
          nodes: List.generate(
            updatedNodes.length,
            (j) => updatedNodes[j].copyWith(
              color: j == updatedNodes.length - 1
                  ? AppConstants.insertionNodeColor
                  : AppConstants.defaultNodeColor,
            ),
          ),
          highlightedLine: 1,
          insights:
              'New element is now at the top of the stack. Push operation is O(1) - very efficient.',
        ),
      );

      // Final step: Reset colors
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Push: Step 3 of 3\nPush operation completed successfully\nElement $value is now at the top of the stack\nStack size: ${updatedNodes.length}',
          code: 'stack.top = $value;',
          nodes: updatedNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Push complete! The stack now has ${updatedNodes.length} elements with $value at the top.',
        ),
      );

      setNodes(updatedNodes);
      currentStep = 0;
    } catch (e) {
      final errorMessage = ErrorHandler.handleDataStructureError(
        'Stack',
        'Push',
        e as Exception,
      );
      AppLogger.dataStructure('Push error: $errorMessage');
    }
  }

  /// Pop operation: Removes and returns the top element from the stack
  @override
  void delete(int value) {
    // For stack, delete operation is pop (ignores the value parameter)
    pop();
  }

  /// Pop operation: Removes the top element from the stack
  void pop() {
    AppLogger.dataStructure('StackDataStructure.pop called');

    try {
      final currentNodes = List<DataStructureNode>.from(this.nodes);

      // Validate stack state
      final validation = ValidationService.validateDataStructureState(
        nodes: currentNodes,
        operationType: 'pop',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure(
          'Pop validation failed: ${validation.errorMessage}',
        );
        return;
      }

      clearAnimationSteps();
      final topValue = currentNodes.last.value; // Top is last element

      // Step 1: Show current stack state
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Pop: Step 1 of 3\nPreparing to pop the top value from stack\nCurrent top value: $topValue\nStack size: ${currentNodes.length}',
          code: 'int topValue = stack.pop();',
          nodes: currentNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Pop operation removes the top element from the stack. Stack follows LIFO principle.',
        ),
      );

      // Step 2: Highlight top node being removed
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Pop: Step 2 of 3\nBlue highlight: Top element $topValue being removed\nO(1) time complexity: Constant time operation\nStack size will decrease to ${currentNodes.length - 1}',
          code: 'return $topValue;',
          nodes: List.generate(
            currentNodes.length,
            (j) => currentNodes[j].copyWith(
              color: j == currentNodes.length - 1
                  ? AppConstants.currentNodeColor
                  : AppConstants.defaultNodeColor,
            ),
          ),
          highlightedLine: 1,
          insights:
              'The blue highlight shows the element being popped from the top of the stack.',
        ),
      );

      // Step 3: Show stack after removal
      final updatedNodes = List<DataStructureNode>.from(currentNodes);
      updatedNodes.removeLast(); // Remove last element (top)

      addAnimationStep(
        AnimationStep(
          description:
              'Stack Pop: Step 3 of 3\nTop element $topValue successfully removed\nStack size decreased to ${updatedNodes.length}\nPop operation completed',
          code: 'stack.size = ${updatedNodes.length};',
          nodes: updatedNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Pop complete! Element $topValue was removed. Stack now has ${updatedNodes.length} elements.',
        ),
      );

      setNodes(updatedNodes);
      currentStep = 0;
    } catch (e) {
      final errorMessage = ErrorHandler.handleDataStructureError(
        'Stack',
        'Pop',
        e as Exception,
      );
      AppLogger.dataStructure('Pop error: $errorMessage');
    }
  }

  /// Search operation: For stack, this performs a peek operation
  @override
  void search(int value) {
    // For stack, search operation is peek (ignores the value parameter)
    peek();
  }

  /// Peek operation: Returns the top element without removing it
  void peek() {
    AppLogger.dataStructure('StackDataStructure.peek called');

    try {
      final currentNodes = List<DataStructureNode>.from(this.nodes);

      // Validate stack state
      final validation = ValidationService.validateDataStructureState(
        nodes: currentNodes,
        operationType: 'peek',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure(
          'Peek validation failed: ${validation.errorMessage}',
        );
        return;
      }

      clearAnimationSteps();
      final topValue = currentNodes.last.value; // Top is last element

      // Step 1: Show current stack state
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Peek: Step 1 of 2\nPreparing to peek at the top value\nPeek operation does not modify the stack\nStack size: ${currentNodes.length}',
          code: 'int topValue = stack.peek();',
          nodes: currentNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Peek operation allows you to view the top element without removing it from the stack.',
        ),
      );

      // Step 2: Highlight top node
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Peek: Step 2 of 2\nGreen highlight: Top value is $topValue\nO(1) time complexity: Constant time operation\nStack remains unchanged with ${currentNodes.length} elements',
          code: 'return $topValue;',
          nodes: List.generate(
            currentNodes.length,
            (j) => currentNodes[j].copyWith(
              color: j == currentNodes.length - 1
                  ? AppConstants.foundNodeColor
                  : AppConstants.defaultNodeColor,
            ),
          ),
          highlightedLine: 1,
          insights:
              'The green highlight shows the top element. Peek is non-destructive - stack remains unchanged.',
        ),
      );

      setNodes(currentNodes); // No changes to the stack
      currentStep = 0;
    } catch (e) {
      final errorMessage = ErrorHandler.handleDataStructureError(
        'Stack',
        'Peek',
        e as Exception,
      );
      AppLogger.dataStructure('Peek error: $errorMessage');
    }
  }

  /// Traverse operation: Visits all elements from top to bottom
  @override
  void traverse() {
    AppLogger.dataStructure('StackDataStructure.traverse called');

    try {
      final currentNodes = List<DataStructureNode>.from(this.nodes);

      // Validate stack state
      final validation = ValidationService.validateDataStructureState(
        nodes: currentNodes,
        operationType: 'traverse',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure(
          'Traverse validation failed: ${validation.errorMessage}',
        );
        return;
      }

      clearAnimationSteps();

      // Step 1: Show initial state
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Traversal: Step 1 of ${currentNodes.length + 1}\nStarting traversal from top to bottom\nStack follows LIFO principle for access\nTotal elements: ${currentNodes.length}',
          code: 'for (int i = top; i >= 0; i--)',
          nodes: currentNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Stack traversal typically goes from top to bottom, following the LIFO access pattern.',
        ),
      );

      // Step 2+: Visit each node from top to bottom (last to first)
      for (int i = 0; i < currentNodes.length; i++) {
        final currentIndex =
            currentNodes.length - 1 - i; // Start from top (last element)
        addAnimationStep(
          AnimationStep(
            description:
                'Stack Traversal: Step ${i + 2} of ${currentNodes.length + 1}\nBlue highlight: Visiting element at position ${i + 1} from top\nValue: ${currentNodes[currentIndex].value}\nO(n) operation: Must visit each element once',
            code: 'visit(stack[$i]);',
            nodes: List.generate(
              currentNodes.length,
              (j) => currentNodes[j].copyWith(
                color: j == currentIndex
                    ? AppConstants.currentNodeColor
                    : AppConstants.defaultNodeColor,
              ),
            ),
            highlightedLine: 1,
            insights:
                'Currently visiting element ${currentNodes[currentIndex].value} at position ${i + 1} from the top.',
          ),
        );
      }

      // Final step: Reset colors
      addAnimationStep(
        AnimationStep(
          description:
              'Stack Traversal: Step ${currentNodes.length + 1} of ${currentNodes.length + 1}\nTraversal completed successfully\nAll ${currentNodes.length} elements visited\nStack structure remains unchanged',
          code: 'end traversal;',
          nodes: currentNodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Traversal complete! All elements have been visited. Stack structure is unchanged.',
        ),
      );

      setNodes(currentNodes);
      currentStep = 0;
    } catch (e) {
      final errorMessage = ErrorHandler.handleDataStructureError(
        'Stack',
        'Traverse',
        e as Exception,
      );
      AppLogger.dataStructure('Traverse error: $errorMessage');
    }
  }

  /// Method to add nodes directly without animation (for bulk operations)
  void addNodesDirectly(List<int> values) {
    AppLogger.dataStructure(
      'StackDataStructure.addNodesDirectly called with ${values.length} values',
    );

    clearAnimationSteps();

    // Create nodes with proper positioning (let renderer handle positioning)
    final nodes = <DataStructureNode>[];
    for (int i = 0; i < values.length; i++) {
      nodes.add(
        DataStructureNode(
          value: values[i],
          position: const Offset(0, 0), // Let renderer handle positioning
          color: null,
          next: null,
          prev: null,
        ),
      );
    }

    setNodes(nodes);
    currentStep = 0;
    AppLogger.dataStructure('Added ${nodes.length} nodes directly to stack');
  }

  /// Check if the stack is empty
  bool isEmpty() {
    return nodes.isEmpty;
  }

  /// Get the size of the stack
  int size() {
    return nodes.length;
  }

  /// Get the top element without removing it (same as peek but returns value)
  int? top() {
    if (nodes.isEmpty) return null;
    return nodes.last.value;
  }
}
