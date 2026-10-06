import 'data_structure_node.dart';
import 'animation_step.dart';
import '../utils/logger.dart';
import 'package:flutter/foundation.dart';

abstract class BaseDataStructure {
  List<DataStructureNode> _nodes = [];
  List<AnimationStep> _animationSteps = [];
  int currentStep = 0;

  List<DataStructureNode> get nodes => _nodes;
  List<AnimationStep> get animationSteps => _animationSteps;

  // Protected setter for subclasses
  @protected
  void setNodes(List<DataStructureNode> nodes) {
    _nodes = nodes;
  }

  bool get isAtEnd => currentStep >= _animationSteps.length - 1;
  bool get isAtStart => currentStep <= 0;

  void reset() {
    currentStep = 0;
    _nodes = [];
    _animationSteps = [];
  }

  void resetToDefault() {
    AppLogger.dataStructure('BaseDataStructure.resetToDefault called');
    AppLogger.dataStructure(
      'Before reset: ${_nodes.length} nodes, ${_animationSteps.length} animation steps',
    );

    // Clear animation steps first
    _animationSteps.clear();
    currentStep = 0;

    // Reset to default state: clear colors, preserve data
    _nodes = _nodes
        .map(
          (node) => DataStructureNode(
            value: node.value,
            position: node.position,
            color: null, // Explicitly set to null
            label: node.label,
            children: node.children,
            next: node.next,
            prev: node.prev,
          ),
        )
        .toList();

    AppLogger.dataStructure(
      'After reset: ${_nodes.length} nodes, ${_animationSteps.length} animation steps',
    );
    AppLogger.dataStructure(
      'Node colors after reset: ${_nodes.map((n) => n.color).toList()}',
    );
  }

  void nextStep() {
    if (!isAtEnd) {
      currentStep++;
      updateNodes();
    }
  }

  void previousStep() {
    if (!isAtStart) {
      currentStep--;
      updateNodes();
    }
  }

  void goToStep(int step) {
    AppLogger.dataStructure(
      'BaseDataStructure.goToStep called with step: $step, animation steps length: ${_animationSteps.length}',
    );
    if (step >= 0 && step < _animationSteps.length) {
      currentStep = step;
      updateNodes();
      AppLogger.dataStructure('Successfully went to step: $currentStep');
    } else {
      AppLogger.dataStructure(
        'Invalid step: $step (must be between 0 and ${_animationSteps.length - 1})',
      );
    }
  }

  void updateNodes() {
    AppLogger.dataStructure(
      'updateNodes called. Current step: $currentStep, animation steps: ${_animationSteps.length}',
    );
    if (currentStep < _animationSteps.length) {
      _nodes = _animationSteps[currentStep].nodes;
      AppLogger.dataStructure(
        'Nodes updated from animation step. New count: ${_nodes.length}',
      );
    } else {
      AppLogger.dataStructure(
        'No animation step available, keeping current nodes. Count: ${_nodes.length}',
      );
    }
  }

  void addAnimationStep(AnimationStep step) {
    _animationSteps.add(step);
  }

  void clearAnimationSteps() {
    _animationSteps.clear();
    currentStep = 0;
  }

  // Common operations
  void insert(int value);
  void delete(int value);
  void search(int value);
  void traverse();
}
