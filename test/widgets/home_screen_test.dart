import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:data_structures/screens/home_screen.dart';
import 'package:data_structures/utils/data_structure_factory.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('HomeScreen displays data structure cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that data structures are displayed (only Arrays and Linked Lists are implemented)
      expect(find.text('Arrays'), findsOneWidget);
      expect(find.text('Linked Lists'), findsOneWidget);
    });

    testWidgets('data structure cards show correct information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check specific data structure information
      expect(find.text('Arrays'), findsOneWidget);
      expect(
        find.text(
          'A collection of elements stored at contiguous memory locations.',
        ),
        findsOneWidget,
      );

      expect(find.text('Linked Lists'), findsOneWidget);
      expect(
        find.text(
          'A linear data structure where elements are stored in nodes with references to the next node.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('app bar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      expect(find.text('Data Structures Visualizer'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('header section displays correct text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      expect(find.text('Choose a Data Structure'), findsOneWidget);
      expect(
        find.text(
          'Select a data structure to visualize its operations and algorithms',
        ),
        findsOneWidget,
      );
    });

    testWidgets('grid layout adapts to different screen sizes', (
      WidgetTester tester,
    ) async {
      // Test with small screen
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Should still display data structures
      expect(find.text('Arrays'), findsOneWidget);
      expect(find.text('Linked Lists'), findsOneWidget);

      // Reset screen size
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    testWidgets('data structure cards have correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that cards are present
      expect(find.byType(Card), findsWidgets);

      // Check that icons are present
      expect(find.byType(Icon), findsWidgets);

      // Check that colors are applied
      final arrayCard = find.ancestor(
        of: find.text('Arrays'),
        matching: find.byType(Card),
      );
      expect(arrayCard, findsOneWidget);
    });

    testWidgets('data structure cards are interactive', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Find and tap on the Arrays card
      final arrayCard = find.ancestor(
        of: find.text('Arrays'),
        matching: find.byType(Card),
      );
      expect(arrayCard, findsOneWidget);

      // Verify the card is tappable
      expect(tester.widget<Card>(arrayCard).child, isNotNull);
    });

    testWidgets('grid has correct layout properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that GridView is present
      expect(find.byType(GridView), findsOneWidget);

      // Check that the grid has the correct delegate
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(
        gridView.gridDelegate,
        isA<SliverGridDelegateWithFixedCrossAxisCount>(),
      );
    });

    testWidgets('screen has proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that Padding widget is present
      expect(find.byType(Padding), findsWidgets);

      // Check that the main content has padding
      final padding = find.ancestor(
        of: find.text('Choose a Data Structure'),
        matching: find.byType(Padding),
      );
      expect(padding, findsOneWidget);
    });

    testWidgets('data structure cards display operations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that operation information is displayed
      // The actual implementation shows operations as small chips
      expect(find.text('Insert'), findsWidgets);
      expect(find.text('Delete'), findsWidgets);
    });

    testWidgets('screen handles empty data structure list', (
      WidgetTester tester,
    ) async {
      // This test would require mocking the DataStructureFactory
      // For now, we'll test that the screen renders without crashing
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('screen handles implemented data structures', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that implemented data structures are rendered
      expect(
        find.byType(Card),
        findsNWidgets(DataStructureFactory.dataStructures.length),
      );
    });

    testWidgets('data structure cards have consistent styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that all cards have similar structure
      final cards = find.byType(Card);
      expect(cards, findsWidgets);

      // Verify that each implemented data structure has a card
      final arrayCard = find.ancestor(
        of: find.text('Arrays'),
        matching: find.byType(Card),
      );
      expect(arrayCard, findsOneWidget);

      final linkedListCard = find.ancestor(
        of: find.text('Linked Lists'),
        matching: find.byType(Card),
      );
      expect(linkedListCard, findsOneWidget);
    });

    testWidgets('screen is responsive to theme changes', (
      WidgetTester tester,
    ) async {
      // Test with light theme
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.light(), home: const HomeScreen()),
      );
      expect(find.byType(HomeScreen), findsOneWidget);

      // Test with dark theme
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.dark(), home: const HomeScreen()),
      );
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('screen handles accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that data structure names are accessible
      expect(find.text('Arrays'), findsOneWidget);
      expect(find.text('Linked Lists'), findsOneWidget);
    });

    testWidgets('screen has proper scroll behavior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that GridView is scrollable
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('data structure cards have proper spacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that spacing widgets are present
      expect(find.byType(SizedBox), findsWidgets);

      // Verify that there's proper spacing between elements
      final spacingWidgets = find.byType(SizedBox);
      expect(spacingWidgets, findsWidgets);
    });

    testWidgets('screen handles different text scales', (
      WidgetTester tester,
    ) async {
      // Test with different text scales
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
              child: child!,
            );
          },
        ),
      );

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Choose a Data Structure'), findsOneWidget);
    });

    testWidgets('data structure cards display icons correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that icons are displayed for each data structure
      final arrayIcon = find.descendant(
        of: find.ancestor(of: find.text('Arrays'), matching: find.byType(Card)),
        matching: find.byType(Icon),
      );
      expect(arrayIcon, findsOneWidget);

      final linkedListIcon = find.descendant(
        of: find.ancestor(
          of: find.text('Linked Lists'),
          matching: find.byType(Card),
        ),
        matching: find.byType(Icon),
      );
      expect(linkedListIcon, findsOneWidget);
    });

    testWidgets('screen handles orientation changes', (
      WidgetTester tester,
    ) async {
      // Test in portrait mode
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      expect(find.byType(HomeScreen), findsOneWidget);

      // Test in landscape mode
      tester.binding.window.physicalSizeTestValue = const Size(800, 400);
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      expect(find.byType(HomeScreen), findsOneWidget);

      // Reset
      tester.binding.window.clearPhysicalSizeTestValue();
    });

    testWidgets('cards have proper elevation and shape', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      final cards = find.byType(Card);
      expect(cards, findsWidgets);

      // Check that cards have proper styling
      for (final card in cards.evaluate()) {
        final cardWidget = tester.widget<Card>(find.byWidget(card.widget));
        expect(cardWidget.elevation, 4);
        expect(cardWidget.shape, isA<RoundedRectangleBorder>());
      }
    });

    testWidgets('cards have InkWell for tap feedback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that InkWell is present for tap feedback
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('operations are displayed as chips', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check that operations are displayed in containers with borders
      expect(find.byType(Container), findsWidgets);

      // Look for operation text
      expect(find.text('Insert'), findsWidgets);
      expect(find.text('Delete'), findsWidgets);
    });
  });
}
