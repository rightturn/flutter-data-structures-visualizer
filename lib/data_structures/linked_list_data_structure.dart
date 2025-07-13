import '../models/base_data_structure.dart';
import '../utils/logger.dart';

class LinkedListDataStructure extends BaseDataStructure {
  @override
  void insert(int value) {
    AppLogger.dataStructure('LinkedListDataStructure.insert called with value: $value');
    // TODO: Implement linked list insertion
    AppLogger.warning('Linked list insertion not yet implemented');
  }

  @override
  void delete(int value) {
    AppLogger.dataStructure('LinkedListDataStructure.delete called with value: $value');
    // TODO: Implement linked list deletion
    AppLogger.warning('Linked list deletion not yet implemented');
  }

  @override
  void search(int value) {
    AppLogger.dataStructure('LinkedListDataStructure.search called with value: $value');
    // TODO: Implement linked list search
    AppLogger.warning('Linked list search not yet implemented');
  }

  @override
  void traverse() {
    AppLogger.dataStructure('LinkedListDataStructure.traverse called');
    // TODO: Implement linked list traversal
    AppLogger.warning('Linked list traversal not yet implemented');
  }
} 