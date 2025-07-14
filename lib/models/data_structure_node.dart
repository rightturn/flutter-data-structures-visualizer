import 'package:flutter/material.dart';

class DataStructureNode {
  final int value;
  final String? label;
  final Color? color;
  final Offset position;
  final List<DataStructureNode> children;
  final DataStructureNode? next;
  final DataStructureNode? prev;

  static const _unset = Object();

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
    Object? label = _unset,
    Object? color = _unset,
    Offset? position,
    Object? children = _unset,
    Object? next = _unset,
    Object? prev = _unset,
  }) {
    return DataStructureNode(
      value: value ?? this.value,
      label: label == _unset ? this.label : label as String?,
      color: color == _unset ? this.color : color as Color?,
      position: position ?? this.position,
      children: children == _unset
        ? this.children
        : (children == null ? <DataStructureNode>[] : children as List<DataStructureNode>),
      next: next == _unset ? this.next : next as DataStructureNode?,
      prev: prev == _unset ? this.prev : prev as DataStructureNode?,
    );
  }
} 