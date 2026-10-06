import 'package:flutter/material.dart';
import '../models/animation_step.dart';
import '../models/data_structure_node.dart';
import '../utils/constants.dart';

List<DataStructureNode> buildLinearNodes(
  List<int> values, {
  int? highlightedIndex,
  Color? highlightColor,
}) {
  return List.generate(values.length, (index) {
    return DataStructureNode(
      value: values[index],
      label: index.toString(),
      position: Offset(70 + index * 90, 130),
      color: index == highlightedIndex
          ? (highlightColor ?? AppConstants.currentNodeColor)
          : AppConstants.defaultNodeColor,
    );
  });
}

List<DataStructureNode> buildTreeNodes(
  Map<int, int> indexedValues, {
  int? highlightedIndex,
  Color? highlightColor,
}) {
  if (indexedValues.isEmpty) return [];
  return indexedValues.entries.map((entry) {
      final level = _depthForIndex(entry.key);
      final firstAtLevel = (1 << level) - 1;
      final positionInLevel = entry.key - firstAtLevel;
      final countAtLevel = 1 << level;
      final x = 760.0 * (positionInLevel + 1) / (countAtLevel + 1);
      final y = 70.0 + level * 95.0;
      return DataStructureNode(
        value: entry.value,
        label: entry.key.toString(),
        position: Offset(x, y),
        color: entry.key == highlightedIndex
            ? (highlightColor ?? AppConstants.currentNodeColor)
            : AppConstants.defaultNodeColor,
      );
    }).toList()
    ..sort((a, b) => int.parse(a.label!).compareTo(int.parse(b.label!)));
}

int _depthForIndex(int index) {
  var level = 0;
  var value = index + 1;
  while (value > 1) {
    value >>= 1;
    level++;
  }
  return level;
}

AnimationStep visualizationStep({
  required String description,
  required String code,
  required List<DataStructureNode> nodes,
  String insights = '',
}) {
  return AnimationStep(
    description: description,
    code: code,
    nodes: nodes,
    highlightedLine: 1,
    insights: insights,
  );
}
