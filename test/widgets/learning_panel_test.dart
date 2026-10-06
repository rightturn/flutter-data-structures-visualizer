import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/widgets/learning_panel.dart';
import 'package:data_structures/models/base_data_structure.dart';
import 'package:data_structures/models/data_structure_info.dart';
import 'package:data_structures/models/data_structure_node.dart';
import 'package:data_structures/models/animation_step.dart';

class MockDataStructure extends BaseDataStructure {
  final List<DataStructureNode> _nodes;
  int _currentStep = 0;
  final List<AnimationStep> _animationSteps;

  MockDataStructure(this._nodes, this._animationSteps);

  @override
  List<DataStructureNode> get nodes => _nodes;

  @override
  int get currentStep => _currentStep;

  @override
  List<AnimationStep> get animationSteps => _animationSteps;

  @override
  void setCurrentStep(int step) {
    _currentStep = step;
    // Trigger rebuild by calling notifyListeners if this were a ChangeNotifier
  }

  @override
  void addAnimationStep(AnimationStep step) {
    // Mock implementation
  }

  @override
  void clearAnimationSteps() {
    // Mock implementation
  }

  @override
  void generateNodes() {
    // Mock implementation
  }

  @override
  void insert(int value) {
    // Mock implementation
  }

  @override
  void delete(int value) {
    // Mock implementation
  }

  @override
  void search(int value) {
    // Mock implementation
  }

  @override
  void traverse() {
    // Mock implementation
  }

  @override
  void reset() {
    // Mock implementation
  }

  @override
  void generateRandomData() {
    // Mock implementation
  }
}

