import '../utils/logger.dart';

/// Result class for validation operations
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int? parsedValue;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.parsedValue,
  });

  ValidationResult.success(int value)
      : isValid = true,
        errorMessage = null,
        parsedValue = value;

  ValidationResult.error(String message)
      : isValid = false,
        errorMessage = message,
        parsedValue = null;
}

/// Service for validating user inputs and operation parameters
class ValidationService {
  static const int minValue = 1;
  static const int maxValue = 999;
  static const int maxLength = 50;

  /// Validates numeric input for data structure operations
  static ValidationResult validateNumericInput(String input) {
    AppLogger.dataStructure('ValidationService: Validating numeric input: "$input"');

    if (input.trim().isEmpty) {
      return ValidationResult.error('Input cannot be empty');
    }

    // Check for non-numeric characters
    if (!RegExp(r'^\d+$').hasMatch(input.trim())) {
      return ValidationResult.error('Please enter numbers only');
    }

    // Parse the value
    final parsedValue = int.tryParse(input.trim());
    if (parsedValue == null) {
      return ValidationResult.error('Invalid number format');
    }

    // Check range
    if (parsedValue < minValue || parsedValue > maxValue) {
      return ValidationResult.error('Value must be between $minValue and $maxValue');
    }

    AppLogger.dataStructure('ValidationService: Valid input: $parsedValue');
    return ValidationResult.success(parsedValue);
  }

  /// Validates operation type for data structures
  static bool validateOperationType(String operationType, List<String> supportedOperations) {
    AppLogger.dataStructure('ValidationService: Validating operation: $operationType');
    
    final isValid = supportedOperations.contains(operationType);
    if (!isValid) {
      AppLogger.dataStructure('ValidationService: Invalid operation: $operationType');
      AppLogger.dataStructure('ValidationService: Supported operations: $supportedOperations');
    }
    
    return isValid;
  }

  /// Validates data structure state before operations
  static ValidationResult validateDataStructureState({
    required List<dynamic> nodes,
    required String operationType,
  }) {
    AppLogger.dataStructure('ValidationService: Validating data structure state for $operationType');

    switch (operationType.toLowerCase()) {
      case 'delete':
      case 'search':
      case 'traverse':
      case 'pop':
      case 'dequeue':
      case 'peek':
      case 'front':
        if (nodes.isEmpty) {
          return ValidationResult.error('Cannot perform $operationType on empty structure');
        }
        break;
      
      case 'insert':
      case 'push':
      case 'enqueue':
        if (nodes.length >= maxLength) {
          return ValidationResult.error('Structure is full (max $maxLength elements)');
        }
        break;
    }

    return ValidationResult.success(0);
  }

  /// Validates array index for operations
  static ValidationResult validateArrayIndex(int index, int arrayLength) {
    AppLogger.dataStructure('ValidationService: Validating array index: $index (length: $arrayLength)');

    if (arrayLength == 0) {
      return ValidationResult.error('Array is empty');
    }

    if (index < 0 || index >= arrayLength) {
      return ValidationResult.error('Index must be between 0 and ${arrayLength - 1}');
    }

    return ValidationResult.success(index);
  }

  /// Validates random data generation parameters
  static ValidationResult validateRandomDataParams({
    required int count,
    required int minValue,
    required int maxValue,
  }) {
    AppLogger.dataStructure('ValidationService: Validating random data params: count=$count, min=$minValue, max=$maxValue');

    if (count <= 0) {
      return ValidationResult.error('Count must be greater than 0');
    }

    if (count > maxLength) {
      return ValidationResult.error('Count cannot exceed $maxLength');
    }

    if (minValue >= maxValue) {
      return ValidationResult.error('Minimum value must be less than maximum value');
    }

    if (minValue < ValidationService.minValue || maxValue > ValidationService.maxValue) {
      return ValidationResult.error('Values must be between ${ValidationService.minValue} and ${ValidationService.maxValue}');
    }

    return ValidationResult.success(count);
  }

  /// Validates search value exists in data structure
  static ValidationResult validateSearchValue(int searchValue, List<int> data) {
    AppLogger.dataStructure('ValidationService: Validating search value: $searchValue in data: $data');

    if (data.isEmpty) {
      return ValidationResult.error('Cannot search in empty structure');
    }

    // Note: We don't validate if the value exists, as that's part of the search algorithm
    // Just validate the search value is in acceptable range
    if (searchValue < minValue || searchValue > maxValue) {
      return ValidationResult.error('Search value must be between $minValue and $maxValue');
    }

    return ValidationResult.success(searchValue);
  }

  /// Formats validation error messages for user display
  static String formatErrorMessage(String operation, String error) {
    return '$operation Error: $error';
  }

  /// Gets user-friendly operation name
  static String getOperationDisplayName(String operationType) {
    switch (operationType.toLowerCase()) {
      case 'insert':
        return 'Insert';
      case 'delete':
        return 'Delete';
      case 'search':
        return 'Search';
      case 'traverse':
        return 'Traverse';
      case 'add to end':
        return 'Add to End';
      case 'add to start':
        return 'Add to Start';
      case 'push':
        return 'Push';
      case 'pop':
        return 'Pop';
      case 'peek':
        return 'Peek';
      case 'enqueue':
        return 'Enqueue';
      case 'dequeue':
        return 'Dequeue';
      case 'front':
        return 'Front';
      default:
        return operationType;
    }
  }
}