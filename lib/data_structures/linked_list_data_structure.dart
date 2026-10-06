import '../models/base_data_structure.dart';
import '../models/data_structure_node.dart';
import '../models/animation_step.dart';
import '../utils/logger.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';

class LinkedListDataStructure extends BaseDataStructure {
  @override
  void insert(int value) {
    AppLogger.dataStructure(
      'LinkedListDataStructure.insert called with value: $value',
    );
    clearAnimationSteps();
    final nodes = List<DataStructureNode>.from(this.nodes);
    final newNodeIndex = nodes.length;
    // Step 1: All gray
    addAnimationStep(
      AnimationStep(
        description:
            'Insert: Step 1 of ${nodes.length + 2}\nStarting traversal to insert at tail.',
        code: 'current = head;',
        nodes: nodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights:
            'Start at the head node to traverse to the tail for insertion.',
      ),
    );
    // Step 2+: Traverse to tail
    for (int i = 0; i < nodes.length; i++) {
      addAnimationStep(
        AnimationStep(
          description:
              'Insert: Step ${i + 2} of ${nodes.length + 2}\nTraversing node $i (value: ${nodes[i].value}).',
          code: 'current = current.next;',
          nodes: List.generate(
            nodes.length,
            (j) => nodes[j].copyWith(
              color: j == i
                  ? AppConstants.currentNodeColor
                  : AppConstants.defaultNodeColor,
            ),
          ),
          highlightedLine: 1,
          insights: 'Traversing to the tail node.',
        ),
      );
    }
    // Step: Insert new node at tail
    final newNode = DataStructureNode(
      value: value,
      position: Offset(40.0, 60.0 + newNodeIndex * 56.0),
      color: AppConstants.insertionNodeColor,
      next: null,
      prev: null,
    );
    final updatedNodes = List<DataStructureNode>.from(nodes);
    updatedNodes.add(newNode);
    // Update previous tail's next pointer for visualization
    if (updatedNodes.length > 1) {
      updatedNodes[updatedNodes.length - 2] =
          updatedNodes[updatedNodes.length - 2].copyWith(next: newNode);
    }
    addAnimationStep(
      AnimationStep(
        description:
            'Insert: Step ${nodes.length + 2} of ${nodes.length + 2}\nInserted new node at tail (value: $value).',
        code: 'tail.next = newNode;',
        nodes: List.generate(
          updatedNodes.length,
          (j) => updatedNodes[j].copyWith(
            color: j == updatedNodes.length - 1
                ? AppConstants.insertionNodeColor
                : AppConstants.defaultNodeColor,
          ),
        ),
        highlightedLine: 1,
        insights: 'The new node is inserted at the tail of the list.',
      ),
    );
    // Final step: All gray (reset)
    addAnimationStep(
      AnimationStep(
        description: 'Insert Complete. All nodes reset to unvisited (gray).',
        code: 'current = null;',
        nodes: updatedNodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights: 'Insertion is complete. All nodes are reset.',
      ),
    );
    // Actually update the list
    setNodes(updatedNodes);
    currentStep = 0;
  }

  void insertAtHead(int value) {
    AppLogger.dataStructure(
      'LinkedListDataStructure.insertAtHead called with value: $value',
    );
    clearAnimationSteps();
    final nodes = List<DataStructureNode>.from(this.nodes);
    // Step 1: All gray
    addAnimationStep(
      AnimationStep(
        description:
            'Insert at Head: Step 1 of ${nodes.length + 2}\nPreparing to insert at head.',
        code: 'newNode.next = head; head = newNode;',
        nodes: nodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights: 'Prepare to insert the new node at the head of the list.',
      ),
    );
    // Step 2: Show new node as insertion
    final newNode = DataStructureNode(
      value: value,
      position: Offset(40.0, 60.0),
      color: AppConstants.insertionNodeColor,
      next: nodes.isNotEmpty ? nodes[0] : null,
      prev: null,
    );
    final updatedNodes = <DataStructureNode>[newNode];
    for (int i = 0; i < nodes.length; i++) {
      // Shift all existing nodes down
      updatedNodes.add(
        nodes[i].copyWith(
          position: Offset(40.0, 60.0 + (i + 1) * 56.0),
          prev: i == 0 ? newNode : nodes[i - 1],
        ),
      );
    }
    addAnimationStep(
      AnimationStep(
        description:
            'Insert at Head: Step 2 of ${nodes.length + 2}\nInserted new node at head (value: $value).',
        code: 'head = newNode;',
        nodes: List.generate(
          updatedNodes.length,
          (j) => updatedNodes[j].copyWith(
            color: j == 0
                ? AppConstants.insertionNodeColor
                : AppConstants.defaultNodeColor,
          ),
        ),
        highlightedLine: 1,
        insights: 'The new node is now the head of the list.',
      ),
    );
    // Final step: All gray (reset)
    addAnimationStep(
      AnimationStep(
        description:
            'Insert at Head Complete. All nodes reset to unvisited (gray).',
        code: 'current = null;',
        nodes: updatedNodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights: 'Insertion at head is complete. All nodes are reset.',
      ),
    );
    setNodes(updatedNodes);
    currentStep = 0;
  }

