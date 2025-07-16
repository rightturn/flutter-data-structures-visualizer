/// Centralized constants for app strings, messages, and descriptions
/// Improves maintainability by keeping all text content in one place
class AppStrings {
  // Error Messages
  static const String emptyInputError = 'Input cannot be empty';
  static const String invalidNumberError = 'Please enter numbers only';
  static const String invalidRangeError = 'Value must be between';
  static const String emptyStructureError = 'Cannot perform operation on empty structure';
  static const String structureFullError = 'Structure is full';
  static const String invalidIndexError = 'Index out of bounds';
  static const String operationFailedError = 'Operation failed';
  static const String unknownOperationError = 'Unknown operation';

  // Success Messages
  static const String operationSuccessful = 'Operation completed successfully';
  static const String insertSuccessful = 'Element inserted successfully';
  static const String deleteSuccessful = 'Element deleted successfully';
  static const String searchSuccessful = 'Element found';
  static const String traversalCompleted = 'Traversal completed';
  static const String randomDataGenerated = 'Random data generated successfully';

  // Operation Names
  static const String insertOperation = 'Insert';
  static const String deleteOperation = 'Delete';
  static const String searchOperation = 'Search';
  static const String traverseOperation = 'Traverse';
  static const String pushOperation = 'Push';
  static const String popOperation = 'Pop';
  static const String peekOperation = 'Peek';
  static const String enqueueOperation = 'Enqueue';
  static const String dequeueOperation = 'Dequeue';
  static const String frontOperation = 'Front';
  static const String addToStartOperation = 'Add to Start';
  static const String addToEndOperation = 'Add to End';
  static const String isEmptyOperation = 'IsEmpty';

  // Data Structure Names
  static const String arrayStructure = 'Array';
  static const String linkedListStructure = 'Linked List';
  static const String stackStructure = 'Stack';
  static const String queueStructure = 'Queue';
  static const String binaryTreeStructure = 'Binary Tree';
  static const String graphStructure = 'Graph';
  static const String heapStructure = 'Heap';

  // Dialog Titles
  static const String insertDialogTitle = 'Insert Value';
  static const String deleteDialogTitle = 'Delete Value';
  static const String searchDialogTitle = 'Search Value';
  static const String randomDataDialogTitle = 'Generate Random Data';
  static const String errorDialogTitle = 'Error';
  static const String confirmDialogTitle = 'Confirm';

  // Dialog Messages
  static const String enterValueMessage = 'Enter a value to';
  static const String randomDataConfirmMessage = 'This will replace the current data with random values.';
  static const String clearDataConfirmMessage = 'This will clear all current data. Are you sure?';

  // Button Labels
  static const String okButton = 'OK';
  static const String cancelButton = 'Cancel';
  static const String confirmButton = 'Confirm';
  static const String generateButton = 'Generate';
  static const String clearButton = 'Clear';
  static const String resetButton = 'Reset';

  // Animation Descriptions
  static const String arrayInsertPrefix = 'Array Insertion';
  static const String arraySearchPrefix = 'Array Search';
  static const String arrayDeletePrefix = 'Array Deletion';
  static const String arrayTraversalPrefix = 'Array Traversal';
  static const String linkedListInsertPrefix = 'Linked List Insertion';
  static const String linkedListSearchPrefix = 'Linked List Search';
  static const String linkedListDeletePrefix = 'Linked List Deletion';
  static const String linkedListTraversalPrefix = 'Linked List Traversal';

  // Common Animation States
  static const String analyzingState = 'Analyzing current state';
  static const String searchingState = 'Searching for element';
  static const String insertingState = 'Inserting element';
  static const String deletingState = 'Deleting element';
  static const String traversingState = 'Traversing structure';
  static const String completedState = 'Operation completed';

  // Color Descriptions
  static const String grayNodeDescription = 'Gray: Unvisited/Default state';
  static const String blueNodeDescription = 'Blue: Currently examining';
  static const String redNodeDescription = 'Red: Checked/No match';
  static const String greenNodeDescription = 'Green: Found/Success';
  static const String orangeNodeDescription = 'Orange: Insertion position';

  // Algorithm Insights
  static const String linearSearchInsight = 'Linear search examines each element sequentially until the target is found. It\'s simple but not the most efficient for large datasets.';
  static const String arrayInsertInsight = 'Inserting at the end of an array is the most efficient insertion operation. It requires no shifting of existing elements and has O(1) time complexity.';
  static const String arrayDeleteInsight = 'Array deletion requires shifting elements to fill the gap, resulting in O(n) time complexity for deletion.';
  static const String linkedListInsight = 'Linked lists provide dynamic memory allocation and efficient insertion/deletion at any position.';
  static const String traversalInsight = 'Sequential traversal visits every element exactly once. This is the most common way to process all elements.';

  // Complexity Notations
  static const String constantTime = 'O(1)';
  static const String linearTime = 'O(n)';
  static const String logarithmicTime = 'O(log n)';
  static const String quadraticTime = 'O(n²)';

  // Validation Messages
  static const String valueRequiredMessage = 'This operation requires a value';
  static const String positiveValueMessage = 'Please enter a positive number';
  static const String validRangeMessage = 'Value must be within valid range';

  // Helper Methods
  static String getStepDescription(String operation, int step, int total) {
    return '$operation: Step $step of $total';
  }

  static String getComplexityDescription(String operation, String complexity) {
    return '$operation - Time Complexity: $complexity';
  }

  static String getRangeErrorMessage(int min, int max) {
    return '$invalidRangeError $min and $max';
  }

  static String getOperationMessage(String operation, String value) {
    return '$operation operation with value: $value';
  }

  static String getStructureStateMessage(String structure, int count) {
    return '$structure contains $count elements';
  }
}