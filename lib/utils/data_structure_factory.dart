import 'package:flutter/material.dart';
import '../models/data_structure_info.dart';
import '../models/base_data_structure.dart';
import '../data_structures/array_data_structure.dart';
import '../data_structures/linked_list_data_structure.dart';
import '../data_structures/stack_data_structure.dart';
import '../data_structures/queue_data_structure.dart';
import '../data_structures/binary_tree_data_structure.dart';
import '../data_structures/binary_search_tree_data_structure.dart';
import '../data_structures/min_heap_data_structure.dart';
import '../data_structures/max_heap_data_structure.dart';
import '../data_structures/graph_data_structure.dart';

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

  static BaseDataStructure createDataStructure(DataStructureType type) {
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