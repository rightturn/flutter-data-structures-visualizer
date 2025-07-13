import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/data_structure_screen.dart';

void main() {
  runApp(const ProviderScope(child: DataStructuresApp()));
}

class DataStructuresApp extends StatelessWidget {
  const DataStructuresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Data Structures Visualizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/data-structure/:type',
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? 'array';
        return DataStructureScreen(dataStructureType: type);
      },
    ),
  ],
); 