import 'package:flutter/material.dart';
import '../models/animation_step.dart';
import '../models/data_structure_node.dart';
import '../utils/constants.dart';

/// Service for building animation steps with consistent descriptions and formatting
/// Centralizes animation step creation to reduce code duplication
class AnimationStepBuilder {
  static const String _arrayPrefix = 'Array';
  static const String _linkedListPrefix = 'Linked List';

  /// Creates an animation step for array insertion operation
  static AnimationStep buildArrayInsertStep({
    required int stepNumber,
    required int totalSteps,
    required String operationType,
    required List<DataStructureNode> nodes,
    required String code,
    String? customDescription,
    String? insights,
    int highlightedLine = 1,
  }) {
    final description =
        customDescription ??
        _getDefaultInsertDescription(
          stepNumber: stepNumber,
          totalSteps: totalSteps,
          operationType: operationType,
          dataStructureType: _arrayPrefix,
        );

    return AnimationStep(
      description: description,
      code: code,
      nodes: nodes,
      highlightedLine: highlightedLine,
      insights: insights ?? '',
    );
  }

  /// Creates an animation step for array search operation
  static AnimationStep buildArraySearchStep({
    required int stepNumber,
    required int totalSteps,
    required int searchValue,
    required List<DataStructureNode> nodes,
    required String code,
    String? customDescription,
    String? insights,
    int highlightedLine = 1,
  }) {
    final description =
        customDescription ??
        _getDefaultSearchDescription(
          stepNumber: stepNumber,
          totalSteps: totalSteps,
          searchValue: searchValue,
          dataStructureType: _arrayPrefix,
        );

    return AnimationStep(
      description: description,
      code: code,
      nodes: nodes,
      highlightedLine: highlightedLine,
      insights: insights ?? '',
    );
  }

  /// Creates an animation step for array deletion operation
  static AnimationStep buildArrayDeleteStep({
    required int stepNumber,
    required int totalSteps,
    required int deleteValue,
    required List<DataStructureNode> nodes,
    required String code,
    String? customDescription,
    String? insights,
    int highlightedLine = 1,
  }) {
    final description =
        customDescription ??
        _getDefaultDeleteDescription(
          stepNumber: stepNumber,
          totalSteps: totalSteps,
          deleteValue: deleteValue,
          dataStructureType: _arrayPrefix,
        );

    return AnimationStep(
      description: description,
      code: code,
      nodes: nodes,
      highlightedLine: highlightedLine,
      insights: insights ?? '',
    );
  }

  /// Creates an animation step for array traversal operation
  static AnimationStep buildArrayTraversalStep({
    required int stepNumber,
    required int totalSteps,
    required List<DataStructureNode> nodes,
    required String code,
    String? customDescription,
    String? insights,
    int highlightedLine = 1,
  }) {
    final description =
        customDescription ??
        _getDefaultTraversalDescription(
          stepNumber: stepNumber,
          totalSteps: totalSteps,
          dataStructureType: _arrayPrefix,
        );

    return AnimationStep(
      description: description,
      code: code,
      nodes: nodes,
      highlightedLine: highlightedLine,
      insights: insights ?? '',
    );
  }

  /// Creates an animation step for linked list operations
  static AnimationStep buildLinkedListStep({
    required int stepNumber,
    required int totalSteps,
    required String operationType,
    required List<DataStructureNode> nodes,
    required String code,
    String? customDescription,
    String? insights,
    int highlightedLine = 1,
  }) {
    final description =
        customDescription ??
        _getDefaultLinkedListDescription(
          stepNumber: stepNumber,
          totalSteps: totalSteps,
          operationType: operationType,
        );

    return AnimationStep(
      description: description,
      code: code,
      nodes: nodes,
      highlightedLine: highlightedLine,
      insights: insights ?? '',
    );
  }

