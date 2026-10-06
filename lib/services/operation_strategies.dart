import '../models/base_data_structure.dart';
import '../utils/logger.dart';
import '../data_structures/stack_data_structure.dart';
import '../data_structures/queue_data_structure.dart';
import '../data_structures/heap_data_structure.dart';
import '../data_structures/graph_data_structure.dart';

/// Abstract base class for data structure operation strategies
/// Implements the Strategy pattern to encapsulate different operation algorithms
abstract class OperationStrategy {
  void execute(BaseDataStructure dataStructure, {int? value});
}

/// Strategy for insertion operations
class InsertStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (value == null) {
      AppLogger.dataStructure('InsertStrategy: value is null, cannot insert');
      return;
    }
    if (dataStructure is QueueDataStructure) {
      // For queue, insert is enqueue operation
      dataStructure.enqueue(value);
    } else {
      dataStructure.insert(value);
    }
  }
}

/// Strategy for deletion operations
class DeleteStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is StackDataStructure) {
      // For stack, delete is pop operation (no value needed)
      dataStructure.pop();
    } else if (dataStructure is QueueDataStructure) {
      // For queue, delete is dequeue operation (no value needed)
      dataStructure.dequeue();
    } else {
      if (value == null) {
        AppLogger.dataStructure('DeleteStrategy: value is null, cannot delete');
        return;
      }
      dataStructure.delete(value);
    }
  }
}

/// Strategy for search operations
class SearchStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is StackDataStructure) {
      // For stack, search is peek operation (no value needed)
      dataStructure.peek();
    } else if (dataStructure is QueueDataStructure) {
      // For queue, search is front operation (no value needed)
      dataStructure.front();
    } else {
      if (value == null) {
        AppLogger.dataStructure('SearchStrategy: value is null, cannot search');
        return;
      }
      dataStructure.search(value);
    }
  }
}

/// Strategy for traversal operations
class TraversalStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    dataStructure.traverse();
  }
}

/// Strategy for pop operations (stack specific)
class PopStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is StackDataStructure) {
      dataStructure.pop();
    } else {
      AppLogger.dataStructure(
        'PopStrategy: Pop operation only supported for Stack',
      );
    }
  }
}

/// Strategy for peek operations (stack specific)
class PeekStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is StackDataStructure) {
      dataStructure.peek();
    } else {
      AppLogger.dataStructure(
        'PeekStrategy: Peek operation only supported for Stack',
      );
    }
  }
}

/// Strategy for isEmpty operations (queue specific)
class IsEmptyStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is QueueDataStructure) {
      final isEmpty = dataStructure.isEmpty();
      AppLogger.dataStructure(
        'IsEmptyStrategy: Queue is ${isEmpty ? 'empty' : 'not empty'}',
      );
    } else if (dataStructure is StackDataStructure) {
      final isEmpty = dataStructure.isEmpty();
      AppLogger.dataStructure(
        'IsEmptyStrategy: Stack is ${isEmpty ? 'empty' : 'not empty'}',
      );
    } else {
      AppLogger.dataStructure(
        'IsEmptyStrategy: IsEmpty operation only supported for Stack and Queue',
      );
    }
  }
}

class ExtractHeapStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is HeapDataStructure) dataStructure.extractRoot();
  }
}

class PeekHeapStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is HeapDataStructure) dataStructure.peekRoot();
  }
}

class HeapifyStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is HeapDataStructure) dataStructure.heapify();
  }
}

class BreadthFirstStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is GraphDataStructure)
      dataStructure.breadthFirstTraversal();
  }
}

class DepthFirstStrategy extends OperationStrategy {
  @override
  void execute(BaseDataStructure dataStructure, {int? value}) {
    if (dataStructure is GraphDataStructure)
      dataStructure.depthFirstTraversal();
  }
}

