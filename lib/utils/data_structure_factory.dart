import 'package:flutter/material.dart';
import '../models/data_structure.dart';

class DataStructureFactory {
  static const List<DataStructureInfo> dataStructures = [
    DataStructureInfo(
      type: DataStructureType.array,
      name: 'Arrays',
      description: 'A collection of elements stored at contiguous memory locations.',
      icon: Icons.view_array,
      color: Colors.blue,
      operations: ['Insert', 'Delete', 'Search', 'Traverse'],
    ),
    DataStructureInfo(
      type: DataStructureType.linkedList,
      name: 'Linked Lists',
      description: 'A linear data structure where elements are stored in nodes with references to the next node.',
      icon: Icons.link,
      color: Colors.green,
      operations: ['Insert', 'Delete', 'Search', 'Traverse'],
    ),
    DataStructureInfo(
      type: DataStructureType.stack,
      name: 'Stacks',
      description: 'A LIFO (Last In, First Out) data structure where elements are added and removed from the top.',
      icon: Icons.layers,
      color: Colors.orange,
      operations: ['Push', 'Pop', 'Peek', 'IsEmpty'],
    ),
    DataStructureInfo(
      type: DataStructureType.queue,
      name: 'Queues',
      description: 'A FIFO (First In, First Out) data structure where elements are added at the rear and removed from the front.',
      icon: Icons.queue,
      color: Colors.purple,
      operations: ['Enqueue', 'Dequeue', 'Front', 'IsEmpty'],
    ),
    DataStructureInfo(
      type: DataStructureType.binaryTree,
      name: 'Binary Trees',
      description: 'A hierarchical data structure where each node has at most two children.',
      icon: Icons.account_tree,
      color: Colors.teal,
      operations: ['Insert', 'Delete', 'Search', 'Traverse'],
    ),
    DataStructureInfo(
      type: DataStructureType.binarySearchTree,
      name: 'Binary Search Trees',
      description: 'A binary tree where the left subtree contains nodes with values less than the parent node.',
      icon: Icons.search,
      color: Colors.indigo,
      operations: ['Insert', 'Delete', 'Search', 'Traverse'],
    ),
    DataStructureInfo(
      type: DataStructureType.minHeap,
      name: 'Min Heaps',
      description: 'A complete binary tree where the parent node is always smaller than or equal to its children.',
      icon: Icons.trending_down,
      color: Colors.red,
      operations: ['Insert', 'Extract Min', 'Heapify', 'Build Heap'],
    ),
    DataStructureInfo(
      type: DataStructureType.maxHeap,
      name: 'Max Heaps',
      description: 'A complete binary tree where the parent node is always larger than or equal to its children.',
      icon: Icons.trending_up,
      color: Colors.amber,
      operations: ['Insert', 'Extract Max', 'Heapify', 'Build Heap'],
    ),
    DataStructureInfo(
      type: DataStructureType.graph,
      name: 'Graphs',
      description: 'A collection of vertices connected by edges, representing relationships between objects.',
      icon: Icons.grain,
      color: Colors.pink,
      operations: ['Add Vertex', 'Add Edge', 'DFS', 'BFS'],
    ),
  ];

  static DataStructureInfo getInfo(DataStructureType type) {
    return dataStructures.firstWhere((ds) => ds.type == type);
  }

  static DataStructure createDataStructure(DataStructureType type) {
    switch (type) {
      case DataStructureType.array:
        return ArrayDataStructure();
      case DataStructureType.linkedList:
        return LinkedListDataStructure();
      case DataStructureType.stack:
        return StackDataStructure();
      case DataStructureType.queue:
        return QueueDataStructure();
      case DataStructureType.binaryTree:
        return BinaryTreeDataStructure();
      case DataStructureType.binarySearchTree:
        return BinarySearchTreeDataStructure();
      case DataStructureType.minHeap:
        return MinHeapDataStructure();
      case DataStructureType.maxHeap:
        return MaxHeapDataStructure();
      case DataStructureType.graph:
        return GraphDataStructure();
    }
  }

  static String getTypeString(DataStructureType type) {
    switch (type) {
      case DataStructureType.array:
        return 'array';
      case DataStructureType.linkedList:
        return 'linkedList';
      case DataStructureType.stack:
        return 'stack';
      case DataStructureType.queue:
        return 'queue';
      case DataStructureType.binaryTree:
        return 'binaryTree';
      case DataStructureType.binarySearchTree:
        return 'binarySearchTree';
      case DataStructureType.minHeap:
        return 'minHeap';
      case DataStructureType.maxHeap:
        return 'maxHeap';
      case DataStructureType.graph:
        return 'graph';
    }
  }

