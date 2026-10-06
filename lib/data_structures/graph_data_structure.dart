import 'dart:collection';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_node.dart';
import '../utils/constants.dart';
import 'visualization_helpers.dart';

class GraphDataStructure extends BaseDataStructure {
  final LinkedHashMap<int, LinkedHashSet<int>> _adjacency = LinkedHashMap();

  @override
  void reset() {
    _adjacency.clear();
    super.reset();
  }

  Map<int, Set<int>> get adjacency => Map<int, Set<int>>.unmodifiable({
    for (final entry in _adjacency.entries)
      entry.key: Set.unmodifiable(entry.value),
  });

  List<(int, int)> get edges {
    final result = <(int, int)>[];
    for (final entry in _adjacency.entries) {
      for (final neighbor in entry.value) {
        if (entry.key <= neighbor) result.add((entry.key, neighbor));
      }
    }
    return result;
  }

  List<DataStructureNode> _graphNodes({int? highlightedValue, Color? color}) {
    final vertices = _adjacency.keys.toList();
    const center = Offset(380, 210);
    const radius = 150.0;
    return List.generate(vertices.length, (index) {
      final angle = vertices.length == 1
          ? 0.0
          : 2 * math.pi * index / vertices.length - math.pi / 2;
      final value = vertices[index];
      return DataStructureNode(
        value: value,
        label: value.toString(),
        position: Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        color: value == highlightedValue
            ? (color ?? AppConstants.currentNodeColor)
            : AppConstants.defaultNodeColor,
      );
    });
  }

  void _syncNodes() => setNodes(_graphNodes());

  @override
  void insert(int value) {
    clearAnimationSteps();
    final added = !_adjacency.containsKey(value);
    _adjacency.putIfAbsent(value, LinkedHashSet.new);
    addAnimationStep(
      visualizationStep(
        description: added
            ? 'Added graph vertex $value.'
            : 'Vertex $value already exists.',
        code: 'graph.addVertex($value);',
        nodes: _graphNodes(
          highlightedValue: value,
          color: added
              ? AppConstants.insertionNodeColor
              : AppConstants.foundNodeColor,
        ),
      ),
    );
    _syncNodes();
    currentStep = 0;
  }

  bool addEdge(int from, int to) {
    clearAnimationSteps();
    if (!_adjacency.containsKey(from) || !_adjacency.containsKey(to)) {
      addAnimationStep(
        visualizationStep(
          description: 'Both vertices must exist before adding an edge.',
          code: 'return false;',
          nodes: _graphNodes(),
        ),
      );
      return false;
    }
    final added = _adjacency[from]!.add(to);
    _adjacency[to]!.add(from);
    addAnimationStep(
      visualizationStep(
        description: added
            ? 'Added undirected edge $from ↔ $to.'
            : 'Edge $from ↔ $to already exists.',
        code: 'graph.addEdge($from, $to);',
        nodes: _graphNodes(
          highlightedValue: from,
          color: AppConstants.insertionNodeColor,
        ),
      ),
    );
    _syncNodes();
    currentStep = 0;
    return added;
  }

  @override
  void delete(int value) {
    clearAnimationSteps();
    if (!_adjacency.containsKey(value)) {
      addAnimationStep(
        visualizationStep(
          description: 'Vertex $value was not found.',
          code: 'return false;',
          nodes: _graphNodes(),
        ),
      );
      return;
    }
    for (final neighbors in _adjacency.values) {
      neighbors.remove(value);
    }
    _adjacency.remove(value);
    addAnimationStep(
      visualizationStep(
        description: 'Removed vertex $value and all incident edges.',
        code: 'graph.removeVertex($value);',
        nodes: _graphNodes(),
      ),
    );
    _syncNodes();
    currentStep = 0;
  }

  @override
  void search(int value) {
    breadthFirstTraversal(target: value);
  }

  @override
  void traverse() {
    breadthFirstTraversal();
  }

  List<int> breadthFirstTraversal({int? start, int? target}) {
    clearAnimationSteps();
    if (_adjacency.isEmpty) return [];
    final first = start != null && _adjacency.containsKey(start)
        ? start
        : _adjacency.keys.first;
    final queue = Queue<int>()..add(first);
    final visited = <int>{first};
    final order = <int>[];
    while (queue.isNotEmpty) {
      final vertex = queue.removeFirst();
      order.add(vertex);
      final found = vertex == target;
      addAnimationStep(
        visualizationStep(
          description: found
              ? 'BFS found vertex $vertex.'
              : 'BFS visited vertex $vertex.',
          code: 'vertex = queue.removeFirst();',
          nodes: _graphNodes(
            highlightedValue: vertex,
            color: found
                ? AppConstants.foundNodeColor
                : AppConstants.currentNodeColor,
          ),
        ),
      );
      if (found) break;
      for (final neighbor in _adjacency[vertex]!) {
        if (visited.add(neighbor)) queue.add(neighbor);
      }
    }
    if (target != null && !order.contains(target)) {
      addAnimationStep(
        visualizationStep(
          description: 'BFS could not reach vertex $target.',
          code: 'return null;',
          nodes: _graphNodes(),
        ),
      );
    }
    currentStep = 0;
    return order;
  }

  List<int> depthFirstTraversal({int? start}) {
    clearAnimationSteps();
    if (_adjacency.isEmpty) return [];
    final first = start != null && _adjacency.containsKey(start)
        ? start
        : _adjacency.keys.first;
    final visited = <int>{};
    final order = <int>[];
    void visit(int vertex) {
      if (!visited.add(vertex)) return;
      order.add(vertex);
      addAnimationStep(
        visualizationStep(
          description: 'DFS visited vertex $vertex.',
          code: 'dfs($vertex);',
          nodes: _graphNodes(highlightedValue: vertex),
        ),
      );
      for (final neighbor in _adjacency[vertex]!) {
        visit(neighbor);
      }
    }

    visit(first);
    currentStep = 0;
    return order;
  }
}
