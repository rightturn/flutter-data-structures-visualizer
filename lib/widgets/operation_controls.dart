import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data_structure.dart';

class OperationControls extends StatefulWidget {
  final DataStructure dataStructure;
  final DataStructureInfo dataStructureInfo;
  final VoidCallback onOperationPerformed;
  final Function(int)? onNodeHighlighted;
  final Function(bool)? onAnimationStateChanged;

  const OperationControls({
    super.key,
    required this.dataStructure,
    required this.dataStructureInfo,
    required this.onOperationPerformed,
    this.onNodeHighlighted,
    this.onAnimationStateChanged,
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
    final isArray = widget.dataStructureInfo.type.toString().contains('array');

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Operations',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Only show dropdown for non-array data structures
              if (!isArray)
                DropdownButtonFormField<String>(
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
                      child: Text(operation),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOperation = value;
                    });
                  },
                ),
              if (!isArray) const SizedBox(height: 16),
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
              if (!isArray) const SizedBox(height: 16),
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              if (!isArray) const SizedBox(height: 16),
              // Quick operation buttons (always show for array)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: operations.map((operation) {
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
                            // Generate animation steps
                            widget.dataStructure.traverse();
                            final nodes = widget.dataStructure.nodes;
                            final steps = widget.dataStructure.animationSteps.length;
                            debugPrint('Traverse: nodes=${nodes.map((n) => n.value).toList()}');
                            debugPrint('Traverse: steps=$steps');
                            
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
                            debugPrint('Search operation selected, showing dialog');
                            setState(() {
                              _selectedOperation = operation;
                            });
                            debugPrint('_selectedOperation set to: $_selectedOperation');
                            // Show dialog for search value
                            _showValueDialog(operation);
                          } else if (operation == 'Insert') {
                            debugPrint('Insert operation selected, showing dialog');
                            setState(() {
                              _selectedOperation = operation;
                            });
                            debugPrint('_selectedOperation set to: $_selectedOperation');
                            // Show dialog for insert value
                            _showValueDialog(operation);
                          } else if (operation == 'Delete') {
                            debugPrint('Delete operation selected, showing dialog');
                            setState(() {
                              _selectedOperation = operation;
                            });
                            debugPrint('_selectedOperation set to: $_selectedOperation');
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
                        if (!_needsValue(operation)) {
                          _executeOperation();
                        } else {
                          _showValueDialog(operation);
                        }
                      }
                    },
                    backgroundColor: widget.dataStructureInfo.color.withOpacity(0.1),
                    side: BorderSide(
                      color: widget.dataStructureInfo.color.withOpacity(0.3),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Random data generation
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _generateRandomData,
                      icon: Icon(
                        Icons.shuffle,
                        color: widget.dataStructureInfo.color,
                      ),
                      label: Text(
                        'Generate Random Data',
                        style: TextStyle(
                          color: widget.dataStructureInfo.color,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: widget.dataStructureInfo.color),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _clearData,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showValueDialog(String operation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter value for $operation'),
          content: TextField(
            controller: _valueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Value'),
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
                debugPrint('Dialog OK pressed, selected operation: $_selectedOperation');
                Navigator.of(context).pop();
                _executeOperation();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _needsValue(String operation) {
    return ['Push', 'Enqueue', 'Add Vertex', 'Add Edge'].contains(operation);
  }

  IconData _getOperationIcon(String? operation) {
    switch (operation) {
      case 'Insert':
      case 'Push':
      case 'Enqueue':
      case 'Add Vertex':
      case 'Add Edge':
        return Icons.add;
      case 'Delete':
      case 'Pop':
      case 'Dequeue':
        return Icons.remove;
      case 'Search':
        return Icons.search;
      case 'Traverse':
      case 'DFS':
      case 'BFS':
        return Icons.explore;
      case 'Peek':
      case 'Front':
        return Icons.visibility;
      case 'IsEmpty':
        return Icons.check_circle;
      case 'Extract Min':
      case 'Extract Max':
        return Icons.vertical_align_bottom;
      case 'Heapify':
      case 'Build Heap':
        return Icons.build;
      default:
        return Icons.play_arrow;
    }
  }

  void _executeOperation() async {
    debugPrint('_executeOperation called');
    if (_selectedOperation == null) {
      debugPrint('_selectedOperation is null, returning');
      return;
    }

    debugPrint('Executing operation: $_selectedOperation');
    debugPrint('Value controller text: ${_valueController.text}');

    try {
      switch (_selectedOperation!) {
        case 'Insert':
          final value = int.tryParse(_valueController.text);
          debugPrint('Insert case reached with value: $value');
          if (value != null) {
            debugPrint('Insert: starting insert for value: $value');
            widget.dataStructure.insert(value);
            final nodes = widget.dataStructure.nodes;
            final steps = widget.dataStructure.animationSteps.length;
            debugPrint('Insert: nodes=${nodes.map((n) => n.value).toList()}');
            debugPrint('Insert: steps=$steps');
            
            // Set to step 0 and update UI
            setState(() {
              widget.dataStructure.goToStep(0);
            });
            widget.onOperationPerformed();
            
            // Notify parent to start animation
            if (widget.onAnimationStateChanged != null) {
              widget.onAnimationStateChanged!(true);
            }
            
            _valueController.clear();
          }
          break;
        case 'Push':
        case 'Enqueue':
        case 'Add Vertex':
          final value = int.tryParse(_valueController.text);
          debugPrint('Parsed value: $value');
          if (value != null) {
            debugPrint('Calling insert with value: $value');
            widget.dataStructure.insert(value);
            debugPrint('Insert completed. Nodes count: ${widget.dataStructure.nodes.length}');
            _valueController.clear();
          }
          break;
        case 'Delete':
          final value = int.tryParse(_valueController.text);
          debugPrint('Delete case reached with value: $value');
          if (value != null) {
            debugPrint('Delete: starting delete for value: $value');
            widget.dataStructure.delete(value);
            final nodes = widget.dataStructure.nodes;
            final steps = widget.dataStructure.animationSteps.length;
            debugPrint('Delete: nodes=${nodes.map((n) => n.value).toList()}');
            debugPrint('Delete: steps=$steps');
            
            // Set to step 0 and update UI
            setState(() {
              widget.dataStructure.goToStep(0);
            });
            widget.onOperationPerformed();
            
            // Notify parent to start animation
            if (widget.onAnimationStateChanged != null) {
              widget.onAnimationStateChanged!(true);
            }
            
            _valueController.clear();
          }
          break;
        case 'Pop':
        case 'Dequeue':
          if (_needsValue(_selectedOperation!)) {
            final value = int.tryParse(_valueController.text);
            if (value != null) {
              widget.dataStructure.delete(value);
              _valueController.clear();
            }
          } else {
            widget.dataStructure.delete(0); // For operations that don't need a value
          }
          break;
        case 'Search':
          final value = int.tryParse(_valueController.text);
          debugPrint('Search case reached with value: $value');
          if (value != null) {
            debugPrint('Search: starting search for value: $value');
            widget.dataStructure.search(value);
            final nodes = widget.dataStructure.nodes;
            final steps = widget.dataStructure.animationSteps.length;
            debugPrint('Search: nodes=${nodes.map((n) => n.value).toList()}');
            debugPrint('Search: steps=$steps');
            
            // Set to step 0 and update UI
            setState(() {
              widget.dataStructure.goToStep(0);
            });
            widget.onOperationPerformed();
            
            // Notify parent to start animation
            if (widget.onAnimationStateChanged != null) {
              widget.onAnimationStateChanged!(true);
            }
            
            _valueController.clear();
          }
          break;
        case 'Traverse':
        case 'DFS':
        case 'BFS':
        case 'Peek':
        case 'Front':
        case 'IsEmpty':
        case 'Extract Min':
        case 'Extract Max':
        case 'Heapify':
        case 'Build Heap':
          widget.dataStructure.traverse();
          final steps = widget.dataStructure.animationSteps.length;
          for (int i = 0; i < steps; i++) {
            if (!mounted) return;
            setState(() {
              widget.dataStructure.goToStep(i);
            });
            widget.onOperationPerformed();
            await Future.delayed(const Duration(milliseconds: 500));
          }
          return;
      }
      widget.onOperationPerformed();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedOperation!} operation completed'),
          backgroundColor: widget.dataStructureInfo.color,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _generateRandomData() {
    // Show dialog to ask user how many numbers to generate
    showDialog(
      context: context,
      builder: (context) {
        final countController = TextEditingController(text: '8'); // Default value
        return AlertDialog(
          title: const Text('Generate Random Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How many random numbers do you want to generate?'),
              const SizedBox(height: 16),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Count (1-50)',
                  hintText: 'Enter a number between 1 and 50',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                final count = int.tryParse(countController.text);
                if (count != null && count >= 1 && count <= 50) {
                  Navigator.of(context).pop();
                  _generateRandomNumbers(count);
                } else {
                  // Show error for invalid input
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a number between 1 and 50'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
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

  void _generateRandomNumbers(int count) {
    // Generate random numbers between 1 and 100
    final randomGenerator = Random();
    final random = List.generate(count, (index) {
      return 1 + randomGenerator.nextInt(100); // Random number between 1 and 100
    });
    
    debugPrint('Generated $count random numbers: $random');
    
    // Use the new method to add nodes directly without animation
    if (widget.dataStructure is ArrayDataStructure) {
      (widget.dataStructure as ArrayDataStructure).addNodesDirectly(random);
    } else {
      // Fallback for other data structures
      widget.dataStructure.reset();
      for (final value in random) {
        widget.dataStructure.insert(value);
      }
    }
    
    widget.onOperationPerformed();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generated $count random numbers'),
        backgroundColor: widget.dataStructureInfo.color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearData() {
    widget.dataStructure.reset();
    widget.onOperationPerformed();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data cleared'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }
} 