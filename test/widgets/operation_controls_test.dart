import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_structures/widgets/operation_controls.dart';
import 'package:data_structures/models/base_data_structure.dart';
import 'package:data_structures/models/data_structure_info.dart';
import 'package:data_structures/models/data_structure_node.dart';
import 'package:data_structures/models/animation_step.dart';
import 'package:data_structures/data_structures/array_data_structure.dart';

class MockDataStructure extends BaseDataStructure {
  final List<DataStructureNode> _nodes;
  int _currentStep = 0;
  final List<AnimationStep> _animationSteps = [];

  MockDataStructure(this._nodes);

  @override
  List<DataStructureNode> get nodes => _nodes;

  @override
  int get currentStep => _currentStep;

  @override
  List<AnimationStep> get animationSteps => _animationSteps;

  @override
  void setCurrentStep(int step) {
    _currentStep = step;
  }

  @override
  void addAnimationStep(AnimationStep step) {
    _animationSteps.add(step);
  }

  @override
  void clearAnimationSteps() {
    _animationSteps.clear();
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

  @override
  void goToStep(int step) {
    _currentStep = step;
  }
}

class MockArrayDataStructure extends ArrayDataStructure {
  final List<DataStructureNode> _nodes;
  int _currentStep = 0;
  final List<AnimationStep> _animationSteps = [];

  MockArrayDataStructure(this._nodes);

  @override
  List<DataStructureNode> get nodes => _nodes;

  @override
  int get currentStep => _currentStep;

  @override
  List<AnimationStep> get animationSteps => _animationSteps;

  @override
  void setCurrentStep(int step) {
    _currentStep = step;
  }

  @override
  void addAnimationStep(AnimationStep step) {
    _animationSteps.add(step);
  }