  static DataStructureType getTypeFromString(String typeString) {
    switch (typeString) {
      case 'array':
        return DataStructureType.array;
      case 'linkedList':
        return DataStructureType.linkedList;
      case 'stack':
        return DataStructureType.stack;
      case 'queue':
        return DataStructureType.queue;
      case 'binaryTree':
        return DataStructureType.binaryTree;
      case 'binarySearchTree':
        return DataStructureType.binarySearchTree;
      case 'minHeap':
        return DataStructureType.minHeap;
      case 'maxHeap':
        return DataStructureType.maxHeap;
      case 'graph':
        return DataStructureType.graph;
      default:
        return DataStructureType.array;
    }
  }
}

// Placeholder implementations for other data structures
class StackDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(200.0, 100.0 + (_nodes.length * 60.0)),
      color: Colors.orange,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Pushed $value',
      code: 'stack.push($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    if (_nodes.isNotEmpty) {
      // Remove the last node (top of stack)
      _nodes.removeLast();
      
      // Create a single animation step showing the final result
      _animationSteps.clear();
      _animationSteps.add(AnimationStep(
        description: 'Popped top element',
        code: 'stack.pop()',
        nodes: List.from(_nodes),
        highlightedLine: 1,
      ));
      
      _currentStep = 0;
      _updateNodes();
    }
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for $value in stack',
      code: 'stack.contains($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing stack from top to bottom',
      code: 'for (var item in stack.reversed)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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

class QueueDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(50.0 + (_nodes.length * 80.0), 200.0),
      color: Colors.purple,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Enqueued $value',
      code: 'queue.enqueue($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    if (_nodes.isNotEmpty) {
      // Remove the first node (front of queue)
      _nodes.removeAt(0);
      
      // Create a single animation step showing the final result
      _animationSteps.clear();
      _animationSteps.add(AnimationStep(
        description: 'Dequeued front element',
        code: 'queue.dequeue()',
        nodes: List.from(_nodes),
        highlightedLine: 1,
      ));
      
      _currentStep = 0;
      _updateNodes();
    }
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for $value in queue',
      code: 'queue.contains($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing queue from front to rear',
      code: 'for (var item in queue)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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

class BinaryTreeDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(200.0, 100.0),
      color: Colors.teal,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Inserted $value',
      code: 'tree.insert($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Starting binary tree deletion',
      code: 'tree.delete($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for $value in binary tree',
      code: 'tree.search($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing binary tree (in-order)',
      code: 'tree.inOrderTraversal()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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

class BinarySearchTreeDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(200.0, 100.0),
      color: Colors.indigo,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Inserted $value',
      code: 'bst.insert($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Starting BST deletion',
      code: 'bst.delete($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for $value in BST',
      code: 'bst.search($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing BST (in-order)',
      code: 'bst.inOrderTraversal()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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

class MinHeapDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(200.0, 100.0),
      color: Colors.red,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Inserted $value',
      code: 'minHeap.insert($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Starting min heap extraction',
      code: 'minHeap.extractMin()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for $value in min heap',
      code: 'minHeap.contains($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing min heap (level-order)',
      code: 'minHeap.levelOrderTraversal()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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

class MaxHeapDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(200.0, 100.0),
      color: Colors.amber,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Inserted $value',
      code: 'maxHeap.insert($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Starting max heap extraction',
      code: 'maxHeap.extractMax()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for $value in max heap',
      code: 'maxHeap.contains($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing max heap (level-order)',
      code: 'maxHeap.levelOrderTraversal()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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

class GraphDataStructure implements DataStructure {
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
    // Add the new node directly to the current nodes
    final newNode = DataStructureNode(
      value: value,
      position: Offset(200.0, 100.0),
      color: Colors.pink,
    );
    
    _nodes.add(newNode);
    
    // Create a single animation step showing the final result
    _animationSteps.clear();
    _animationSteps.add(AnimationStep(
      description: 'Added vertex $value',
      code: 'graph.addVertex($value)',
      nodes: List.from(_nodes),
      highlightedLine: 1,
    ));
    
    _currentStep = 0;
    _updateNodes();
  }

  @override
  void delete(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Starting graph vertex removal',
      code: 'graph.removeVertex($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void search(int value) {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Searching for vertex $value in graph',
      code: 'graph.hasVertex($value)',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
  }

  @override
  void traverse() {
    _animationSteps.clear();
    _currentStep = 0;
    
    final initialNodes = _nodes.map((node) => node.copyWith()).toList();
    _animationSteps.add(AnimationStep(
      description: 'Traversing graph (DFS)',
      code: 'graph.depthFirstSearch()',
      nodes: initialNodes,
      highlightedLine: 1,
    ));

    _updateNodes();
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