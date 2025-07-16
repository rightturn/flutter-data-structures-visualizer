import 'dart:math';
import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../data_structures/linked_list_data_structure.dart';
import '../data_structures/array_data_structure.dart';
import '../utils/logger.dart';
import 'operation_strategies.dart';
import 'validation_service.dart';

/// Controller for managing data structure operations
/// Separates business logic from UI components
class OperationController {
  final OperationExecutor _operationExecutor = OperationExecutor();
  
  /// Executes an operation with validation and error handling
  Future<OperationResult> executeOperation({
    required String operationType,
    required BaseDataStructure dataStructure,
    required DataStructureInfo dataStructureInfo,
    int? value,
  }) async {
    AppLogger.dataStructure('OperationController: Executing $operationType');

    try {
      // Validate data structure state
      final stateValidation = ValidationService.validateDataStructureState(
        nodes: dataStructure.nodes,
        operationType: operationType,
      );

      if (!stateValidation.isValid) {
        return OperationResult.error(stateValidation.errorMessage!);
      }

      // Validate value if required
      if (_operationExecutor.getValueRequiredOperations().contains(operationType) && value == null) {
        return OperationResult.error('Operation $operationType requires a value');
      }

      // Execute the operation
      final success = _operationExecutor.executeOperation(
        operationType: operationType,
        dataStructure: dataStructure,
        value: value,
      );

      if (success) {
        return OperationResult.success('$operationType completed successfully');
      } else {
        return OperationResult.error('Failed to execute $operationType');
      }
    } catch (e) {
      AppLogger.dataStructure('OperationController: Error executing $operationType: $e');
      return OperationResult.error('Error: ${e.toString()}');
    }
  }

  /// Executes special linked list operations
  Future<OperationResult> executeLinkedListOperation({
    required String operationType,
    required LinkedListDataStructure linkedList,
    int? value,
  }) async {
    AppLogger.dataStructure('OperationController: Executing linked list $operationType');

    try {
      switch (operationType) {
        case 'Add to Start':
          if (value == null) {
            return OperationResult.error('Add to Start requires a value');
          }
          linkedList.insertAtHead(value);
          return OperationResult.success('Added $value to start of list');

        case 'Add to End':
          if (value == null) {
            return OperationResult.error('Add to End requires a value');
          }
          linkedList.insert(value);
          return OperationResult.success('Added $value to end of list');

        default:
          return executeOperation(
            operationType: operationType,
            dataStructure: linkedList,
            dataStructureInfo: DataStructureInfo(
              type: DataStructureType.linkedList,
              name: 'Linked List',
              description: '',
              icon: Icons.link,
              operations: [],
              color: const Color(0xFF000000),
            ),
            value: value,
          );
      }
    } catch (e) {
      AppLogger.dataStructure('OperationController: Error in linked list operation: $e');
      return OperationResult.error('Error: ${e.toString()}');
    }
  }

  /// Generates random data for data structures
  Future<OperationResult> generateRandomData({
    required BaseDataStructure dataStructure,
    required DataStructureInfo dataStructureInfo,
    int count = 8,
    int minValue = 1,
    int maxValue = 100,
  }) async {
    AppLogger.dataStructure('OperationController: Generating random data');

    try {
      // Validate parameters
      final validation = ValidationService.validateRandomDataParams(
        count: count,
        minValue: minValue,
        maxValue: maxValue,
      );

      if (!validation.isValid) {
        return OperationResult.error(validation.errorMessage!);
      }

      // Generate random values
      final random = Random();
      final values = List.generate(
        count,
        (_) => random.nextInt(maxValue - minValue + 1) + minValue,
      );

      // Apply to data structure based on type
      switch (dataStructureInfo.type) {
        case DataStructureType.array:
          if (dataStructure is ArrayDataStructure) {
            dataStructure.addNodesDirectly(values);
          }
          break;
        
        case DataStructureType.linkedList:
          if (dataStructure is LinkedListDataStructure) {
            dataStructure.addNodesDirectly(values);
          }
          break;
        
        case DataStructureType.stack:
          dataStructure.reset();
          for (final value in values) {
            dataStructure.insert(value);
          }
          dataStructure.clearAnimationSteps();
          break;
        
        case DataStructureType.queue:
          dataStructure.reset();
          for (final value in values) {
            dataStructure.insert(value);
          }
          dataStructure.clearAnimationSteps();
          break;
        
        default:
          return OperationResult.error('Random data generation not supported for this data structure');
      }

      return OperationResult.success('Generated $count random values');
    } catch (e) {
      AppLogger.dataStructure('OperationController: Error generating random data: $e');
      return OperationResult.error('Error generating random data: ${e.toString()}');
    }
  }

  /// Validates input value for operations
  ValidationResult validateInput(String input) {
    return ValidationService.validateNumericInput(input);
  }

  /// Gets operations that require values
  List<String> getValueRequiredOperations() {
    return _operationExecutor.getValueRequiredOperations();
  }

  /// Gets operations that don't require values
  List<String> getValueOptionalOperations() {
    return _operationExecutor.getValueOptionalOperations();
  }

  /// Checks if operation requires a value
  bool operationRequiresValue(String operationType) {
    return getValueRequiredOperations().contains(operationType);
  }
}

/// Result class for operation execution
class OperationResult {
  final bool isSuccess;
  final String message;
  final dynamic data;

  const OperationResult({
    required this.isSuccess,
    required this.message,
    this.data,
  });

  OperationResult.success(String message, {dynamic data})
      : isSuccess = true,
        message = message,
        data = data;

  OperationResult.error(String message)
      : isSuccess = false,
        message = message,
        data = null;
}