  @override
  void delete(int value) {
    AppLogger.dataStructure(
      'LinkedListDataStructure.delete called with value: $value',
    );
    clearAnimationSteps();
    final nodes = List<DataStructureNode>.from(this.nodes);

    if (nodes.isEmpty) {
      AppLogger.dataStructure('No nodes to delete from');
      return;
    }

    // Step 1: All gray - starting deletion
    addAnimationStep(
      AnimationStep(
        description:
            'Linked List Deletion: Step 1 of ${nodes.length + 2}\nStarting deletion of value $value\nTraversing from head to find target node',
        code: 'current = head; target = $value;',
        nodes: nodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights:
            'Deletion in linked lists requires traversing to find the target node first.',
      ),
    );

    bool found = false;
    int foundIndex = -1;

    // Step 2+: Traverse to find the node
    for (int i = 0; i < nodes.length; i++) {
      final isMatch = nodes[i].value == value;

      addAnimationStep(
        AnimationStep(
          description:
              'Linked List Deletion: Step ${i + 2} of ${nodes.length + 2}\n${isMatch ? "Found target node!" : "Checking node"} (value: ${nodes[i].value})\n${isMatch ? "Red highlight: Target found" : "Blue highlight: Current examination"}',
          code: isMatch
              ? 'if (current.value == target) delete(current)'
              : 'current = current.next;',
          nodes: List.generate(
            nodes.length,
            (j) => nodes[j].copyWith(
              color: j == i
                  ? (isMatch
                        ? AppConstants.checkedNodeColor
                        : AppConstants.currentNodeColor)
                  : AppConstants.defaultNodeColor,
            ),
          ),
          highlightedLine: 1,
          insights: isMatch
              ? 'Target node found! Now we need to update pointers to remove it from the list.'
              : 'Continue traversing the linked list to find the target node.',
        ),
      );

      if (isMatch) {
        found = true;
        foundIndex = i;
        break;
      }
    }

    // Final step: Show result
    if (found) {
      final updatedNodes = <DataStructureNode>[];
      for (int i = 0; i < nodes.length; i++) {
        if (i != foundIndex) {
          final newIndex = i > foundIndex ? i - 1 : i;
          updatedNodes.add(
            nodes[i].copyWith(
              position: Offset(40.0, 60.0 + newIndex * 56.0),
              color: AppConstants.defaultNodeColor,
            ),
          );
        }
      }

      addAnimationStep(
        AnimationStep(
          description:
              'Linked List Deletion: Complete\nNode with value $value successfully deleted\nPointers updated, list reorganized\nTime complexity: O(n) for search + O(1) for deletion',
          code: 'delete complete;',
          nodes: updatedNodes,
          highlightedLine: 1,
          insights:
              'Deletion complete! The node has been removed and all pointer connections updated.',
        ),
      );

      setNodes(updatedNodes);
    } else {
      addAnimationStep(
        AnimationStep(
          description:
              'Linked List Deletion: Complete\nValue $value not found in list\nNo changes made to the structure\nTime complexity: O(n) for complete traversal',
          code: 'return null; // not found',
          nodes: nodes
              .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Target value not found. The linked list remains unchanged.',
        ),
      );
    }

    currentStep = 0;
    AppLogger.dataStructure('Delete completed. Found: $found');
  }

