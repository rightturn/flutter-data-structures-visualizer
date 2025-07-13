import 'package:flutter/material.dart';
import '../models/data_structure.dart';

class LearningPanel extends StatelessWidget {
  final DataStructure dataStructure;
  final DataStructureInfo dataStructureInfo;

  const LearningPanel({
    super.key,
    required this.dataStructure,
    required this.dataStructureInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStep = dataStructure.currentStep;
    final animationSteps = dataStructure.animationSteps;
    final currentAnimationStep = currentStep < animationSteps.length 
        ? animationSteps[currentStep] 
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: dataStructureInfo.color,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Learning Mode',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              
                const SizedBox(height: 16),
              
                // Current step description
                if (currentAnimationStep != null) ...[
                  // Algorithm type indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: dataStructureInfo.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dataStructureInfo.color.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 14,
                          color: dataStructureInfo.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getAlgorithmType(currentAnimationStep.description),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: dataStructureInfo.color,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Step counter
                  Row(
                    children: [
                      Icon(
                        Icons.timeline,
                        size: 16,
                        color: dataStructureInfo.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Step ${dataStructure.currentStep + 1} of ${animationSteps.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: dataStructureInfo.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Current Step:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: dataStructureInfo.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: dataStructureInfo.color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: dataStructureInfo.color.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      currentAnimationStep.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Color legend
                  _buildColorLegend(theme),
                  
                  const SizedBox(height: 16),
                  
                  // Operation insights
                  _buildOperationInsights(theme, currentAnimationStep!),
                  
                  const SizedBox(height: 16),
                  
                  // Code snippet
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: dataStructureInfo.color.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.code,
                              size: 16,
                              color: dataStructureInfo.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Code',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: dataStructureInfo.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildCodeSnippet(currentAnimationStep.code, currentAnimationStep.highlightedLine),
                      ],
                    ),
                  ),
                ] else ...[
                  // No animation steps available
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Perform an operation to see the animation steps',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Data structure information
                _buildDataStructureInfo(theme),
                
                const SizedBox(height: 16),
                
                // Time complexity information
                _buildComplexityInfo(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeSnippet(String code, int highlightedLine) {
    final lines = code.split('\n');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        final index = entry.key;
        final line = entry.value;
        final isHighlighted = index + 1 == highlightedLine;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: isHighlighted ? BoxDecoration(
            color: dataStructureInfo.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isHighlighted 
                        ? dataStructureInfo.color 
                        : Colors.grey,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  line,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                    color: isHighlighted 
                        ? dataStructureInfo.color 
                        : Colors.black87,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorLegend(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Legend',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            _legendItem(theme, 'Current', Colors.blue),
            _legendItem(theme, 'Found', Colors.green),
            _legendItem(theme, 'Checked', Colors.red),
            _legendItem(theme, 'Unvisited', Colors.grey),
            _legendItem(theme, 'Insertion', Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(ThemeData theme, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildOperationInsights(ThemeData theme, AnimationStep currentAnimationStep) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operation Insights',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentAnimationStep.insights,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDataStructureInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About ${dataStructureInfo.name}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dataStructureInfo.description,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: dataStructureInfo.operations.map((operation) {
            return Chip(
              label: Text(
                operation,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                ),
              ),
              backgroundColor: dataStructureInfo.color.withOpacity(0.1),
              side: BorderSide(
                color: dataStructureInfo.color.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildComplexityInfo(ThemeData theme) {
    final complexityInfo = _getComplexityInfo();
    final operations = complexityInfo.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Complexity',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
          },
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(color: Colors.blue.shade50),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Operation', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Best', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Average', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Worst', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            // Data rows
            ...operations.map((op) {
              final cases = complexityInfo[op] as Map<String, String>;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(op, style: theme.textTheme.bodySmall),
                  ),
                  _pivotCell(cases['Best']!, Colors.green),
                  _pivotCell(cases['Average']!, Colors.orange),
                  _pivotCell(cases['Worst']!, Colors.red),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Widget _pivotCell(String value, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          value,
          style: TextStyle(
            color: color,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getComplexityInfo() {
    switch (dataStructureInfo.type) {
      case DataStructureType.array:
        return {
          'Access':   {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Search':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Insert':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Delete':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
        };
      case DataStructureType.linkedList:
        return {
          'Access':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Search':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Insert':   {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Delete':   {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
        };
      case DataStructureType.stack:
        return {
          'Push':     {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Pop':      {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Peek':     {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
        };
      case DataStructureType.queue:
        return {
          'Enqueue':  {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Dequeue':  {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Front':    {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
        };
      case DataStructureType.binaryTree:
        return {
          'Search':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Insert':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Delete':   {'Best': 'O(1)', 'Average': 'O(n/2)', 'Worst': 'O(n)'},
          'Traverse': {'Best': 'O(n)', 'Average': 'O(n)', 'Worst': 'O(n)'},
        };
      case DataStructureType.binarySearchTree:
        return {
          'Search':   {'Best': 'O(1)', 'Average': 'O(log n)', 'Worst': 'O(n)'},
          'Insert':   {'Best': 'O(1)', 'Average': 'O(log n)', 'Worst': 'O(n)'},
          'Delete':   {'Best': 'O(1)', 'Average': 'O(log n)', 'Worst': 'O(n)'},
          'Traverse': {'Best': 'O(n)', 'Average': 'O(n)', 'Worst': 'O(n)'},
        };
      case DataStructureType.minHeap:
      case DataStructureType.maxHeap:
        return {
          'Insert':   {'Best': 'O(1)', 'Average': 'O(log n)', 'Worst': 'O(log n)'},
          'Extract':  {'Best': 'O(1)', 'Average': 'O(log n)', 'Worst': 'O(log n)'},
          'Peek':     {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Build':    {'Best': 'O(n)', 'Average': 'O(n)', 'Worst': 'O(n)'},
        };
      case DataStructureType.graph:
        return {
          'DFS':      {'Best': 'O(V+E)', 'Average': 'O(V+E)', 'Worst': 'O(V+E)'},
          'BFS':      {'Best': 'O(V+E)', 'Average': 'O(V+E)', 'Worst': 'O(V+E)'},
          'Add Vertex': {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
          'Add Edge':   {'Best': 'O(1)', 'Average': 'O(1)', 'Worst': 'O(1)'},
        };
    }
  }

  String _getAlgorithmType(String description) {
    if (description.contains('Linear Search')) {
      return 'Linear Search';
    } else if (description.contains('Binary Search')) {
      return 'Binary Search';
    } else if (description.contains('Sequential Traversal')) {
      return 'Sequential Traversal';
    } else if (description.contains('Depth-First Search')) {
      return 'Depth-First Search';
    } else if (description.contains('Breadth-First Search')) {
      return 'Breadth-First Search';
    } else if (description.contains('Insertion Sort')) {
      return 'Insertion Sort';
    } else if (description.contains('Bubble Sort')) {
      return 'Bubble Sort';
    } else if (description.contains('Quick Sort')) {
      return 'Quick Sort';
    } else if (description.contains('Merge Sort')) {
      return 'Merge Sort';
    } else if (description.contains('Heap Sort')) {
      return 'Heap Sort';
    } else if (description.contains('Selection Sort')) {
      return 'Selection Sort';
    } else if (description.contains('Insert')) {
      return 'Insert';
    } else if (description.contains('Delete')) {
      return 'Delete';
    } else if (description.contains('Push')) {
      return 'Push';
    } else if (description.contains('Pop')) {
      return 'Pop';
    } else if (description.contains('Enqueue')) {
      return 'Enqueue';
    } else if (description.contains('Dequeue')) {
      return 'Dequeue';
    } else if (description.contains('Build')) {
      return 'Build';
    } else if (description.contains('Extract')) {
      return 'Extract';
    } else {
      return 'Operation';
    }
  }
} 