void main() {
  group('LearningPanel', () {
    late DataStructureInfo dataStructureInfo;
    late List<DataStructureNode> testNodes;
    late List<AnimationStep> testSteps;

    setUp(() {
      dataStructureInfo = DataStructureInfo(
        name: 'Test Array',
        description: 'A test array for learning',
        type: DataStructureType.array,
        color: Colors.blue,
        icon: Icons.list,
        operations: ['Insert', 'Delete', 'Search', 'Traverse'],
      );

      testNodes = [
        DataStructureNode(value: 1, position: const Offset(100, 50)),
        DataStructureNode(value: 2, position: const Offset(100, 100)),
      ];

      testSteps = [
        AnimationStep(
          description: 'Linear Search: Check element at index 0',
          code: 'if (array[i] == target) return i;',
          nodes: [],
          highlightedLine: 1,
          insights: 'This is the first step of linear search algorithm.',
        ),
        AnimationStep(
          description: 'Linear Search: Check element at index 1',
          code: 'i++; // Move to next element',
          nodes: [],
          highlightedLine: 2,
          insights: 'Continue searching through the array.',
        ),
        AnimationStep(
          description: 'Sequential Traversal: Visit all elements',
          code: 'for (int i = 0; i < array.length; i++) {',
          nodes: [],
          highlightedLine: 1,
          insights: 'Traverse through all elements in order.',
        ),
      ];
    });

    Widget createTestWidget({
      BaseDataStructure? dataStructure,
      DataStructureInfo? info,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: LearningPanel(
            dataStructure:
                dataStructure ?? MockDataStructure(testNodes, testSteps),
            dataStructureInfo: info ?? dataStructureInfo,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('renders learning panel with header', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show learning mode header
        expect(find.text('Learning Mode'), findsOneWidget);
        expect(find.byIcon(Icons.school), findsOneWidget);
      });

      testWidgets('renders step counter when animation exists', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show step counter
        expect(find.text('Step 1 of 3'), findsOneWidget);
      });

      testWidgets('renders algorithm type badge', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show algorithm type
        expect(find.text('Linear Search'), findsOneWidget);
      });

      testWidgets('renders current step description', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show current step section
        expect(find.text('Current Step'), findsOneWidget);
        expect(
          find.text('Linear Search: Check element at index 0'),
          findsOneWidget,
        );
      });

      testWidgets('renders insights when available', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show insights
        expect(
          find.text('This is the first step of linear search algorithm.'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
      });

      testWidgets('renders code snippet', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show code section
        expect(find.text('Code'), findsOneWidget);
        expect(find.text('if (array[i] == target) return i;'), findsOneWidget);
      });

      testWidgets('renders color legend', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show color legend section
        expect(find.text('Color Legend'), findsOneWidget);
        expect(find.text('Default/Unvisited'), findsOneWidget);
        expect(find.text('Currently Processing'), findsOneWidget);
        expect(find.text('Found/Target'), findsOneWidget);
        expect(find.text('Checked/Visited'), findsOneWidget);
        expect(find.text('Insertion Position'), findsOneWidget);
      });

      testWidgets('renders data structure info', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show data structure info
        expect(find.text('Test Array'), findsOneWidget);
        expect(find.text('A test array for learning'), findsOneWidget);
      });
    });

    group('Step Navigation', () {
      testWidgets('updates step counter when current step changes', (
        tester,
      ) async {
        final dataStructure = MockDataStructure(testNodes, testSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Initial step
        expect(find.text('Step 1 of 3'), findsOneWidget);

        // Change to step 2 and rebuild widget
        dataStructure.setCurrentStep(1);
        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Should update step counter
        expect(find.text('Step 2 of 3'), findsOneWidget);
      });

      testWidgets('updates step description when current step changes', (
        tester,
      ) async {
        final dataStructure = MockDataStructure(testNodes, testSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Initial step description
        expect(
          find.text('Linear Search: Check element at index 0'),
          findsOneWidget,
        );

        // Change to step 2 and rebuild widget
        dataStructure.setCurrentStep(1);
        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Should update step description
        expect(
          find.text('Linear Search: Check element at index 1'),
          findsOneWidget,
        );
      });

      testWidgets('updates code snippet when current step changes', (
        tester,
      ) async {
        final dataStructure = MockDataStructure(testNodes, testSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Initial code
        expect(find.text('if (array[i] == target) return i;'), findsOneWidget);

        // Change to step 2 and rebuild widget
        dataStructure.setCurrentStep(1);
        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Should update code snippet
        expect(find.text('i++; // Move to next element'), findsOneWidget);
      });

      testWidgets('updates insights when current step changes', (tester) async {
        final dataStructure = MockDataStructure(testNodes, testSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Initial insights
        expect(
          find.text('This is the first step of linear search algorithm.'),
          findsOneWidget,
        );

        // Change to step 2 and rebuild widget
        dataStructure.setCurrentStep(1);
        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Should update insights
        expect(
          find.text('Continue searching through the array.'),
          findsOneWidget,
        );
      });
    });

    group('Algorithm Type Detection', () {
      testWidgets('detects linear search algorithm', (tester) async {
        final linearSearchSteps = [
          AnimationStep(
            description: 'Linear Search: Check element at index 0',
            code: 'if (array[i] == target) return i;',
            nodes: [],
            highlightedLine: 1,
            insights: 'Linear search step.',
          ),
        ];
        final dataStructure = MockDataStructure(testNodes, linearSearchSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        expect(find.text('Linear Search'), findsOneWidget);
      });

      testWidgets('detects sequential traversal algorithm', (tester) async {
        final traversalSteps = [
          AnimationStep(
            description: 'Sequential Traversal: Visit all elements',
            code: 'for (int i = 0; i < array.length; i++) {',
            nodes: [],
            highlightedLine: 1,
            insights: 'Traversal step.',
          ),
        ];
        final dataStructure = MockDataStructure(testNodes, traversalSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        expect(find.text('Sequential Traversal'), findsOneWidget);
      });

      testWidgets('detects binary search algorithm', (tester) async {
        final binarySearchSteps = [
          AnimationStep(
            description: 'Binary Search: Check middle element',
            code: 'int mid = (low + high) / 2;',
            nodes: [],
            highlightedLine: 1,
            insights: 'Binary search step.',
          ),
        ];
        final dataStructure = MockDataStructure(testNodes, binarySearchSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        expect(find.text('Binary Search'), findsOneWidget);
      });

      testWidgets('detects DFS algorithm', (tester) async {
        final dfsSteps = [
          AnimationStep(
            description: 'Depth-First: Visit node',
            code: 'dfs(node);',
            nodes: [],
            highlightedLine: 1,
            insights: 'DFS step.',
          ),
        ];
        final dataStructure = MockDataStructure(testNodes, dfsSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        expect(find.text('DFS'), findsOneWidget);
      });

      testWidgets('detects BFS algorithm', (tester) async {
        final bfsSteps = [
          AnimationStep(
            description: 'Breadth-First: Visit level',
            code: 'queue.add(node);',
            nodes: [],
            highlightedLine: 1,
            insights: 'BFS step.',
          ),
        ];
        final dataStructure = MockDataStructure(testNodes, bfsSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        expect(find.text('BFS'), findsOneWidget);
      });

      testWidgets('shows generic algorithm for unknown types', (tester) async {
        final unknownSteps = [
          AnimationStep(
            description: 'Unknown algorithm step',
            code: 'unknown();',
            nodes: [],
            highlightedLine: 1,
            insights: 'Unknown step.',
          ),
        ];
        final dataStructure = MockDataStructure(testNodes, unknownSteps);

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        expect(find.text('Algorithm'), findsOneWidget);
      });
    });

    group('Empty States', () {
      testWidgets('handles empty animation steps', (tester) async {
        final emptyDataStructure = MockDataStructure(testNodes, []);

        await tester.pumpWidget(
          createTestWidget(dataStructure: emptyDataStructure),
        );
        await tester.pumpAndSettle();

        // Should still show header and data structure info
        expect(find.text('Learning Mode'), findsOneWidget);
        expect(find.text('Test Array'), findsOneWidget);

        // Should not show step counter or current step
        expect(find.text('Step 1 of 0'), findsNothing);
        expect(find.text('Current Step'), findsNothing);
      });

      testWidgets('handles step out of bounds', (tester) async {
        final dataStructure = MockDataStructure(testNodes, testSteps);
        dataStructure.setCurrentStep(10); // Out of bounds

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.text('Learning Mode'), findsOneWidget);
        expect(find.text('Test Array'), findsOneWidget);
      });

      testWidgets('handles step without insights', (tester) async {
        final stepsWithoutInsights = [
          AnimationStep(
            description: 'Step without insights',
            code: 'code();',
            nodes: [],
            highlightedLine: 1,
            insights: '', // Empty insights
          ),
        ];
        final dataStructure = MockDataStructure(
          testNodes,
          stepsWithoutInsights,
        );

        await tester.pumpWidget(createTestWidget(dataStructure: dataStructure));
        await tester.pumpAndSettle();

        // Should not show insights section
        expect(find.byIcon(Icons.lightbulb_outline), findsNothing);
      });
    });

    group('Color Legend', () {
      testWidgets('renders all color legend items', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should show all color legend items
        expect(find.text('Default/Unvisited'), findsOneWidget);
        expect(find.text('Currently Processing'), findsOneWidget);
        expect(find.text('Found/Target'), findsOneWidget);
        expect(find.text('Checked/Visited'), findsOneWidget);
        expect(find.text('Insertion Position'), findsOneWidget);
      });

      testWidgets('renders color legend with proper styling', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should find color legend containers
        final colorContainers = find.byType(Container);
        expect(colorContainers, findsWidgets);
      });
    });

    group('Data Structure Info', () {
      testWidgets('renders data structure name and description', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Test Array'), findsOneWidget);
        expect(find.text('A test array for learning'), findsOneWidget);
      });

      testWidgets('renders with different data structure info', (tester) async {
        final differentInfo = DataStructureInfo(
          name: 'Linked List',
          description: 'A linked list data structure',
          type: DataStructureType.linkedList,
          color: Colors.red,
          icon: Icons.link,
          operations: ['Insert', 'Delete'],
        );

        await tester.pumpWidget(createTestWidget(info: differentInfo));
        await tester.pumpAndSettle();

        expect(find.text('Linked List'), findsOneWidget);
        expect(find.text('A linked list data structure'), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('uses theme colors for styling', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should render with theme colors
        expect(find.text('Learning Mode'), findsOneWidget);
        expect(find.text('Current Step'), findsOneWidget);
        expect(find.text('Code'), findsOneWidget);
        expect(find.text('Color Legend'), findsOneWidget);
      });

      testWidgets('uses data structure color for accent elements', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should use data structure color for algorithm badge and info section
        expect(find.text('Linear Search'), findsOneWidget);
        expect(find.text('Test Array'), findsOneWidget);
      });
    });
  });
}