  /// Creates a colored node list for step-by-step animations
  static List<DataStructureNode> createColoredNodes({
    required List<DataStructureNode> baseNodes,
    int? currentIndex,
    int? foundIndex,
    List<int>? checkedIndices,
    List<int>? insertionIndices,
    Color? defaultColor,
  }) {
    defaultColor ??= AppConstants.defaultNodeColor;

    return baseNodes.asMap().entries.map((entry) {
      final index = entry.key;
      final node = entry.value;

      Color nodeColor = defaultColor!;

      if (checkedIndices?.contains(index) == true) {
        nodeColor = AppConstants.checkedNodeColor;
      }
      if (currentIndex == index) {
        nodeColor = AppConstants.currentNodeColor;
      }
      if (foundIndex == index) {
        nodeColor = AppConstants.foundNodeColor;
      }
      if (insertionIndices?.contains(index) == true) {
        nodeColor = AppConstants.insertionNodeColor;
      }

      return node.copyWith(color: nodeColor);
    }).toList();
  }

  /// Creates positioned nodes for arrays with proper spacing
  static List<DataStructureNode> createPositionedArrayNodes({
    required List<int> values,
    double startX = 50.0,
    double startY = 40.0,
    double spacing = 80.0,
  }) {
    return values.asMap().entries.map((entry) {
      return DataStructureNode(
        value: entry.value,
        position: Offset(startX + (entry.key * spacing), startY),
        color: null,
      );
    }).toList();
  }

  // Private helper methods for generating default descriptions

  static String _getDefaultInsertDescription({
    required int stepNumber,
    required int totalSteps,
    required String operationType,
    required String dataStructureType,
  }) {
    if (stepNumber == 1) {
      return '$dataStructureType Insertion: Step $stepNumber of $totalSteps\n$operationType operation initiated\nAnalyzing current structure state';
    } else if (stepNumber == totalSteps) {
      return '$dataStructureType Insertion: Step $stepNumber of $totalSteps\nInsertion completed successfully\nStructure updated with new element';
    } else {
      return '$dataStructureType Insertion: Step $stepNumber of $totalSteps\n$operationType in progress\nProcessing element';
    }
  }

  static String _getDefaultSearchDescription({
    required int stepNumber,
    required int totalSteps,
    required int searchValue,
    required String dataStructureType,
  }) {
    if (stepNumber == 1) {
      return '$dataStructureType Search: Step $stepNumber of $totalSteps\nLinear Search Algorithm: Finding element $searchValue\nStarting sequential examination';
    } else if (stepNumber == totalSteps) {
      return '$dataStructureType Search: Step $stepNumber of $totalSteps\nSearch completed\nTarget element located or not found';
    } else {
      return '$dataStructureType Search: Step $stepNumber of $totalSteps\nExamining element\nContinuing search for $searchValue';
    }
  }

  static String _getDefaultDeleteDescription({
    required int stepNumber,
    required int totalSteps,
    required int deleteValue,
    required String dataStructureType,
  }) {
    if (stepNumber == 1) {
      return '$dataStructureType Deletion: Step $stepNumber of $totalSteps\nDeletion Algorithm: Removing element $deleteValue\nStarting search for target element';
    } else if (stepNumber == totalSteps) {
      return '$dataStructureType Deletion: Step $stepNumber of $totalSteps\nDeletion completed\nElement removed and structure reorganized';
    } else {
      return '$dataStructureType Deletion: Step $stepNumber of $totalSteps\nSearching for target element\nExamining current position';
    }
  }

  static String _getDefaultTraversalDescription({
    required int stepNumber,
    required int totalSteps,
    required String dataStructureType,
  }) {
    if (stepNumber == 1) {
      return '$dataStructureType Traversal: Step $stepNumber of $totalSteps\nSequential Traversal Algorithm: Visiting all elements\nTraversal pattern: Sequential access';
    } else if (stepNumber == totalSteps) {
      return '$dataStructureType Traversal: Step $stepNumber of $totalSteps\nTraversal completed\nAll elements visited';
    } else {
      return '$dataStructureType Traversal: Step $stepNumber of $totalSteps\nVisiting element\nSequential access pattern';
    }
  }

  static String _getDefaultLinkedListDescription({
    required int stepNumber,
    required int totalSteps,
    required String operationType,
  }) {
    return '$_linkedListPrefix $operationType: Step $stepNumber of $totalSteps\nProcessing linked list operation\nTraversing node connections';
  }
}
