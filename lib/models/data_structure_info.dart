import 'package:flutter/material.dart';

enum DataStructureType {
  array,
  linkedList,
  stack,
  queue,
  binaryTree,
  binarySearchTree,
  minHeap,
  maxHeap,
  graph,
}

class DataStructureInfo {
  final DataStructureType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> operations;

  const DataStructureInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.operations,
  });
}
