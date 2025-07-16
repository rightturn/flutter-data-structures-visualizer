import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_node.dart';
import '../models/animation_step.dart';
import '../utils/logger.dart';
import '../utils/constants.dart';
import '../services/validation_service.dart';

class QueueDataStructure extends BaseDataStructure {
  // Queue follows FIFO (First In, First Out) principle
  // Front of queue is at index 0, rear is at the end

  /// Enqueue operation: Adds element to the rear of the queue
  @override
  void insert(int value) {
    enqueue(value);
  }

  /// Dequeue operation: Removes element from the front of the queue
  @override
  void delete(int value) {
    dequeue();
  }

  /// Front operation: Returns the front element without removing it
  @override
  void search(int value) {
    front();
  }

  /// Enqueue operation: Adds element to the rear of the queue
  void enqueue(int value) {
    AppLogger.dataStructure('QueueDataStructure.enqueue called with value: $value');
    
    try {
      // Validate input
      final validation = ValidationService.validateDataStructureState(
        nodes: nodes,
        operationType: 'enqueue',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure('Enqueue validation failed: ${validation.errorMessage}');
        return;
      }
      
      clearAnimationSteps();
      final currentNodes = List<DataStructureNode>.from(this.nodes);
      
      // Step 1: Show current queue state
      addAnimationStep(AnimationStep(
        description: 'Queue Enqueue: Step 1 of 3\nPreparing to enqueue value $value to the rear\nQueue follows FIFO (First In, First Out) principle\nNew element will be added at the rear',
        code: 'queue.enqueue($value);',
        nodes: currentNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Enqueue operation adds element to the rear of the queue. Queue size: ${currentNodes.length}'
      ));
      
      // Step 2: Show new node being added to rear
      final newNode = DataStructureNode(
        value: value,
        position: const Offset(0, 0), // Let renderer handle positioning
        color: AppConstants.insertionNodeColor,
        next: null,
        prev: null,
      );
      final updatedNodes = [...currentNodes, newNode]; // Add to end (rear)
      
      addAnimationStep(AnimationStep(
        description: 'Queue Enqueue: Step 2 of 3\nOrange highlight: New element $value added to rear\nQueue size increased to ${updatedNodes.length}\nO(1) time complexity: Constant time operation',
        code: 'queue.enqueue($value);',
        nodes: List.generate(updatedNodes.length, (j) =>
          updatedNodes[j].copyWith(color: j == updatedNodes.length - 1 ? AppConstants.insertionNodeColor : AppConstants.defaultNodeColor)),
        highlightedLine: 1,
        insights: 'New element is now at the rear of the queue. Enqueue operation is O(1) - very efficient.'
      ));
      
      // Final step: Reset colors
      addAnimationStep(AnimationStep(
        description: 'Queue Enqueue: Step 3 of 3\nEnqueue operation completed successfully\nElement $value is now at the rear of the queue\nQueue size: ${updatedNodes.length}',
        code: 'queue.rear = $value;',
        nodes: updatedNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Enqueue complete! The queue now has ${updatedNodes.length} elements with $value at the rear.'
      ));
      
      setNodes(updatedNodes);
      currentStep = 0;
    } catch (e) {
      AppLogger.dataStructure('Enqueue error: $e');
    }
  }

  /// Dequeue operation: Removes element from the front of the queue
  void dequeue() {
    AppLogger.dataStructure('QueueDataStructure.dequeue called');
    
    try {
      final currentNodes = List<DataStructureNode>.from(this.nodes);
      
      // Validate queue state
      final validation = ValidationService.validateDataStructureState(
        nodes: currentNodes,
        operationType: 'dequeue',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure('Dequeue validation failed: ${validation.errorMessage}');
        return;
      }
      
      clearAnimationSteps();
      final frontValue = currentNodes.first.value; // Front is first element
      
      // Step 1: Show current queue state
      addAnimationStep(AnimationStep(
        description: 'Queue Dequeue: Step 1 of 3\nPreparing to dequeue the front value from queue\nCurrent front value: $frontValue\nQueue size: ${currentNodes.length}',
        code: 'int frontValue = queue.dequeue();',
        nodes: currentNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Dequeue operation removes the front element from the queue. Queue follows FIFO principle.'
      ));
      
      // Step 2: Highlight front node being removed
      addAnimationStep(AnimationStep(
        description: 'Queue Dequeue: Step 2 of 3\nBlue highlight: Front element $frontValue being removed\nO(1) time complexity: Constant time operation\nQueue size will decrease to ${currentNodes.length - 1}',
        code: 'return $frontValue;',
        nodes: List.generate(currentNodes.length, (j) =>
          currentNodes[j].copyWith(color: j == 0 ? AppConstants.currentNodeColor : AppConstants.defaultNodeColor)),
        highlightedLine: 1,
        insights: 'The blue highlight shows the element being dequeued from the front of the queue.'
      ));
      
      // Step 3: Show queue after removal
      final updatedNodes = List<DataStructureNode>.from(currentNodes);
      updatedNodes.removeAt(0); // Remove first element (front)
      
      addAnimationStep(AnimationStep(
        description: 'Queue Dequeue: Step 3 of 3\nFront element $frontValue successfully removed\nQueue size decreased to ${updatedNodes.length}\nDequeue operation completed',
        code: 'queue.size = ${updatedNodes.length};',
        nodes: updatedNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Dequeue complete! Element $frontValue was removed. Queue now has ${updatedNodes.length} elements.'
      ));
      
      setNodes(updatedNodes);
      currentStep = 0;
    } catch (e) {
      AppLogger.dataStructure('Dequeue error: $e');
    }
  }

