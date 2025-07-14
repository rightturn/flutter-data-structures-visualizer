import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../data_structures/array_data_structure.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

class DataStructureCanvas extends StatefulWidget {
  final BaseDataStructure dataStructure;
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
      AppLogger.ui('ScrollController has no clients, cannot scroll');
      return;
    }
    
    final nodeY = AppConstants.nodeStartY + nodeIndex * (AppConstants.nodeBoxHeight + AppConstants.nodeSpacing);
    final nodeBottom = nodeY + AppConstants.nodeBoxHeight;
    
    // Get the current scroll position and viewport height
    final currentScroll = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    // Calculate the target scroll position to show the node at 25% from bottom
    final targetScroll = nodeBottom - (viewportHeight * AppConstants.scrollTargetRatio);
    
    // Ensure we don't scroll beyond bounds
    final clampedScroll = targetScroll.clamp(0.0, maxScroll);
    
    AppLogger.ui('Scrolling to node $nodeIndex: current=$currentScroll, target=$clampedScroll, nodeY=$nodeY, viewportHeight=$viewportHeight, maxScroll=$maxScroll');
    
    _scrollController.animateTo(
      clampedScroll,
      duration: AppConstants.scrollDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate required height for array
    final isArray = widget.dataStructureInfo.type == DataStructureType.array;
    final itemCount = widget.dataStructure.nodes.length;
    final minHeight = AppConstants.minCanvasHeight; // Minimum height for empty/short arrays
    final totalHeight = isArray
        ? (itemCount > 0
            ? (itemCount * AppConstants.nodeBoxHeight + (itemCount - 1) * AppConstants.nodeSpacing + 60.0).clamp(minHeight, double.infinity)
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
    // Calculate the total width of index + spacing + node box
    final totalItemWidth = 30 + 8 + AppConstants.nodeBoxWidth;
    // Center the entire row of items in the canvas
    final startX = (MediaQuery.of(context).size.width - totalItemWidth) / 2;

    return List.generate(nodes.length, (index) {
      final node = nodes[index];
      final x = startX;
      final y = AppConstants.nodeStartY + index * (AppConstants.nodeBoxHeight + AppConstants.nodeSpacing);

      return Positioned(
        left: x,
        top: y,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Index number (outside, to the left of the box)
            Container(
              width: 30,
              alignment: Alignment.centerRight,
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppConstants.nodeTextSize * 0.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Node box (with only the value inside)
            GestureDetector(
              onTap: () => _showEditDialog(index, node.value),
              child: Container(
                width: AppConstants.nodeBoxWidth,
                height: AppConstants.nodeBoxHeight,
                decoration: BoxDecoration(
                  color: (node.color != null && node.color != AppConstants.defaultNodeColor) ? node.color : Colors.transparent, // Show color only if it's a highlight color
                  borderRadius: BorderRadius.circular(AppConstants.nodeBorderRadius),
                  border: Border.all(
                    color: AppConstants.defaultNodeColor, // Always gray outline
                    width: AppConstants.nodeBorderWidth,
                  ),
                ),
                child: Center(
                  child: Text(
                    node.value.toString(),
                    style: TextStyle(
                      color: (node.color != null && node.color != AppConstants.defaultNodeColor) ? Colors.white : Colors.black, // White text when highlighted, black when default
                      fontSize: AppConstants.nodeTextSize,
                      fontWeight: AppConstants.nodeTextWeight,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
            TextButton(
              onPressed: () {
                final newValue = int.tryParse(controller.text);
                if (newValue != null) {
                  // Update the node value
                  if (widget.dataStructure is ArrayDataStructure) {
                    final arrayStructure = widget.dataStructure as ArrayDataStructure;
                    arrayStructure.updateNodeValue(index, newValue);
                    widget.onNodeUpdated?.call();
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

class DataStructurePainter extends CustomPainter {
  final BaseDataStructure dataStructure;
  final DataStructureInfo dataStructureInfo;
  final double animationValue;

  DataStructurePainter({
    required this.dataStructure,
    required this.dataStructureInfo,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    AppLogger.ui('DataStructureCanvas.paint called with ${dataStructure.nodes.length} nodes, current step: ${dataStructure.currentStep}');
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = dataStructureInfo.color;

    final nodes = dataStructure.nodes;
    
    // Draw connections between nodes (for non-array data structures)
    if (dataStructureInfo.type != DataStructureType.array) {
      for (int i = 0; i < nodes.length - 1; i++) {
        final start = nodes[i].position;
        final end = nodes[i + 1].position;
        
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
} 