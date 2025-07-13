import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data_structure.dart';

class DataStructureCanvas extends StatefulWidget {
  final DataStructure dataStructure;
  final AnimationController animationController;
  final DataStructureInfo dataStructureInfo;
  final Function(int)? onNodeHighlighted;
  final VoidCallback? onNodeUpdated;

  const DataStructureCanvas({
    super.key,
    required this.dataStructure,
    required this.animationController,
    required this.dataStructureInfo,
    this.onNodeHighlighted,
    this.onNodeUpdated,
  });

  @override
  State<DataStructureCanvas> createState() => DataStructureCanvasState();
}

class DataStructureCanvasState extends State<DataStructureCanvas> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Method to scroll to a specific node index
  void scrollToNode(int nodeIndex) {
    if (!_scrollController.hasClients) {
      debugPrint('ScrollController has no clients, cannot scroll');
      return;
    }
    
    final boxHeight = 40.0;
    final spacing = 0.0; // No spacing for continuous block
    final nodeY = 40.0 + nodeIndex * (boxHeight + spacing);
    final nodeBottom = nodeY + boxHeight;
    
    // Get the current scroll position and viewport height
    final currentScroll = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    // Calculate the target scroll position to show the node at 25% from bottom
    final targetScroll = nodeBottom - (viewportHeight * 0.75);
    
    // Ensure we don't scroll beyond bounds
    final clampedScroll = targetScroll.clamp(0.0, maxScroll);
    
    debugPrint('Scrolling to node $nodeIndex: current=$currentScroll, target=$clampedScroll, nodeY=$nodeY, viewportHeight=$viewportHeight, maxScroll=$maxScroll');
    
    _scrollController.animateTo(
      clampedScroll,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate required height for array
    final isArray = widget.dataStructureInfo.type == DataStructureType.array;
    final itemCount = widget.dataStructure.nodes.length;
    final boxHeight = 40.0;
    final spacing = 0.0; // No spacing for continuous block
    final minHeight = 300.0; // Minimum height for empty/short arrays
    final totalHeight = isArray
        ? (itemCount > 0
            ? (itemCount * boxHeight + (itemCount - 1) * spacing + 60.0).clamp(minHeight, double.infinity)
            : minHeight)
        : minHeight;

    if (isArray) {
      return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          height: totalHeight,
          child: Stack(
            children: [
              // Background canvas for non-interactive elements
              CustomPaint(
                painter: DataStructurePainter(
                  dataStructure: widget.dataStructure,
                  dataStructureInfo: widget.dataStructureInfo,
                  animationValue: widget.animationController.value,
                ),
                child: Container(),
              ),
              // Interactive node widgets
              ..._buildInteractiveNodes(),
            ],
          ),
        ),
      );
    } else {
      return CustomPaint(
        painter: DataStructurePainter(
          dataStructure: widget.dataStructure,
          dataStructureInfo: widget.dataStructureInfo,
          animationValue: widget.animationController.value,
        ),
        child: Container(),
      );
    }
  }

  List<Widget> _buildInteractiveNodes() {
    final nodes = widget.dataStructure.nodes;
    final boxWidth = 80.0;
    final boxHeight = 40.0;
    final spacing = 0.0; // No spacing for continuous block
    final startX = MediaQuery.of(context).size.width / 2 - boxWidth / 2;
    final startY = 40.0;

    return List.generate(nodes.length, (index) {
      final node = nodes[index];
      final x = startX;
      final y = startY + index * (boxHeight + spacing);

      return Positioned(
        left: x,
        top: y,
        child: GestureDetector(
          onTap: () => _showEditDialog(index, node.value),
          child: Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              color: (node.color != null && node.color != Colors.grey) ? node.color : Colors.transparent, // Show color only if it's a highlight color
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey, // Always gray outline
                width: 2.0,
              ),
            ),
                          child: Center(
                child: Text(
                  node.value.toString(),
                  style: TextStyle(
                    color: (node.color != null && node.color != Colors.grey) ? Colors.white : Colors.black, // White text when highlighted, black when default
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ),
        ),
      );
    });
  }

  void _showEditDialog(int index, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Node at Index $index'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current value: $currentValue'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'New Value',
                  hintText: 'Enter a new value',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newValue = int.tryParse(controller.text);
                if (newValue != null) {
                  Navigator.of(context).pop();
                  _updateNodeValue(index, newValue);
                } else {
                  // Show error for invalid input
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateNodeValue(int index, int newValue) {
    // Update the node value in the data structure
    if (widget.dataStructure is ArrayDataStructure) {
      final arrayStructure = widget.dataStructure as ArrayDataStructure;
      arrayStructure.updateNodeValue(index, newValue);
      
      // Notify parent widget to refresh
      if (widget.onNodeUpdated != null) {
        widget.onNodeUpdated!();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated node at index $index to $newValue'),
          backgroundColor: widget.dataStructureInfo.color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class DataStructurePainter extends CustomPainter {
  final DataStructure dataStructure;
  final DataStructureInfo dataStructureInfo;
  final double animationValue;

  DataStructurePainter({
    required this.dataStructure,
    required this.dataStructureInfo,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('DataStructureCanvas.paint called with ${dataStructure.nodes.length} nodes, current step: ${dataStructure.currentStep}');
    
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = dataStructureInfo.color;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = dataStructureInfo.color
      ..strokeWidth = 2.0;



    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: '',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    // Draw nodes based on data structure type
    switch (dataStructureInfo.type) {
      case DataStructureType.array:
        _drawArray(canvas, size, paint, strokePaint, textPainter);
        break;
      case DataStructureType.linkedList:
        _drawLinkedList(canvas, size, paint, strokePaint, textPainter);
        break;
      case DataStructureType.stack:
        _drawStack(canvas, size, paint, strokePaint, textPainter);
        break;
      case DataStructureType.queue:
        _drawQueue(canvas, size, paint, strokePaint, textPainter);
        break;
      case DataStructureType.binaryTree:
      case DataStructureType.binarySearchTree:
        _drawBinaryTree(canvas, size, paint, strokePaint, textPainter);
        break;
      case DataStructureType.minHeap:
      case DataStructureType.maxHeap:
        _drawHeap(canvas, size, paint, strokePaint, textPainter);
        break;
      case DataStructureType.graph:
        _drawGraph(canvas, size, paint, strokePaint, textPainter);
        break;
    }
  }

  void _drawArray(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    final nodes = dataStructure.nodes;
    final boxWidth = 80.0;
    final boxHeight = 40.0;
    final spacing = 0.0; // No spacing for continuous block
    final startX = size.width / 2 - boxWidth / 2;
    final startY = 40.0;
    final indexOffsetX = startX - 40.0;

    // Only draw the index labels since the nodes themselves are now interactive widgets
    for (int i = 0; i < nodes.length; i++) {
      final y = startY + i * (boxHeight + spacing);

      // Draw index on the left
      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: dataStructureInfo.color,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          indexOffsetX + 20 - textPainter.width / 2,
          y + boxHeight / 2 - textPainter.height / 2,
        ),
      );
    }
  }

  void _drawLinkedList(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    final nodes = dataStructure.nodes;
    final nodeRadius = 25.0;
    final spacing = 100.0;
    final startX = 50.0;
    final centerY = size.height / 2;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final x = startX + (i * spacing);
      final y = centerY;

      // Draw node
      canvas.drawCircle(
        Offset(x, y),
        nodeRadius,
        paint,
      );

      // Draw border
      canvas.drawCircle(
        Offset(x, y),
        nodeRadius,
        strokePaint,
      );

      // Draw value
      textPainter.text = TextSpan(
        text: node.value.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );

      // Draw arrow to next node
      if (i < nodes.length - 1) {
        final nextX = x + spacing;
        final arrowStart = Offset(x + nodeRadius, y);
        final arrowEnd = Offset(nextX - nodeRadius, y);

        // Draw arrow line
        canvas.drawLine(arrowStart, arrowEnd, strokePaint);

        // Draw arrow head
        final arrowHead = Path();
        arrowHead.moveTo(arrowEnd.dx - 10, arrowEnd.dy - 5);
        arrowHead.lineTo(arrowEnd.dx, arrowEnd.dy);
        arrowHead.lineTo(arrowEnd.dx - 10, arrowEnd.dy + 5);
        canvas.drawPath(arrowHead, strokePaint);
      }
    }
  }

  void _drawStack(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    final nodes = dataStructure.nodes;
    final nodeWidth = 80.0;
    final nodeHeight = 40.0;
    final centerX = size.width / 2;
    final startY = size.height - 100.0;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final y = startY - (i * (nodeHeight + 5));

      // Draw node rectangle
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, y),
          width: nodeWidth,
          height: nodeHeight,
        ),
        const Radius.circular(8),
      );

      canvas.drawRRect(rect, paint);
      canvas.drawRRect(rect, strokePaint);

      // Draw value
      textPainter.text = TextSpan(
        text: node.value.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );
    }

    // Draw stack label
    textPainter.text = TextSpan(
      text: 'TOP',
      style: TextStyle(
        color: dataStructureInfo.color,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX + nodeWidth / 2 + 10,
        startY - (nodes.length * (nodeHeight + 5)) - 10,
      ),
    );
  }

  void _drawQueue(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    final nodes = dataStructure.nodes;
    final nodeWidth = 80.0;
    final nodeHeight = 40.0;
    final spacing = 90.0;
    final startX = 50.0;
    final centerY = size.height / 2;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final x = startX + (i * spacing);
      final y = centerY;

      // Draw node rectangle
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: nodeWidth,
          height: nodeHeight,
        ),
        const Radius.circular(8),
      );

      canvas.drawRRect(rect, paint);
      canvas.drawRRect(rect, strokePaint);

      // Draw value
      textPainter.text = TextSpan(
        text: node.value.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );
    }

    // Draw front and rear labels
    if (nodes.isNotEmpty) {
      textPainter.text = TextSpan(
        text: 'FRONT',
        style: TextStyle(
          color: dataStructureInfo.color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(startX - textPainter.width / 2, centerY - nodeHeight / 2 - 20),
      );

      textPainter.text = TextSpan(
        text: 'REAR',
        style: TextStyle(
          color: dataStructureInfo.color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          startX + (nodes.length - 1) * spacing - textPainter.width / 2,
          centerY + nodeHeight / 2 + 10,
        ),
      );
    }
  }

  void _drawBinaryTree(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    final nodes = dataStructure.nodes;
    final nodeRadius = 20.0;
    final levelHeight = 80.0;

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final level = _getTreeLevel(i);
      final positionInLevel = _getPositionInLevel(i, level);
      final maxNodesInLevel = 1 << level;
      final spacing = size.width / (maxNodesInLevel + 1);
      final x = spacing * (positionInLevel + 1);
      final y = 50.0 + (level * levelHeight);

      // Draw node
      canvas.drawCircle(
        Offset(x, y),
        nodeRadius,
        paint,
      );

      canvas.drawCircle(
        Offset(x, y),
        nodeRadius,
        strokePaint,
      );

      // Draw value
      textPainter.text = TextSpan(
        text: node.value.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );

      // Draw connections to children
      final leftChildIndex = 2 * i + 1;
      final rightChildIndex = 2 * i + 2;

      if (leftChildIndex < nodes.length) {
        final childLevel = _getTreeLevel(leftChildIndex);
        final childPositionInLevel = _getPositionInLevel(leftChildIndex, childLevel);
        final childMaxNodesInLevel = 1 << childLevel;
        final childSpacing = size.width / (childMaxNodesInLevel + 1);
        final childX = childSpacing * (childPositionInLevel + 1);
        final childY = 50.0 + (childLevel * levelHeight);

        canvas.drawLine(
          Offset(x, y + nodeRadius),
          Offset(childX, childY - nodeRadius),
          strokePaint,
        );
      }

      if (rightChildIndex < nodes.length) {
        final childLevel = _getTreeLevel(rightChildIndex);
        final childPositionInLevel = _getPositionInLevel(rightChildIndex, childLevel);
        final childMaxNodesInLevel = 1 << childLevel;
        final childSpacing = size.width / (childMaxNodesInLevel + 1);
        final childX = childSpacing * (childPositionInLevel + 1);
        final childY = 50.0 + (childLevel * levelHeight);

        canvas.drawLine(
          Offset(x, y + nodeRadius),
          Offset(childX, childY - nodeRadius),
          strokePaint,
        );
      }
    }
  }

  void _drawHeap(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    // Similar to binary tree but with heap-specific visual cues
    _drawBinaryTree(canvas, size, paint, strokePaint, textPainter);
  }

  void _drawGraph(Canvas canvas, Size size, Paint paint, Paint strokePaint, TextPainter textPainter) {
    final nodes = dataStructure.nodes;
    final nodeRadius = 25.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = 150.0;

    // Draw nodes in a circle
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final angle = (2 * 3.14159 * i) / nodes.length;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      // Draw node
      canvas.drawCircle(
        Offset(x, y),
        nodeRadius,
        paint,
      );

      canvas.drawCircle(
        Offset(x, y),
        nodeRadius,
        strokePaint,
      );

      // Draw value
      textPainter.text = TextSpan(
        text: node.value.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );
    }

    // Draw edges (simplified - just connect adjacent nodes)
    for (int i = 0; i < nodes.length; i++) {
      final angle1 = (2 * 3.14159 * i) / nodes.length;
      final x1 = centerX + radius * cos(angle1);
      final y1 = centerY + radius * sin(angle1);

      final nextIndex = (i + 1) % nodes.length;
      final angle2 = (2 * 3.14159 * nextIndex) / nodes.length;
      final x2 = centerX + radius * cos(angle2);
      final y2 = centerY + radius * sin(angle2);

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        strokePaint,
      );
    }
  }

  int _getTreeLevel(int index) {
    if (index == 0) return 0;
    return (log(index + 1) / log(2)).floor();
  }

  int _getPositionInLevel(int index, int level) {
    return index - (1 << level) + 1;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 