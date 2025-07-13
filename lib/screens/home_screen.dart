import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/data_structure_factory.dart';
import '../providers/theme_provider.dart';
import '../widgets/data_structure_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Structures Visualizer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: DataStructureFactory.dataStructures.length,
              itemBuilder: (context, index) {
                final dataStructure = DataStructureFactory.dataStructures[index];
                
                return DataStructureCard(
                  dataStructure: dataStructure,
                  onTap: () {
                    context.push('/data-structure/${DataStructureFactory.getTypeString(dataStructure.type)}');
                  },
                );
              },
      ),
    );
  }
} 