import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:data_structures/utils/data_structure_factory.dart';
import 'package:data_structures/models/data_structure_info.dart';
import 'package:data_structures/models/base_data_structure.dart';
import 'package:data_structures/data_structures/array_data_structure.dart';
import 'package:data_structures/data_structures/linked_list_data_structure.dart';
import 'package:data_structures/data_structures/stack_data_structure.dart';
import 'package:data_structures/data_structures/queue_data_structure.dart';
import 'package:data_structures/data_structures/binary_tree_data_structure.dart';
import 'package:data_structures/data_structures/binary_search_tree_data_structure.dart';
import 'package:data_structures/data_structures/min_heap_data_structure.dart';
import 'package:data_structures/data_structures/max_heap_data_structure.dart';
import 'package:data_structures/data_structures/graph_data_structure.dart';

void main() {
  group('DataStructureFactory', () {
    group('getInfo', () {
      test('getInfo returns correct DataStructureInfo for each type', () {
        for (final type in DataStructureType.values) {
          final info = DataStructureFactory.getInfo(type);
          expect(info.type, type);
          expect(info.name, isNotEmpty);
          expect(info.description, isNotEmpty);
          expect(info.operations, isNotEmpty);
        }
      });

      test('getInfo for array type', () {
        final info = DataStructureFactory.getInfo(DataStructureType.array);
        expect(info.type, DataStructureType.array);
        expect(info.name, 'Arrays');
        expect(info.icon, Icons.view_array);
        expect(info.color, Colors.blue);
        expect(info.operations, ['Insert', 'Delete', 'Search', 'Traverse']);
      });

      test('getInfo for linked list type', () {
        final info = DataStructureFactory.getInfo(DataStructureType.linkedList);
        expect(info.type, DataStructureType.linkedList);
        expect(info.name, 'Linked Lists');
        expect(info.icon, Icons.link);
        expect(info.color, Colors.green);
        expect(info.operations, ['Insert', 'Delete', 'Search', 'Traverse']);
      });

      test('getInfo for stack type', () {
        final info = DataStructureFactory.getInfo(DataStructureType.stack);
        expect(info.type, DataStructureType.stack);
        expect(info.name, 'Stacks');
        expect(info.icon, Icons.layers);
        expect(info.color, Colors.orange);
        expect(info.operations, ['Push', 'Pop', 'Peek', 'IsEmpty']);
      });

      test('getInfo for queue type', () {
        final info = DataStructureFactory.getInfo(DataStructureType.queue);
        expect(info.type, DataStructureType.queue);
        expect(info.name, 'Queues');
        expect(info.icon, Icons.queue);
        expect(info.color, Colors.purple);
        expect(info.operations, ['Enqueue', 'Dequeue', 'Front', 'IsEmpty']);
      });
    });

    group('createDataStructure', () {
      test('createDataStructure creates correct instance for each type', () {
        final array = DataStructureFactory.createDataStructure(
          DataStructureType.array,
        );
        final linkedList = DataStructureFactory.createDataStructure(
          DataStructureType.linkedList,
        );
        final stack = DataStructureFactory.createDataStructure(
          DataStructureType.stack,
        );
        final queue = DataStructureFactory.createDataStructure(
          DataStructureType.queue,
        );
        final binaryTree = DataStructureFactory.createDataStructure(
          DataStructureType.binaryTree,
        );
        final binarySearchTree = DataStructureFactory.createDataStructure(
          DataStructureType.binarySearchTree,
        );
        final minHeap = DataStructureFactory.createDataStructure(
          DataStructureType.minHeap,
        );
        final maxHeap = DataStructureFactory.createDataStructure(
          DataStructureType.maxHeap,
        );
        final graph = DataStructureFactory.createDataStructure(
          DataStructureType.graph,
        );

        expect(array, isA<ArrayDataStructure>());
        expect(linkedList, isA<LinkedListDataStructure>());
        expect(stack, isA<StackDataStructure>());
        expect(queue, isA<QueueDataStructure>());
        expect(binaryTree, isA<BinaryTreeDataStructure>());
        expect(binarySearchTree, isA<BinarySearchTreeDataStructure>());
        expect(minHeap, isA<MinHeapDataStructure>());
        expect(maxHeap, isA<MaxHeapDataStructure>());
        expect(graph, isA<GraphDataStructure>());
      });

      test('createDataStructure returns BaseDataStructure instances', () {
        for (final type in DataStructureType.values) {
          final dataStructure = DataStructureFactory.createDataStructure(type);
          expect(dataStructure, isA<BaseDataStructure>());
        }
      });
    });

    group('getTypeString', () {
      test('getTypeString returns correct string for each type', () {
        expect(
          DataStructureFactory.getTypeString(DataStructureType.array),
          'array',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.linkedList),
          'linkedList',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.stack),
          'stack',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.queue),
          'queue',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.binaryTree),
          'binaryTree',
        );
        expect(
          DataStructureFactory.getTypeString(
            DataStructureType.binarySearchTree,
          ),
          'binarySearchTree',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.minHeap),
          'minHeap',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.maxHeap),
          'maxHeap',
        );
        expect(
          DataStructureFactory.getTypeString(DataStructureType.graph),
          'graph',
        );
      });
    });

    group('getTypeFromString', () {
      test('getTypeFromString returns correct type for each string', () {
        expect(
          DataStructureFactory.getTypeFromString('array'),
          DataStructureType.array,
        );
        expect(
          DataStructureFactory.getTypeFromString('linkedList'),
          DataStructureType.linkedList,
        );
        expect(
          DataStructureFactory.getTypeFromString('stack'),
          DataStructureType.stack,
        );
        expect(
          DataStructureFactory.getTypeFromString('queue'),
          DataStructureType.queue,
        );
        expect(
          DataStructureFactory.getTypeFromString('binaryTree'),
          DataStructureType.binaryTree,
        );
        expect(
          DataStructureFactory.getTypeFromString('binarySearchTree'),
          DataStructureType.binarySearchTree,
        );
        expect(
          DataStructureFactory.getTypeFromString('minHeap'),
          DataStructureType.minHeap,
        );
        expect(
          DataStructureFactory.getTypeFromString('maxHeap'),
          DataStructureType.maxHeap,
        );
        expect(
          DataStructureFactory.getTypeFromString('graph'),
          DataStructureType.graph,
        );
      });

      test('getTypeFromString returns array for invalid string', () {
        expect(
          DataStructureFactory.getTypeFromString('invalid'),
          DataStructureType.array,
        );
        expect(
          DataStructureFactory.getTypeFromString(''),
          DataStructureType.array,
        );
        expect(
          DataStructureFactory.getTypeFromString('random'),
          DataStructureType.array,
        );
      });

      test('getTypeFromString is case sensitive', () {
        expect(
          DataStructureFactory.getTypeFromString('Array'),
          DataStructureType.array,
        );
        expect(
          DataStructureFactory.getTypeFromString('ARRAY'),
          DataStructureType.array,
        );
        expect(
          DataStructureFactory.getTypeFromString('array'),
          DataStructureType.array,
        );
      });
    });

    group('dataStructures list', () {
      test('dataStructures list contains all types', () {
        final types = DataStructureFactory.dataStructures
            .map((ds) => ds.type)
            .toSet();
        expect(types.length, DataStructureType.values.length);

        for (final type in DataStructureType.values) {
          expect(types.contains(type), true);
        }
      });

      test('dataStructures list has valid info for each entry', () {
        for (final dataStructure in DataStructureFactory.dataStructures) {
          expect(dataStructure.name, isNotEmpty);
          expect(dataStructure.description, isNotEmpty);
          expect(dataStructure.operations, isNotEmpty);
          expect(dataStructure.icon, isNotNull);
          expect(dataStructure.color, isNotNull);
        }
      });

      test('dataStructures list has unique types', () {
        final types = DataStructureFactory.dataStructures
            .map((ds) => ds.type)
            .toList();
        final uniqueTypes = types.toSet();
        expect(types.length, uniqueTypes.length);
      });
    });

    group('Integration tests', () {
      test('getInfo and createDataStructure work together', () {
        for (final type in DataStructureType.values) {
          final info = DataStructureFactory.getInfo(type);
          final dataStructure = DataStructureFactory.createDataStructure(type);

          expect(info.type, type);
          expect(dataStructure, isA<BaseDataStructure>());
        }
      });

      test('getTypeString and getTypeFromString are inverse operations', () {
        for (final type in DataStructureType.values) {
          final typeString = DataStructureFactory.getTypeString(type);
          final convertedType = DataStructureFactory.getTypeFromString(
            typeString,
          );
          expect(convertedType, type);
        }
      });

      test('createDataStructure and getInfo produce consistent results', () {
        for (final type in DataStructureType.values) {
          final info = DataStructureFactory.getInfo(type);
          final dataStructure = DataStructureFactory.createDataStructure(type);

          // Both should be valid and not null
          expect(info, isNotNull);
          expect(dataStructure, isNotNull);
        }
      });
    });
  });
}
