import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../data_structures/array_data_structure.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

class OperationControls extends StatefulWidget {
  final BaseDataStructure dataStructure;
  final DataStructureInfo dataStructureInfo;
  final VoidCallback onOperationPerformed;
  final Function(int)? onNodeHighlighted;
  final Function(bool)? onAnimationStateChanged;
  final VoidCallback? onShowProgress; // new callback
  final VoidCallback? onHideProgress; // new callback

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

class _OperationControlsState extends State<OperationControls> {
  final TextEditingController _valueController = TextEditingController();
  String? _selectedOperation;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final operations = widget.dataStructureInfo.operations;
    final isArray = widget.dataStructureInfo.type == DataStructureType.array;

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
                // Only show dropdown for non-array data structures
                if (!isArray)
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
                if (!isArray) const SizedBox(height: 12),
                // Value input (for operations that need a value)
                if (_selectedOperation != null && _needsValue(_selectedOperation!) && !isArray)
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
                if (!isArray) const SizedBox(height: 12),
                // Execute button (for non-array)
                if (_selectedOperation != null && !isArray)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _selectedOperation != null ? _executeOperation : null,
                      icon: Icon(
                        _getOperationIcon(_selectedOperation),
                        color: Colors.white,
                      ),
                      label: Text(
                        _selectedOperation ?? 'Select an operation',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.dataStructureInfo.color,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (!isArray) const SizedBox(height: 12),
                // Quick operation buttons (always show for array)
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
                          if (isArray) {
                            if (!_needsValue(operation)) {
                              if (operation == 'Traverse') {
                                // Show progress indicator
                                if (widget.onShowProgress != null) {
                                  AppLogger.ui('Calling onShowProgress from ActionChip (Traverse)');
                                  widget.onShowProgress!();
                                }
                                // Generate animation steps
                                widget.dataStructure.traverse();
                                final nodes = widget.dataStructure.nodes;
                                final steps = widget.dataStructure.animationSteps.length;
                                AppLogger.operation('Traverse: nodes= nodes.map((n) => n.value).toList()}');
                                AppLogger.operation('Traverse: steps=$steps');
                                
                                // Set to step 0 and update UI
                                setState(() {
                                  widget.dataStructure.goToStep(0);
                                });
                                widget.onOperationPerformed();
                                
                                // Notify parent to start animation
                                if (widget.onAnimationStateChanged != null) {
                                  widget.onAnimationStateChanged!(true);
                                }
                              } else if (operation == 'Search') {
                                AppLogger.operation('Search operation selected, showing dialog');
                                setState(() {
                                  _selectedOperation = operation;
                                });
                                AppLogger.operation('_selectedOperation set to: $_selectedOperation');
                                // Show dialog for search value
                                _showValueDialog(operation);
                              } else if (operation == 'Insert') {
                                AppLogger.operation('Insert operation selected, showing dialog');
                                setState(() {
                                  _selectedOperation = operation;
                                });
                                AppLogger.operation('_selectedOperation set to: $_selectedOperation');
                                // Show dialog for insert value
                                _showValueDialog(operation);
                              } else if (operation == 'Delete') {
                                AppLogger.operation('Delete operation selected, showing dialog');
                                setState(() {
                                  _selectedOperation = operation;
                                });
                                AppLogger.operation('_selectedOperation set to: $_selectedOperation');
                                // Show dialog for delete value
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
                          } else {
                            setState(() {
                              _selectedOperation = operation;
                            });
                            _executeOperation();
                          }
                        },
                      );
                    }).toList(),
                    // Generate Data button (for array) - now part of the Wrap
                    if (isArray)
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

  bool _needsValue(String operation) {
    return ['Insert', 'Delete', 'Search', 'Push', 'Enqueue'].contains(operation);
  }

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

  void _executeOperation() {
    if (_selectedOperation == null) return;

    final value = _needsValue(_selectedOperation!) && _valueController.text.isNotEmpty
        ? int.tryParse(_valueController.text)
        : null;

    if (_needsValue(_selectedOperation!) && value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AppLogger.operation('Executing $_selectedOperation with value: $value');

    // Show progress indicator for operations that require it
    if (['Insert', 'Delete', 'Search', 'Traverse', 'Push', 'Pop', 'Enqueue', 'Dequeue'].contains(_selectedOperation)) {
      AppLogger.ui('Calling onShowProgress from _executeOperation ($_selectedOperation)');
      widget.onShowProgress?.call();
    }

    switch (_selectedOperation) {
      case 'Insert':
      case 'Push':
      case 'Enqueue':
        if (value != null) {
          widget.dataStructure.insert(value);
        }
        break;
      case 'Delete':
      case 'Pop':
      case 'Dequeue':
        if (value != null) {
          widget.dataStructure.delete(value);
        } else {
          widget.dataStructure.delete(0); // For operations that don't need a value
        }
        break;
      case 'Search':
      case 'Peek':
      case 'Front':
        if (value != null) {
          widget.dataStructure.search(value);
        } else {
          widget.dataStructure.search(0); // For operations that don't need a value
        }
        break;
      case 'Traverse':
        widget.dataStructure.traverse();
        break;
      case 'IsEmpty':
        // This would need to be implemented in the data structure
        break;
    }

    // Clear the input
    _valueController.clear();
    _selectedOperation = null;

    // Notify parent
    widget.onOperationPerformed();
  }

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
                  Navigator.of(context).pop();
                  // Show progress indicator before running the operation
                  if (widget.onShowProgress != null) {
                    AppLogger.ui('Calling onShowProgress from dialog Execute ($operation)');
                    widget.onShowProgress!();
                  }
                  // Execute the operation
                  switch (operation) {
                    case 'Insert':
                      widget.dataStructure.insert(value);
                      break;
                    case 'Delete':
                      widget.dataStructure.delete(value);
                      break;
                    case 'Search':
                      widget.dataStructure.search(value);
                      break;
                  }
                  // Set to step 0 and update UI
                  setState(() {
                    widget.dataStructure.goToStep(0);
                  });
                  widget.onOperationPerformed();
                  // Notify parent to start animation
                  if (widget.onAnimationStateChanged != null) {
                    widget.onAnimationStateChanged!(true);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Execute'),
            ),
          ],
        );
      },
    );
  }

  void _showGenerateRandomDialog() {
    final controller = TextEditingController(text: '8');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Generate Random Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the number of items to generate:'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of items',
                  hintText: 'e.g. 8',
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
                final count = int.tryParse(controller.text);
                if (count != null && count > 0) {
                  Navigator.of(context).pop();
                  _generateRandomData(count);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  void _generateRandomData(int count) {
    final random = Random();
    final values = List.generate(count, (_) => random.nextInt(100));
    AppLogger.operation('Generated $count random numbers: $values');
    if (widget.dataStructure is ArrayDataStructure) {
      (widget.dataStructure as ArrayDataStructure).addNodesDirectly(values);
      widget.onOperationPerformed();
      AppLogger.ui('Calling onHideProgress after generating random data');
      widget.onHideProgress?.call(); // hide progress after generating data
    }
  }
} 