  @override
  void clearAnimationSteps() {
    _animationSteps.clear();
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

  @override
  void goToStep(int step) {
    _currentStep = step;
  }

  @override
  void addNodesDirectly(List<int> values) {
    // Mock implementation
  }
}

void main() {
  group('OperationControls', () {
    late BaseDataStructure mockDataStructure;
    late ArrayDataStructure mockArrayDataStructure;
    late DataStructureInfo arrayInfo;
    late DataStructureInfo linkedListInfo;
    late List<DataStructureNode> testNodes;

    setUp(() {
      testNodes = [
        DataStructureNode(value: 1, position: const Offset(100, 50)),
        DataStructureNode(value: 2, position: const Offset(100, 100)),
      ];

      mockDataStructure = MockDataStructure(testNodes);
      mockArrayDataStructure = MockArrayDataStructure(testNodes);

      arrayInfo = DataStructureInfo(
        name: 'Array',
        description: 'A test array',
        type: DataStructureType.array,
        color: Colors.blue,
        icon: Icons.list,
        operations: ['Insert', 'Delete', 'Search', 'Traverse'],
      );

      linkedListInfo = DataStructureInfo(
        name: 'Linked List',
        description: 'A test linked list',
        type: DataStructureType.linkedList,
        color: Colors.red,
        icon: Icons.link,
        operations: ['Insert', 'Delete', 'Search', 'Traverse'],
      );
    });

    Widget createTestWidget({
      BaseDataStructure? dataStructure,
      DataStructureInfo? info,
      VoidCallback? onOperationPerformed,
      Function(int)? onNodeHighlighted,
      Function(bool)? onAnimationStateChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: OperationControls(
            dataStructure: dataStructure ?? mockDataStructure,
            dataStructureInfo: info ?? arrayInfo,
            onOperationPerformed: onOperationPerformed ?? () {},
            onNodeHighlighted: onNodeHighlighted,
            onAnimationStateChanged: onAnimationStateChanged,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('renders operation controls for array', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Should show operations title
        expect(find.text('Operations'), findsOneWidget);

        // Should show operation chips
        expect(find.text('Insert'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Traverse'), findsOneWidget);

        // Should show generate random data button for arrays
        expect(find.text('Generate Random Data'), findsOneWidget);
      });

      testWidgets('renders operation controls for linked list', (tester) async {
        await tester.pumpWidget(createTestWidget(info: linkedListInfo));
        await tester.pumpAndSettle();

        // Should show operations title
        expect(find.text('Operations'), findsOneWidget);

        // Should show operation chips
        expect(find.text('Add to Start'), findsOneWidget);
        expect(find.text('Add to End'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Traverse'), findsOneWidget);

        expect(find.text('Generate Random Data'), findsOneWidget);
      });
    });

    group('Array Operations', () {
      testWidgets('shows value dialog for insert operation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap insert operation
        await tester.tap(find.text('Insert'));
        await tester.pumpAndSettle();

        // Should show value dialog
        expect(find.text('Insert Value'), findsOneWidget);
        expect(find.text('Enter a value to Insert:'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('shows value dialog for delete operation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap delete operation
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Should show value dialog
        expect(find.text('Delete Value'), findsOneWidget);
        expect(find.text('Enter a value to Delete:'), findsOneWidget);
      });

      testWidgets('shows value dialog for search operation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap search operation
        await tester.tap(find.text('Search'));
        await tester.pumpAndSettle();

        // Should show value dialog
        expect(find.text('Search Value'), findsOneWidget);
        expect(find.text('Enter a value to Search:'), findsOneWidget);
      });

      testWidgets('executes traverse operation directly', (tester) async {
        bool operationPerformed = false;
        bool animationStarted = false;

        await tester.pumpWidget(
          createTestWidget(
            dataStructure: mockArrayDataStructure,
            onOperationPerformed: () => operationPerformed = true,
            onAnimationStateChanged: (state) => animationStarted = state,
          ),
        );
        await tester.pumpAndSettle();

        // Tap traverse operation
        await tester.tap(find.text('Traverse'));
        await tester.pumpAndSettle();

        // Should call callbacks
        expect(operationPerformed, true);
        expect(animationStarted, true);
      });

      testWidgets('shows generate random data dialog', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap generate random data button
        await tester.tap(find.text('Generate Random Data'));
        await tester.pumpAndSettle();

        // Should show dialog
        expect(
          find.text('Generate Random Data'),
          findsNWidgets(2),
        ); // One in button, one in dialog
        expect(
          find.text('Enter the number of items to generate:'),
          findsOneWidget,
        );
        expect(find.text('Number of items'), findsOneWidget);
      });
    });

    group('Dialog Interactions', () {
      testWidgets('can cancel value dialog', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap insert operation
        await tester.tap(find.text('Insert'));
        await tester.pumpAndSettle();

        // Tap cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Dialog should be dismissed
        expect(find.text('Insert Value'), findsNothing);
      });

      testWidgets('can execute operation from value dialog', (tester) async {
        bool operationPerformed = false;
        bool animationStarted = false;

        await tester.pumpWidget(
          createTestWidget(
            dataStructure: mockArrayDataStructure,
            onOperationPerformed: () => operationPerformed = true,
            onAnimationStateChanged: (state) => animationStarted = state,
          ),
        );
        await tester.pumpAndSettle();

        // Tap insert operation
        await tester.tap(find.text('Insert'));
        await tester.pumpAndSettle();

        // Enter value
        await tester.enterText(find.byType(TextField), '42');
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Should call callbacks
        expect(operationPerformed, true);
        expect(animationStarted, false);
      });

      testWidgets('can cancel generate random data dialog', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap generate random data button
        await tester.tap(find.text('Generate Random Data'));
        await tester.pumpAndSettle();

        // Tap cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Dialog should be dismissed
        expect(
          find.text('Generate Random Data'),
          findsOneWidget,
        ); // Only the button
      });

      testWidgets('can generate random data', (tester) async {
        bool operationPerformed = false;

        await tester.pumpWidget(
          createTestWidget(
            dataStructure: mockArrayDataStructure,
            onOperationPerformed: () => operationPerformed = true,
          ),
        );
        await tester.pumpAndSettle();

        // Tap generate random data button
        await tester.tap(find.text('Generate Random Data'));
        await tester.pumpAndSettle();

        // Enter count
        await tester.enterText(find.byType(TextField), '5');
        await tester.pumpAndSettle();

        // Tap generate button
        await tester.tap(find.text('Generate'));
        await tester.pumpAndSettle();

        // Should call callback
        expect(operationPerformed, true);
      });
    });

    group('Input Validation', () {
      testWidgets('validates numeric input in dialogs', (tester) async {
        await tester.pumpWidget(
          createTestWidget(dataStructure: mockArrayDataStructure),
        );
        await tester.pumpAndSettle();

        // Tap insert operation
        await tester.tap(find.text('Insert'));
        await tester.pumpAndSettle();

        // Try to enter non-numeric text
        await tester.enterText(find.byType(TextField), 'xyz');
        await tester.pumpAndSettle();

        // Text field should only accept digits
        expect(find.text('xyz'), findsNothing);
      });
    });

    group('Error Handling', () {
      testWidgets('handles null callbacks gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            onOperationPerformed: null,
            onNodeHighlighted: null,
            onAnimationStateChanged: null,
          ),
        );
        await tester.pumpAndSettle();

        // Should render without errors
        expect(find.text('Operations'), findsOneWidget);
      });

      testWidgets('handles empty operations list', (tester) async {
        final emptyInfo = DataStructureInfo(
          name: 'Empty',
          description: 'Empty operations',
          type: DataStructureType.array,
          color: Colors.blue,
          icon: Icons.list,
          operations: [],
        );

        await tester.pumpWidget(createTestWidget(info: emptyInfo));
        await tester.pumpAndSettle();

        // Should render without errors
        expect(find.text('Operations'), findsOneWidget);
      });
    });
  });
}
