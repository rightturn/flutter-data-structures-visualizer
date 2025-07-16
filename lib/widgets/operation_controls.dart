// OperationControls: UI and logic for data structure operations panel
// Shows operation buttons, dialogs, and handles user actions for array, stack, and linked list

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../data_structures/linked_list_data_structure.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import '../services/operation_controller.dart';

/// Widget for displaying and handling operations for a data structure (array, stack, linked list)
/// Shows operation chips, dialogs for value input, and handles random data generation
class OperationControls extends StatefulWidget {
  final BaseDataStructure dataStructure;
  final DataStructureInfo dataStructureInfo;
  final VoidCallback onOperationPerformed;
  final Function(int)? onNodeHighlighted;
  final Function(bool)? onAnimationStateChanged;
  final VoidCallback? onShowProgress; // Callback to show progress bar/hide operations
  final VoidCallback? onHideProgress; // Callback to hide progress bar/show operations

  const OperationControls({
    super.key,
    required this.dataStructure,
    required this.dataStructureInfo,
    required this.onOperationPerformed,
    this.onNodeHighlighted,
    this.onAnimationStateChanged,
    this.onShowProgress,
    this.onHideProgress,
  });

  @override
  State<OperationControls> createState() => _OperationControlsState();
}

// ================== STATE ==================
class _OperationControlsState extends State<OperationControls> {
  final TextEditingController _valueController = TextEditingController(); // For value input dialogs
  String? _selectedOperation; // Currently selected operation (for dialogs)
  final OperationController _operationController = OperationController(); // Business logic controller

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  // ================== UI BUILDERS ==================
  /// Build controls for linked list operations (quick chips, add to start/end, random data)
  Widget _buildLinkedListControls(BuildContext context, ThemeData theme, List<String> operations) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Operations',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // Add to Start button
                    ActionChip(
                      label: const Text('Add to Start'),
                      avatar: Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: widget.dataStructureInfo.color,
                      ),
                      onPressed: () {
                        _showValueDialog('Add to Start');
                      },
                    ),
                    // Add to End button (replaces Insert)
                    ActionChip(
                      label: const Text('Add to End'),
                      avatar: Icon(
                        Icons.arrow_downward,
                        size: 16,
                        color: widget.dataStructureInfo.color,
                      ),
                      onPressed: () {
                        _showValueDialog('Add to End');
                      },
                    ),
                    // Other operations as chips
                    ...operations.where((op) => op != 'Insert').map((operation) {
                      return ActionChip(
                        label: Text(operation),
                        avatar: Icon(
                          _getOperationIcon(operation),
                          size: 16,
                          color: widget.dataStructureInfo.color,
                        ),
                        onPressed: () async {
                          // Handle quick operations and dialogs
                          if (!_needsValue(operation)) {
                            if (operation == 'Traverse') {
                              // Show progress bar, start traverse
                              if (widget.onShowProgress != null) {
                                AppLogger.ui('Calling onShowProgress from ActionChip (Traverse)');
                                widget.onShowProgress!();
                              }
                              widget.dataStructure.traverse();
                              setState(() {
                                widget.dataStructure.goToStep(0);
                              });
                              widget.onOperationPerformed();
                              if (widget.onAnimationStateChanged != null) {
                                widget.onAnimationStateChanged!(true);
                              }
                            } else if (operation == 'Search') {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _showValueDialog(operation);
                            } else if (operation == 'Delete') {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _showValueDialog(operation);
                            } else {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            }
                          } else {
                            setState(() {
                              _selectedOperation = operation;
                            });
                            _showValueDialog(operation);
                          }
                        },
                      );
                    }).toList(),
                    // Generate random data for linked list
                    ActionChip(
                      label: const Text('Generate Random Data'),
                      avatar: Icon(
                        Icons.shuffle,
                        size: 16,
                        color: Colors.white,
                      ),
                      backgroundColor: widget.dataStructureInfo.color,
                      labelStyle: const TextStyle(color: Colors.white),
                      onPressed: _showGenerateRandomDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build controls for queue operations (quick chips, random data)
  Widget _buildQueueControls(BuildContext context, ThemeData theme, List<String> operations) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Operations',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // All queue operations as chips
                    ...operations.map((operation) {
                      return ActionChip(
                        label: Text(operation),
                        avatar: Icon(
                          _getOperationIcon(operation),
                          size: 16,
                          color: widget.dataStructureInfo.color,
                        ),
                        onPressed: () async {
                          // Handle quick operations and dialogs
                          if (!_needsValue(operation)) {
                            if (operation == 'Traverse') {
                              // Show progress bar, start traverse
                              if (widget.onShowProgress != null) {
                                AppLogger.ui('Calling onShowProgress from ActionChip (Traverse)');
                                widget.onShowProgress!();
                              }
                              widget.dataStructure.traverse();
                              setState(() {
                                widget.dataStructure.goToStep(0);
                              });
                              widget.onOperationPerformed();
                              if (widget.onAnimationStateChanged != null) {
                                widget.onAnimationStateChanged!(true);
                              }
                            } else if (operation == 'Front') {
                              // Show progress bar, perform front
                              if (widget.onShowProgress != null) {
                                AppLogger.ui('Calling onShowProgress from ActionChip (Front)');
                                widget.onShowProgress!();
                              }
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            } else if (operation == 'IsEmpty') {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            } else if (operation == 'Dequeue') {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            } else {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            }
                          } else {
                            setState(() {
                              _selectedOperation = operation;
                            });
                            _showValueDialog(operation);
                          }
                        },
                      );
                    }).toList(),
                    // Generate random data for queue
                    ActionChip(
                      label: const Text('Generate Random Data'),
                      avatar: Icon(
                        Icons.shuffle,
                        size: 16,
                        color: Colors.white,
                      ),
                      backgroundColor: widget.dataStructureInfo.color,
                      labelStyle: const TextStyle(color: Colors.white),
                      onPressed: _showGenerateRandomDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build controls for stack operations (quick chips, random data)
  Widget _buildStackControls(BuildContext context, ThemeData theme, List<String> operations) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Operations',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // All stack operations as chips
                    ...operations.map((operation) {
                      return ActionChip(
                        label: Text(operation),
                        avatar: Icon(
                          _getOperationIcon(operation),
                          size: 16,
                          color: widget.dataStructureInfo.color,
                        ),
                        onPressed: () async {
                          // Handle quick operations and dialogs
                          if (!_needsValue(operation)) {
                            if (operation == 'Traverse') {
                              // Show progress bar, start traverse
                              if (widget.onShowProgress != null) {
                                AppLogger.ui('Calling onShowProgress from ActionChip (Traverse)');
                                widget.onShowProgress!();
                              }
                              widget.dataStructure.traverse();
                              setState(() {
                                widget.dataStructure.goToStep(0);
                              });
                              widget.onOperationPerformed();
                              if (widget.onAnimationStateChanged != null) {
                                widget.onAnimationStateChanged!(true);
                              }
                            } else if (operation == 'Peek') {
                              // Show progress bar, perform peek
                              if (widget.onShowProgress != null) {
                                AppLogger.ui('Calling onShowProgress from ActionChip (Peek)');
                                widget.onShowProgress!();
                              }
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            } else if (operation == 'Search') {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _showValueDialog(operation);
                            } else if (operation == 'Delete') {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _showValueDialog(operation);
                            } else {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            }
                          } else {
                            setState(() {
                              _selectedOperation = operation;
                            });
                            _showValueDialog(operation);
                          }
                        },
                      );
                    }).toList(),
                    // Generate random data for stack
                    ActionChip(
                      label: const Text('Generate Random Data'),
                      avatar: Icon(
                        Icons.shuffle,
                        size: 16,
                        color: Colors.white,
                      ),
                      backgroundColor: widget.dataStructureInfo.color,
                      labelStyle: const TextStyle(color: Colors.white),
                      onPressed: _showGenerateRandomDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build controls for array operations (dropdown, value input, quick chips, random data)
  Widget _buildArrayControls(BuildContext context, ThemeData theme, List<String> operations) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Operations',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Dropdown for selecting operation
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    value: _selectedOperation,
                    decoration: InputDecoration(
                      labelText: 'Select Operation',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.settings,
                        color: widget.dataStructureInfo.color,
                      ),
                    ),
                    items: operations.map((operation) {
                      return DropdownMenuItem(
                        value: operation,
                        child: Text(
                          operation,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedOperation = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Value input for operations that require a value
                if (_selectedOperation != null && _needsValue(_selectedOperation!))
                  TextFormField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(
                        Icons.input,
                        color: widget.dataStructureInfo.color,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                const SizedBox(height: 12),
                // Quick operation chips for array
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...operations.map((operation) {
                      return ActionChip(
                        label: Text(operation),
                        avatar: Icon(
                          _getOperationIcon(operation),
                          size: 16,
                          color: widget.dataStructureInfo.color,
                        ),
                        onPressed: () async {
                          // Handle quick operations and dialogs
                          if (!_needsValue(operation)) {
                            if (operation == 'Traverse') {
                              // Show progress bar, start traverse
                              if (widget.onShowProgress != null) {
                                AppLogger.ui('Calling onShowProgress from ActionChip (Traverse)');
                                widget.onShowProgress!();
                              }
                              widget.dataStructure.traverse();
                              final steps = widget.dataStructure.animationSteps.length;
                              AppLogger.operation('Traverse: nodes=${widget.dataStructure.nodes.map((n) => n.value).toList()}');
                              AppLogger.operation('Traverse: steps=$steps');
                              setState(() {
                                widget.dataStructure.goToStep(0);
                              });
                              widget.onOperationPerformed();
                              if (widget.onAnimationStateChanged != null) {
                                widget.onAnimationStateChanged!(true);
                              }
                            } else if (operation == 'Search') {
                              AppLogger.operation('Search operation selected, showing dialog');
                              setState(() {
                                _selectedOperation = operation;
                              });
                              AppLogger.operation('_selectedOperation set to: $_selectedOperation');
                              _showValueDialog(operation);
                            } else if (operation == 'Insert') {
                              AppLogger.operation('Insert operation selected, showing dialog');
                              setState(() {
                                _selectedOperation = operation;
                              });
                              AppLogger.operation('_selectedOperation set to: $_selectedOperation');
                              _showValueDialog(operation);
                            } else if (operation == 'Delete') {
                              AppLogger.operation('Delete operation selected, showing dialog');
                              setState(() {
                                _selectedOperation = operation;
                              });
                              AppLogger.operation('_selectedOperation set to: $_selectedOperation');
                              _showValueDialog(operation);
                            } else {
                              setState(() {
                                _selectedOperation = operation;
                              });
                              _executeOperation();
                            }
                          } else {
                            setState(() {
                              _selectedOperation = operation;
                            });
                            _showValueDialog(operation);
                          }
                        },
                      );
                    }).toList(),
                    // Generate random data for array
                    ActionChip(
                      label: const Text('Generate Random Data'),
                      avatar: Icon(
                        Icons.shuffle,
                        size: 16,
                        color: Colors.white,
                      ),
                      backgroundColor: widget.dataStructureInfo.color,
                      labelStyle: const TextStyle(color: Colors.white),
                      onPressed: _showGenerateRandomDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================== MAIN BUILD ==================
  /// Main build method: chooses which controls to show based on data structure type
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final operations = widget.dataStructureInfo.operations;
    final isArray = widget.dataStructureInfo.type == DataStructureType.array;
    final isLinkedList = widget.dataStructureInfo.type == DataStructureType.linkedList;
    final isStack = widget.dataStructureInfo.type == DataStructureType.stack;
    final isQueue = widget.dataStructureInfo.type == DataStructureType.queue;

    if (isLinkedList) {
      return _buildLinkedListControls(context, theme, operations);
    }
    if (isStack) {
      return _buildStackControls(context, theme, operations);
    }
    if (isQueue) {
      return _buildQueueControls(context, theme, operations);
    }
    if (isArray) {
      return _buildArrayControls(context, theme, operations);
    }
    // Default fallback (should not occur)
    return const SizedBox.shrink();
  }

  // ================== LOGIC HELPERS ==================
  /// Returns true if the operation requires a value input
  bool _needsValue(String operation) {
    return ['Insert', 'Add to Start', 'Add to End', 'Delete', 'Search', 'Push', 'Enqueue'].contains(operation);
  }

  /// Returns the icon for a given operation name
  IconData _getOperationIcon(String? operation) {
    switch (operation) {
      case 'Insert':
      case 'Push':
      case 'Enqueue':
        return Icons.add;
      case 'Delete':
      case 'Pop':
      case 'Dequeue':
        return Icons.remove;
      case 'Search':
      case 'Peek':
      case 'Front':
        return Icons.search;
      case 'Traverse':
        return Icons.list;
      case 'IsEmpty':
        return Icons.check_box_outline_blank;
      default:
        return Icons.settings;
    }
  }

  // ================== OPERATION EXECUTION ==================
  /// Executes the currently selected operation using the operation controller
  void _executeOperation() async {
    if (_selectedOperation == null) return;

    // Validate input if value is required
    int? value;
    if (_operationController.operationRequiresValue(_selectedOperation!)) {
      if (_valueController.text.isEmpty) {
        _showErrorMessage('Please enter a valid number');
        return;
      }
      
      final validation = _operationController.validateInput(_valueController.text);
      if (!validation.isValid) {
        _showErrorMessage(validation.errorMessage!);
        return;
      }
      value = validation.parsedValue;
    }

    AppLogger.operation('Executing $_selectedOperation with value: $value');

    // Show progress bar for operations that need it
    final progressOperations = ['Add to Start', 'Add to End', 'Delete', 'Search', 'Traverse', 'Push', 'Pop', 'Insert', 'Enqueue', 'Dequeue', 'Front'];
    if (progressOperations.contains(_selectedOperation)) {
      AppLogger.ui('Calling onShowProgress from _executeOperation ($_selectedOperation)');
      widget.onShowProgress?.call();
    }

    // Execute operation using controller
    late OperationResult result;
    if (widget.dataStructure is LinkedListDataStructure && 
        (_selectedOperation == 'Add to Start' || _selectedOperation == 'Add to End')) {
      result = await _operationController.executeLinkedListOperation(
        operationType: _selectedOperation!,
        linkedList: widget.dataStructure as LinkedListDataStructure,
        value: value,
      );
    } else {
      result = await _operationController.executeOperation(
        operationType: _selectedOperation!,
        dataStructure: widget.dataStructure,
        dataStructureInfo: widget.dataStructureInfo,
        value: value,
      );
    }

    // Handle result
    if (!result.isSuccess) {
      _showErrorMessage(result.message);
      // Restore operations section when operation fails
      if (widget.onHideProgress != null) {
        AppLogger.ui('Calling onHideProgress due to operation failure');
        widget.onHideProgress!();
      }
      return;
    }

    // Reset state after successful operation
    _valueController.clear();
    final completedOperation = _selectedOperation;
    _selectedOperation = null;
    widget.onOperationPerformed();
    
    // Auto-start animation for operations that have animation steps
    if (completedOperation != null && 
        ['Push', 'Pop', 'Insert', 'Delete', 'Search', 'Add to Start', 'Add to End', 'Enqueue', 'Dequeue', 'Front'].contains(completedOperation)) {
      if (widget.onAnimationStateChanged != null) {
        widget.onAnimationStateChanged!(true);
      }
    }
  }

  // ================== DIALOG HELPERS ==================
  /// Shows a dialog for value input for operations that require a value
  void _showValueDialog(String operation) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$operation Value'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter a value to $operation:'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText: 'Enter a number',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null) {
                  setState(() {
                    _selectedOperation = operation;
                    _valueController.text = value.toString();
                  });
                  Navigator.of(context).pop();
                  _executeOperation();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog to confirm random data generation
  void _showGenerateRandomDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Generate Random Data'),
          content: const Text('This will replace the current data with random values.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _generateRandomData();
                Navigator.of(context).pop();
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  /// Generates random data using the operation controller
  void _generateRandomData() async {
    final result = await _operationController.generateRandomData(
      dataStructure: widget.dataStructure,
      dataStructureInfo: widget.dataStructureInfo,
      count: AppConstants.defaultNodeCount,
      minValue: AppConstants.minNodeValue,
      maxValue: AppConstants.maxNodeValue,
    );

    if (!result.isSuccess) {
      _showErrorMessage(result.message);
      return;
    }

    setState(() {});
    widget.onOperationPerformed();
  }

  /// Shows error message in a snackbar
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 