/// Factory for creating operation strategies
class OperationStrategyFactory {
  static OperationStrategy? getStrategy(String operationType) {
    switch (operationType.toLowerCase()) {
      case 'insert':
      case 'add to end':
      case 'push':
      case 'enqueue':
      case 'add vertex':
        return InsertStrategy();
      case 'delete':
      case 'dequeue':
      case 'remove vertex':
        return DeleteStrategy();
      case 'pop':
        return PopStrategy();
      case 'search':
      case 'front':
        return SearchStrategy();
      case 'peek':
        return PeekStrategy();
      case 'traverse':
        return TraversalStrategy();
      case 'isempty':
        return IsEmptyStrategy();
      case 'extract min':
      case 'extract max':
        return ExtractHeapStrategy();
      case 'peek min':
      case 'peek max':
        return PeekHeapStrategy();
      case 'heapify':
      case 'build heap':
        return HeapifyStrategy();
      case 'bfs':
        return BreadthFirstStrategy();
      case 'dfs':
        return DepthFirstStrategy();
      default:
        AppLogger.dataStructure('Unknown operation type: $operationType');
        return null;
    }
  }

  static List<String> getSupportedOperations() {
    return [
      'insert',
      'delete',
      'search',
      'traverse',
      'add to end',
      'push',
      'pop',
      'enqueue',
      'dequeue',
      'peek',
      'front',
      'isempty',
      'add vertex',
      'remove vertex',
      'extract min',
      'extract max',
      'peek min',
      'peek max',
      'heapify',
      'build heap',
      'bfs',
      'dfs',
    ];
  }
}

/// Context class for executing operations using strategies
class OperationContext {
  OperationStrategy? _strategy;

  void setStrategy(OperationStrategy strategy) {
    _strategy = strategy;
  }

  void executeOperation(BaseDataStructure dataStructure, {int? value}) {
    if (_strategy == null) {
      AppLogger.dataStructure('OperationContext: No strategy set');
      return;
    }

    AppLogger.dataStructure(
      'OperationContext: Executing operation with strategy: ${_strategy.runtimeType}',
    );
    _strategy!.execute(dataStructure, value: value);
  }
}

/// Enhanced operation executor that combines strategies with validation
class OperationExecutor {
  final OperationContext _context = OperationContext();

  /// Executes an operation on a data structure with proper validation
  bool executeOperation({
    required String operationType,
    required BaseDataStructure dataStructure,
    int? value,
  }) {
    AppLogger.dataStructure(
      'OperationExecutor: Executing $operationType with value: $value',
    );

    // Validate operation type
    final strategy = OperationStrategyFactory.getStrategy(operationType);
    if (strategy == null) {
      AppLogger.dataStructure(
        'OperationExecutor: Invalid operation type: $operationType',
      );
      return false;
    }

    // Validate value requirements
    if (_requiresValue(operationType) && value == null) {
      AppLogger.dataStructure(
        'OperationExecutor: Operation $operationType requires a value',
      );
      return false;
    }

    // Execute the operation
    try {
      _context.setStrategy(strategy);
      _context.executeOperation(dataStructure, value: value);
      AppLogger.dataStructure(
        'OperationExecutor: Successfully executed $operationType',
      );
      return true;
    } catch (e) {
      AppLogger.dataStructure(
        'OperationExecutor: Error executing $operationType: $e',
      );
      return false;
    }
  }

  /// Checks if an operation requires a value parameter
  bool _requiresValue(String operationType) {
    final valueRequiredOps = [
      'insert',
      'add to end',
      'add to start',
      'delete',
      'search',
      'push',
      'enqueue',
      'add vertex',
      'remove vertex',
    ];
    return valueRequiredOps.contains(operationType.toLowerCase());
  }

  /// Gets list of operations that require values
  List<String> getValueRequiredOperations() {
    return [
      'Insert',
      'Add to End',
      'Add to Start',
      'Delete',
      'Search',
      'Push',
      'Enqueue',
      'Add Vertex',
      'Remove Vertex',
    ];
  }

  /// Gets list of operations that don't require values
  List<String> getValueOptionalOperations() {
    return ['Traverse', 'Pop', 'Dequeue', 'Peek', 'Front', 'IsEmpty'];
  }
}
