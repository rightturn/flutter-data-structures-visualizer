import 'package:flutter/material.dart';

class DataStructureNode {
  final int value;
  final String? label;
  final Color? color;
  final Offset position;
  final List<DataStructureNode> children;
  final DataStructureNode? next;
  final DataStructureNode? prev;

  DataStructureNode({
    required this.value,
    this.label,
    this.color,
    required this.position,
    this.children = const [],
    this.next,
    this.prev,
  });

  DataStructureNode copyWith({
    int? value,
    String? label,
    Color? color,
    Offset? position,
    List<DataStructureNode>? children,
    DataStructureNode? next,
    DataStructureNode? prev,
  }) {
    return DataStructureNode(
      value: value ?? this.value,
      label: label ?? this.label,
      color: color ?? this.color,
      position: position ?? this.position,
      children: children ?? this.children,
      next: next ?? this.next,
      prev: prev ?? this.prev,
    );
  }
} 