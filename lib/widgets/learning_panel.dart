import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../utils/constants.dart';

class LearningPanel extends StatelessWidget {
  final BaseDataStructure dataStructure;
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
    final totalSteps = dataStructure.animationSteps.length;
    final hasAnimation = totalSteps > 0;

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
                    Icon(Icons.school, color: dataStructureInfo.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Learning Mode',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Step counter and algorithm info
                if (hasAnimation) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Step ${currentStep + 1} of $totalSteps',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: dataStructureInfo.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: dataStructureInfo.color.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          _getAlgorithmType(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: dataStructureInfo.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Current step description
                if (hasAnimation && currentStep < totalSteps) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Step',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dataStructure.animationSteps[currentStep].description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (dataStructure
                            .animationSteps[currentStep]
                            .insights
                            .isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 16,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    dataStructure
                                        .animationSteps[currentStep]
                                        .insights,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.blue[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Code snippet
                if (hasAnimation && currentStep < totalSteps) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Code',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dataStructure.animationSteps[currentStep].code,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.green[400],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Color legend
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color Legend',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _buildColorLegendItem(
                            'Default/Unvisited',
                            AppConstants.defaultNodeColor,
                            theme,
                          ),
                          _buildColorLegendItem(
                            'Currently Processing',
                            AppConstants.currentNodeColor,
                            theme,
                          ),
                          _buildColorLegendItem(
                            'Found/Target',
                            AppConstants.foundNodeColor,
                            theme,
                          ),
                          _buildColorLegendItem(
                            'Checked/Visited',
                            AppConstants.checkedNodeColor,
                            theme,
                          ),
                          _buildColorLegendItem(
                            'Insertion Position',
                            AppConstants.insertionNodeColor,
                            theme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Data structure info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dataStructureInfo.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: dataStructureInfo.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataStructureInfo.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: dataStructureInfo.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dataStructureInfo.description,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorLegendItem(String label, Color color, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      constraints: const BoxConstraints(maxWidth: 110),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  String _getAlgorithmType() {
    final currentStep = dataStructure.currentStep;
    if (currentStep >= dataStructure.animationSteps.length) return 'Unknown';

    final description = dataStructure.animationSteps[currentStep].description;
    if (description.contains('Linear Search')) return 'Linear Search';
    if (description.contains('Sequential Traversal')) {
      return 'Sequential Traversal';
    }
    if (description.contains('Binary Search')) return 'Binary Search';
    if (description.contains('Depth-First')) return 'DFS';
    if (description.contains('Breadth-First')) return 'BFS';
    if (description.contains('Heapify')) return 'Heapify';
    if (description.contains('Quick Sort')) return 'Quick Sort';
    if (description.contains('Merge Sort')) return 'Merge Sort';
    return 'Algorithm';
  }
}
