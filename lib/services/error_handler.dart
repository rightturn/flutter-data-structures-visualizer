import '../utils/logger.dart';

/// Centralized error handling service for the application
/// Provides consistent error handling and user-friendly error messages
class ErrorHandler {
  /// Handles operation errors and returns user-friendly messages
  static String handleOperationError(String operation, Exception error) {
    AppLogger.dataStructure(
      'ErrorHandler: Handling error for $operation: $error',
    );

    final errorMessage = error.toString();

    // Map common errors to user-friendly messages
    if (errorMessage.contains('RangeError') || errorMessage.contains('index')) {
      return 'Index out of bounds. Please check your input.';
    }

    if (errorMessage.contains('FormatException') ||
        errorMessage.contains('parse')) {
      return 'Invalid number format. Please enter a valid number.';
    }

    if (errorMessage.contains('empty')) {
      return 'Cannot perform $operation on empty data structure.';
    }

    if (errorMessage.contains('null')) {
      return 'Invalid input. Please provide a valid value.';
    }

    if (errorMessage.contains('overflow')) {
      return 'Value too large. Please enter a smaller number.';
    }

    // Generic error message for unknown errors
    return 'Error during $operation: ${_sanitizeErrorMessage(errorMessage)}';
  }

  /// Handles validation errors
  static String handleValidationError(String field, String error) {
    AppLogger.dataStructure(
      'ErrorHandler: Validation error for $field: $error',
    );

    // Map validation errors to user-friendly messages
    switch (error.toLowerCase()) {
      case 'empty':
        return '$field cannot be empty.';
      case 'invalid':
        return '$field is not valid.';
      case 'range':
        return '$field is out of valid range.';
      case 'format':
        return '$field has invalid format.';
      default:
        return '$field error: $error';
    }
  }

  /// Handles data structure specific errors
  static String handleDataStructureError(
    String dataStructureType,
    String operation,
    Exception error,
  ) {
    AppLogger.dataStructure(
      'ErrorHandler: Data structure error for $dataStructureType.$operation: $error',
    );

    final context = '$dataStructureType $operation';

    // Check for specific data structure errors
    if (error.toString().contains('not implemented')) {
      return '$operation is not yet implemented for $dataStructureType.';
    }

    if (error.toString().contains('capacity')) {
      return '$dataStructureType has reached maximum capacity.';
    }

    if (error.toString().contains('underflow')) {
      return 'Cannot remove from empty $dataStructureType.';
    }

    if (error.toString().contains('overflow')) {
      return '$dataStructureType is full. Cannot add more elements.';
    }

    return handleOperationError(context, error);
  }

  /// Handles animation and UI errors
  static String handleUIError(String component, Exception error) {
    AppLogger.ui('ErrorHandler: UI error in $component: $error');

    final errorMessage = error.toString();

    if (errorMessage.contains('render')) {
      return 'Display error occurred. Please try again.';
    }

    if (errorMessage.contains('animation')) {
      return 'Animation error. Resetting visualization.';
    }

    if (errorMessage.contains('build')) {
      return 'Interface error. Please refresh the screen.';
    }

    return 'Interface error in $component. Please try again.';
  }

  /// Handles network and external service errors
  static String handleServiceError(String service, Exception error) {
    AppLogger.dataStructure('ErrorHandler: Service error for $service: $error');

    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('timeout')) {
      return 'Service timeout. Please check your connection.';
    }

    if (errorMessage.contains('network') ||
        errorMessage.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    }

    if (errorMessage.contains('permission')) {
      return 'Permission denied. Please check app permissions.';
    }

    return 'Service error in $service. Please try again later.';
  }

  /// Creates error result objects for consistent error handling
  static ErrorResult createErrorResult(
    String message, {
    String? code,
    dynamic details,
  }) {
    return ErrorResult(
      message: message,
      code: code,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  /// Logs errors with appropriate severity levels
  static void logError(
    String context,
    dynamic error, {
    StackTrace? stackTrace,
  }) {
    if (error is Exception) {
      AppLogger.dataStructure('ERROR in $context: ${error.toString()}');
    } else {
      AppLogger.dataStructure('ERROR in $context: $error');
    }

    if (stackTrace != null) {
      AppLogger.dataStructure('Stack trace: ${stackTrace.toString()}');
    }
  }

  /// Checks if an error is recoverable
  static bool isRecoverableError(Exception error) {
    final errorMessage = error.toString().toLowerCase();

    // Non-recoverable errors
    final nonRecoverableErrors = [
      'out of memory',
      'stack overflow',
      'system error',
      'fatal',
    ];

    for (final nonRecoverable in nonRecoverableErrors) {
      if (errorMessage.contains(nonRecoverable)) {
        return false;
      }
    }

    return true;
  }

  /// Provides recovery suggestions for errors
  static List<String> getRecoverySuggestions(Exception error) {
    final errorMessage = error.toString().toLowerCase();
    final suggestions = <String>[];

    if (errorMessage.contains('empty')) {
      suggestions.add('Add some data to the structure first');
      suggestions.add('Use the "Generate Random Data" option');
    }

    if (errorMessage.contains('full') || errorMessage.contains('capacity')) {
      suggestions.add('Remove some elements first');
      suggestions.add('Clear the data structure and start over');
    }

    if (errorMessage.contains('invalid') || errorMessage.contains('format')) {
      suggestions.add('Check your input format');
      suggestions.add('Enter only positive numbers');
    }

    if (errorMessage.contains('range') || errorMessage.contains('bounds')) {
      suggestions.add('Use values within the valid range');
      suggestions.add('Check the structure size before operations');
    }

    if (suggestions.isEmpty) {
      suggestions.add('Try the operation again');
      suggestions.add('Reset the data structure if issues persist');
    }

    return suggestions;
  }

  /// Sanitizes error messages for display to users
  static String _sanitizeErrorMessage(String message) {
    // Remove technical details that users don't need to see
    final sanitized = message
        .replaceAll(RegExp(r'Exception:\s*'), '')
        .replaceAll(RegExp(r'Error:\s*'), '')
        .replaceAll(RegExp(r'#\d+\s+'), '') // Remove stack trace numbers
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();

    // Limit message length
    if (sanitized.length > 100) {
      return '${sanitized.substring(0, 97)}...';
    }

    return sanitized;
  }
}

/// Result class for error handling operations
class ErrorResult {
  final String message;
  final String? code;
  final dynamic details;
  final DateTime timestamp;

  const ErrorResult({
    required this.message,
    this.code,
    this.details,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ErrorResult(message: $message, code: $code, timestamp: $timestamp)';
  }
}
