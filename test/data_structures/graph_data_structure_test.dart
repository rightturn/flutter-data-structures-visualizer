import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/data_structures/graph_data_structure.dart';

void main() {
  test('graph adds vertices and undirected edges', () {
    final graph = GraphDataStructure();
    for (final value in [1, 2, 3]) {
      graph.insert(value);
    }
    expect(graph.addEdge(1, 2), isTrue);
    expect(graph.addEdge(2, 3), isTrue);
    expect(graph.adjacency[1], contains(2));
    expect(graph.adjacency[2], containsAll([1, 3]));
  });

  test('BFS and DFS visit connected vertices', () {
    final graph = GraphDataStructure();
    for (final value in [1, 2, 3, 4]) {
      graph.insert(value);
    }
    graph.addEdge(1, 2);
    graph.addEdge(1, 3);
    graph.addEdge(2, 4);

    expect(graph.breadthFirstTraversal(start: 1), [1, 2, 3, 4]);
    expect(graph.depthFirstTraversal(start: 1), [1, 2, 4, 3]);
  });

  test('removing a vertex also removes incident edges', () {
    final graph = GraphDataStructure();
    graph.insert(1);
    graph.insert(2);
    graph.addEdge(1, 2);
    graph.delete(2);

    expect(graph.adjacency.containsKey(2), isFalse);
    expect(graph.adjacency[1], isEmpty);
  });
}
