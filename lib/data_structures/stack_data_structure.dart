import '../models/base_data_structure.dart';
import '../utils/logger.dart';

class StackDataStructure extends BaseDataStructure {
  @override
  void insert(int value) {
    AppLogger.dataStructure('StackDataStructure.insert called with value: $value');
    // TODO: Implement stack push
    AppLogger.warning('Stack push not yet implemented');
  }

  @override
  void delete(int value) {
    AppLogger.dataStructure('StackDataStructure.delete called with value: $value');
    // TODO: Implement stack pop
    AppLogger.warning('Stack pop not yet implemented');
  }

  @override
  void search(int value) {
    AppLogger.dataStructure('StackDataStructure.search called with value: $value');
    // TODO: Implement stack peek
    AppLogger.warning('Stack peek not yet implemented');
  }

  @override
  void traverse() {
    AppLogger.dataStructure('StackDataStructure.traverse called');
    // TODO: Implement stack traversal
    AppLogger.warning('Stack traversal not yet implemented');
  }
} 