  @override
  void search(int value) {
    AppLogger.dataStructure(
      'LinkedListDataStructure.search called with value: $value',
    );
    clearAnimationSteps();
    final nodes = List<DataStructureNode>.from(this.nodes);

    if (nodes.isEmpty) {
      AppLogger.dataStructure('No nodes to search');
      return;
    }

    // Step 1: All gray - starting search
    addAnimationStep(
      AnimationStep(
        description:
            'Linked List Search: Step 1 of ${nodes.length + 1}\nLinear Search Algorithm: Finding element $value\nStarting from head node\nGray nodes: Not yet examined',
        code: 'current = head; target = $value;',
        nodes: nodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights:
            'Linear search in linked lists requires sequential traversal since random access is not possible.',
      ),
    );

    bool found = false;

    // Step 2+: Check each node
    for (int i = 0; i < nodes.length; i++) {
      final isMatch = nodes[i].value == value;

      addAnimationStep(
        AnimationStep(
          description:
              'Linked List Search: Step ${i + 2} of ${nodes.length + 1}\n${isMatch ? "FOUND!" : "Examining"} node at position $i (value: ${nodes[i].value})\n${isMatch ? "Green highlight: Target found!" : "Blue highlight: Current examination"}\n${isMatch ? "Search successful!" : "Continue to next node"}',
          code: isMatch
              ? 'return current; // found!'
              : 'current = current.next;',
          nodes: List.generate(nodes.length, (j) {
            if (j < i) {
              return nodes[j].copyWith(color: AppConstants.checkedNodeColor);
            } else if (j == i) {
              return nodes[j].copyWith(
                color: isMatch
                    ? AppConstants.foundNodeColor
                    : AppConstants.currentNodeColor,
              );
            } else {
              return nodes[j].copyWith(color: AppConstants.defaultNodeColor);
            }
          }),
          highlightedLine: 1,
          insights: isMatch
              ? 'Target found! Linked list search is complete with O(n) time complexity.'
              : 'Node examined. Red nodes show previously checked positions.',
        ),
      );

      if (isMatch) {
        found = true;
        break;
      }
    }

    // Final step if not found
    if (!found) {
      addAnimationStep(
        AnimationStep(
          description:
              'Linked List Search: Step ${nodes.length + 1} of ${nodes.length + 1}\nSearch completed: Value $value not found\nAll nodes examined (red highlights)\nTime complexity: O(n) - complete traversal',
          code: 'return null; // not found',
          nodes: nodes
              .map((n) => n.copyWith(color: AppConstants.checkedNodeColor))
              .toList(),
          highlightedLine: 1,
          insights:
              'Search complete. The target value is not present in the linked list.',
        ),
      );
    }

    currentStep = 0;
    AppLogger.dataStructure('Search completed. Found: $found');
  }

  @override
  void traverse() {
    AppLogger.dataStructure('LinkedListDataStructure.traverse called');
    clearAnimationSteps();
    final nodes = List<DataStructureNode>.from(this.nodes);
    if (nodes.isEmpty) {
      AppLogger.dataStructure('No nodes to traverse');
      return;
    }
    // Step 1: All gray
    addAnimationStep(
      AnimationStep(
        description:
            'Linked List Traversal: Step 1 of ${nodes.length + 1}\nStarting traversal from head node. All nodes are unvisited (gray).',
        code: 'current = head;',
        nodes: nodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights:
            'Traversal starts at the head node. Each node will be visited in order.',
      ),
    );
    // Step 2+: Visit each node
    for (int i = 0; i < nodes.length; i++) {
      addAnimationStep(
        AnimationStep(
          description:
              'Linked List Traversal: Step ${i + 2} of ${nodes.length + 1}\nVisiting node $i (value: ${nodes[i].value}). Blue highlight indicates current node.',
          code: 'current = current.next;',
          nodes: List.generate(
            nodes.length,
            (j) => nodes[j].copyWith(
              color: j == i
                  ? AppConstants.currentNodeColor
                  : AppConstants.defaultNodeColor,
            ),
          ),
          highlightedLine: 1,
          insights:
              'The blue color shows the node currently being visited during traversal.',
        ),
      );
    }
    // Final step: All gray (reset)
    addAnimationStep(
      AnimationStep(
        description:
            'Linked List Traversal Complete. All nodes reset to unvisited (gray).',
        code: 'current = null;',
        nodes: nodes
            .map((n) => n.copyWith(color: AppConstants.defaultNodeColor))
            .toList(),
        highlightedLine: 1,
        insights: 'Traversal is complete. All nodes are reset.',
      ),
    );
    currentStep = 0;
  }

  // Add this method to allow direct population for random data generation
  void addNodesDirectly(List<int> values) {
    // Clear current nodes
    final nodes = <DataStructureNode>[];
    for (int i = 0; i < values.length; i++) {
      final node = DataStructureNode(
        value: values[i],
        position: Offset(40.0 + i * 80.0, 60.0),
        color: null,
        next: null,
        prev: null,
      );
      nodes.add(node);
    }
    // Set next pointers for visualization (not used in logic, just for completeness)
    for (int i = 0; i < nodes.length - 1; i++) {
      nodes[i] = nodes[i].copyWith(next: nodes[i + 1]);
    }
    setNodes(nodes);
    currentStep = 0;
    AppLogger.dataStructure(
      'addNodesDirectly: set ${nodes.length} nodes: ${nodes.map((n) => n.value).toList()}',
    );
  }
}
