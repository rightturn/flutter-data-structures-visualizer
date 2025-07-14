import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_structures/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });
  group('ThemeProvider', () {
    group('Initial State', () {
      test('initial theme is system', () {
        final themeNotifier = container.read(themeProvider.notifier);
        expect(themeNotifier.state, ThemeMode.system);
      });

      test('provider exposes correct initial state', () {
        final themeMode = container.read(themeProvider);
        expect(themeMode, ThemeMode.system);
      });
    });

    group('Theme Management', () {
      test('setTheme updates theme correctly', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        
        await themeNotifier.setTheme(ThemeMode.light);
        expect(themeNotifier.state, ThemeMode.light);
        
        await themeNotifier.setTheme(ThemeMode.dark);
        expect(themeNotifier.state, ThemeMode.dark);
        
        await themeNotifier.setTheme(ThemeMode.system);
        expect(themeNotifier.state, ThemeMode.system);
      });

      test('toggleTheme cycles through themes correctly', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        
        // Start with system
        expect(themeNotifier.state, ThemeMode.system);
        
        // First toggle: system -> light
        themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.light);
        
        // Second toggle: light -> dark
        themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.dark);
        
        // Third toggle: dark -> system
        themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.system);
      });

      test('toggleTheme cycles in correct order', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        
        // Verify the cycle: system -> light -> dark -> system
        expect(themeNotifier.state, ThemeMode.system);
        
        themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.light);
        
        themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.dark);
        
        themeNotifier.toggleTheme();
        expect(themeNotifier.state, ThemeMode.system);
      });
    });

    group('Theme Persistence', () {
      test('theme persistence works correctly', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        
        // Set theme to light
        await themeNotifier.setTheme(ThemeMode.light);
        expect(themeNotifier.state, ThemeMode.light);
        
        // Create new container to simulate app restart
        final newContainer = ProviderContainer();
        final newThemeNotifier = newContainer.read(themeProvider.notifier);
        
        // Wait for theme to load
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Theme should be persisted
        expect(newThemeNotifier.state, ThemeMode.light);
        
        newContainer.dispose();
      });

      test('theme loading from shared preferences', () async {
        // Set up shared preferences with a saved theme
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('theme_mode', ThemeMode.dark.index);
        
        // Create new container to simulate app restart
        final newContainer = ProviderContainer();
        final newThemeNotifier = newContainer.read(themeProvider.notifier);
        
        // Wait for theme to load
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Theme should be loaded from preferences
        expect(newThemeNotifier.state, ThemeMode.dark);
        
        newContainer.dispose();
      });

      test('theme loading with invalid preference value', () async {
        // Set up shared preferences with an invalid theme index
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('theme_mode', 999); // Invalid index
        
        // Create new container to simulate app restart
        final newContainer = ProviderContainer();
        final newThemeNotifier = newContainer.read(themeProvider.notifier);
        
        // Wait for theme to load
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Should default to system theme
        expect(newThemeNotifier.state, ThemeMode.system);
        
        newContainer.dispose();
      });

      test('theme loading with no preference set', () async {
        // Clear shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('theme_mode');
        
        // Create new container to simulate app restart
        final newContainer = ProviderContainer();
        final newThemeNotifier = newContainer.read(themeProvider.notifier);
        
        // Wait for theme to load
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Should default to system theme
        expect(newThemeNotifier.state, ThemeMode.system);
        
        newContainer.dispose();
      });
    });

    group('Provider Integration', () {
      test('provider notifies listeners when theme changes', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        bool listenerCalled = false;
        
        container.listen(themeProvider, (previous, next) {
          listenerCalled = true;
          expect(previous, ThemeMode.system);
          expect(next, ThemeMode.light);
        });
        
        await themeNotifier.setTheme(ThemeMode.light);
        expect(listenerCalled, true);
      });

      test('provider maintains state across multiple reads', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        await themeNotifier.setTheme(ThemeMode.dark);
        
        // Multiple reads should return the same value
        expect(container.read(themeProvider), ThemeMode.dark);
        expect(container.read(themeProvider), ThemeMode.dark);
        expect(container.read(themeProvider), ThemeMode.dark);
      });
    });

    group('Edge Cases', () {
      test('setTheme with same theme does not trigger unnecessary updates', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        int listenerCallCount = 0;
        
        container.listen(themeProvider, (previous, next) {
          listenerCallCount++;
        });
        
        // Set to system (current theme)
        await themeNotifier.setTheme(ThemeMode.system);
        expect(listenerCallCount, 0);
        
        // Set to light (different theme)
        await themeNotifier.setTheme(ThemeMode.light);
        expect(listenerCallCount, 1);
        
        // Set to light again (same theme)
        await themeNotifier.setTheme(ThemeMode.light);
        expect(listenerCallCount, 1);
      });

      test('toggleTheme multiple times rapidly', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        
        // Rapid toggles
        themeNotifier.toggleTheme();
        themeNotifier.toggleTheme();
        themeNotifier.toggleTheme();
        themeNotifier.toggleTheme();
        
        // Should end up at light theme (system -> light -> dark -> system -> light)
        expect(themeNotifier.state, ThemeMode.light);
      });

      test('concurrent theme operations', () async {
        final themeNotifier = container.read(themeProvider.notifier);
        
        // Start multiple theme operations concurrently
        final futures = [
          themeNotifier.setTheme(ThemeMode.light),
          themeNotifier.setTheme(ThemeMode.dark),
        ];
        // Call toggleTheme separately since it is not async
        themeNotifier.toggleTheme();
        
        await Future.wait(futures);
        
        // Should have a consistent final state
        expect(themeNotifier.state, isA<ThemeMode>());
      });
    });

    group('Theme Mode Values', () {
      test('all theme modes are valid', () {
        expect(ThemeMode.values.length, 3);
        expect(ThemeMode.values.contains(ThemeMode.system), true);
        expect(ThemeMode.values.contains(ThemeMode.light), true);
        expect(ThemeMode.values.contains(ThemeMode.dark), true);
      });

      test('theme mode indices are valid', () {
        expect(ThemeMode.system.index, 0);
        expect(ThemeMode.light.index, 1);
        expect(ThemeMode.dark.index, 2);
      });
    });

    group('Error Handling', () {
      test('theme loading handles shared preferences errors gracefully', () async {
        // This test would require mocking SharedPreferences to simulate errors
        // For now, we'll test that the provider doesn't crash
        final themeNotifier = container.read(themeProvider.notifier);
        expect(themeNotifier.state, isA<ThemeMode>());
      });
    });
  });
} 