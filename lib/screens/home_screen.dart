import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/data_structure_info.dart';
import '../utils/data_structure_factory.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Structures Visualizer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Choose a Data Structure',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a data structure to visualize its operations and algorithms',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            // Data structure grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: DataStructureFactory.dataStructures.length,
                itemBuilder: (context, index) {
                  final dataStructure = DataStructureFactory.dataStructures[index];
                  return _buildDataStructureCard(context, dataStructure);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataStructureCard(BuildContext context, DataStructureInfo dataStructure) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          final typeString = DataStructureFactory.getTypeString(dataStructure.type);
          context.go('/data-structure/$typeString');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dataStructure.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    dataStructure.icon,
                    size: 28,
                    color: dataStructure.color,
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  dataStructure.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dataStructure.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  dataStructure.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Operations
                Wrap(
                  spacing: 3,
                  runSpacing: 2,
                  children: dataStructure.operations.take(2).map((operation) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: dataStructure.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: dataStructure.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        operation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: dataStructure.color,
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 