import 'package:flutter/material.dart';
import '../models/data_structure.dart';

class DataStructureCard extends StatelessWidget {
  final DataStructureInfo dataStructure;
  final VoidCallback onTap;

  const DataStructureCard({
    super.key,
    required this.dataStructure,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                dataStructure.color.withValues(alpha: 0.1),
                dataStructure.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and name
              Row(
                children: [
                  Icon(
                      dataStructure.icon,
                      color: dataStructure.color,
                      size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dataStructure.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dataStructure.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                dataStructure.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Operations preview
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: dataStructure.operations.take(3).map((operation) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: dataStructure.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      operation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: dataStructure.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 