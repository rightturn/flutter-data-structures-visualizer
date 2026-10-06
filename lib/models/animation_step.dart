import 'data_structure_node.dart';

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