  /// Front operation: Returns the front element without removing it
  void front() {
    AppLogger.dataStructure('QueueDataStructure.front called');
    
    try {
      final currentNodes = List<DataStructureNode>.from(this.nodes);
      
      // Validate queue state
      final validation = ValidationService.validateDataStructureState(
        nodes: currentNodes,
        operationType: 'front',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure('Front validation failed: ${validation.errorMessage}');
        return;
      }
      
      clearAnimationSteps();
      final frontValue = currentNodes.first.value; // Front is first element
      
      // Step 1: Show current queue state
      addAnimationStep(AnimationStep(
        description: 'Queue Front: Step 1 of 2\nPreparing to view the front value\nFront operation does not modify the queue\nQueue size: ${currentNodes.length}',
        code: 'int frontValue = queue.front();',
        nodes: currentNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Front operation allows you to view the front element without removing it from the queue.'
      ));
      
      // Step 2: Highlight front node
      addAnimationStep(AnimationStep(
        description: 'Queue Front: Step 2 of 2\nGreen highlight: Front value is $frontValue\nO(1) time complexity: Constant time operation\nQueue remains unchanged with ${currentNodes.length} elements',
        code: 'return $frontValue;',
        nodes: List.generate(currentNodes.length, (j) =>
          currentNodes[j].copyWith(color: j == 0 ? AppConstants.foundNodeColor : AppConstants.defaultNodeColor)),
        highlightedLine: 1,
        insights: 'The green highlight shows the front element. Front is non-destructive - queue remains unchanged.'
      ));
      
      setNodes(currentNodes); // No changes to the queue
      currentStep = 0;
    } catch (e) {
      AppLogger.dataStructure('Front error: $e');
    }
  }

  /// Traverse operation: Visits all elements from front to rear
  @override
  void traverse() {
    AppLogger.dataStructure('QueueDataStructure.traverse called');
    
    try {
      final currentNodes = List<DataStructureNode>.from(this.nodes);
      
      // Validate queue state
      final validation = ValidationService.validateDataStructureState(
        nodes: currentNodes,
        operationType: 'traverse',
      );
      if (!validation.isValid) {
        AppLogger.dataStructure('Traverse validation failed: ${validation.errorMessage}');
        return;
      }
      
      clearAnimationSteps();
      
      // Step 1: Show initial state
      addAnimationStep(AnimationStep(
        description: 'Queue Traversal: Step 1 of ${currentNodes.length + 1}\nStarting traversal from front to rear\nQueue follows FIFO principle for access\nTotal elements: ${currentNodes.length}',
        code: 'for (int i = front; i < rear; i++)',
        nodes: currentNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Queue traversal typically goes from front to rear, following the FIFO access pattern.'
      ));
      
      // Step 2+: Visit each node from front to rear
      for (int i = 0; i < currentNodes.length; i++) {
        addAnimationStep(AnimationStep(
          description: 'Queue Traversal: Step ${i + 2} of ${currentNodes.length + 1}\nBlue highlight: Visiting element at position ${i + 1} from front\nValue: ${currentNodes[i].value}\nO(n) operation: Must visit each element once',
          code: 'visit(queue[$i]);',
          nodes: List.generate(currentNodes.length, (j) =>
            currentNodes[j].copyWith(color: j == i ? AppConstants.currentNodeColor : AppConstants.defaultNodeColor)),
          highlightedLine: 1,
          insights: 'Currently visiting element ${currentNodes[i].value} at position ${i + 1} from the front.'
        ));
      }
      
      // Final step: Reset colors
      addAnimationStep(AnimationStep(
        description: 'Queue Traversal: Step ${currentNodes.length + 1} of ${currentNodes.length + 1}\nTraversal completed successfully\nAll ${currentNodes.length} elements visited\nQueue structure remains unchanged',
        code: 'end traversal;',
        nodes: currentNodes.map((n) => n.copyWith(color: AppConstants.defaultNodeColor)).toList(),
        highlightedLine: 1,
        insights: 'Traversal complete! All elements have been visited. Queue structure is unchanged.'
      ));
      
      setNodes(currentNodes);
      currentStep = 0;
    } catch (e) {
      AppLogger.dataStructure('Traverse error: $e');
    }
  }

  /// Check if the queue is empty
  bool isEmpty() {
    return nodes.isEmpty;
  }
  
  /// Get the size of the queue
  int size() {
    return nodes.length;
  }
  
  /// Get the front element without removing it
  int? frontValue() {
    if (nodes.isEmpty) return null;
    return nodes.first.value;
  }
  
  /// Get the rear element without removing it
  int? rearValue() {
    if (nodes.isEmpty) return null;
    return nodes.last.value;
  }
} 