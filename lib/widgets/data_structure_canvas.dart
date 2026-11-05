import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../data_structures/array_data_structure.dart';
import '../data_structures/graph_data_structure.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

// Constants for better maintainability
class CanvasConstants {
  static const double nodeSpacing = 16.0;
  static const double indexWidth = 30.0;
  static const double indexSpacing = 8.0;
  static const double arrowOffset = 40.0;
  static const double arrowSize = 8.0;
  static const double labelOffset = 8.0;
  static const double topArrowOffset = 20.0;
}

// Input validation utility
class NodeEditValidator {
  static String? validateInput(String input) {
    if (input.isEmpty) return 'Value cannot be empty';
    final value = int.tryParse(input);
    if (value == null) return 'Please enter a valid number';
    if (value < -999 || value > 999) {
      return 'Value must be between -999 and 999';
    }
    return null;
  }
}

// Main canvas widget
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
  late final Map<DataStructureType, DataStructureRenderer> _renderers;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeRenderers();
  }

  void _initializeRenderers() {
    _renderers = {
      DataStructureType.array: ArrayRenderer(),
      DataStructureType.linkedList: LinkedListRenderer(),
      DataStructureType.stack: StackRenderer(),
      DataStructureType.queue: QueueRenderer(),
      DataStructureType.binaryTree: TreeGraphRenderer(),
      DataStructureType.binarySearchTree: TreeGraphRenderer(),
      DataStructureType.minHeap: TreeGraphRenderer(),
      DataStructureType.maxHeap: TreeGraphRenderer(),
      DataStructureType.graph: TreeGraphRenderer(),
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToNode(int nodeIndex) {
    if (!_scrollController.hasClients) {
      AppLogger.ui('ScrollController has no clients, cannot scroll');
      return;
    }

    final renderer = _renderers[widget.dataStructureInfo.type];
    if (renderer == null) return;

    final targetScroll = renderer.calculateScrollPosition(
      nodeIndex,
      _scrollController.position.viewportDimension,
      _scrollController.position.maxScrollExtent,
    );

    AppLogger.ui('Scrolling to node $nodeIndex: target=$targetScroll');

    _scrollController.animateTo(
      targetScroll,
      duration: AppConstants.scrollDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final renderer = _renderers[widget.dataStructureInfo.type];
    if (renderer == null) {
      return _buildGenericView();
    }

    return renderer.buildView(
      context,
      widget.dataStructure,
      widget.dataStructureInfo,
      widget.animationController,
      _scrollController,
      _showEditDialog,
    );
  }

  Widget _buildGenericView() {
    return CustomPaint(
      painter: DataStructurePainter(
        dataStructure: widget.dataStructure,
        dataStructureInfo: widget.dataStructureInfo,
        animationValue: widget.animationController.value,
      ),
      child: Container(),
    );
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
                  hintText: 'Enter a value between -999 and 999',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _handleUpdate(controller.text, index),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _handleUpdate(String input, int index) {
    final validationError = NodeEditValidator.validateInput(input);
    if (validationError != null) {
      _showErrorDialog(validationError);
      return;
    }

    final newValue = int.parse(input);
    if (widget.dataStructure is ArrayDataStructure) {
      final arrayStructure = widget.dataStructure as ArrayDataStructure;
      arrayStructure.updateNodeValue(index, newValue);
      widget.onNodeUpdated?.call();
    }
    Navigator.of(context).pop();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Abstract base class for data structure renderers
abstract class DataStructureRenderer {
  Widget buildView(
    BuildContext context,
    BaseDataStructure dataStructure,
    DataStructureInfo dataStructureInfo,
    AnimationController animationController,
    ScrollController scrollController,
    Function(int, int) onNodeTap,
  );

  double calculateScrollPosition(
    int nodeIndex,
    double viewportHeight,
    double maxScroll,
  ) {
    final nodeY =
        AppConstants.nodeStartY +
        nodeIndex * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);
    final nodeBottom = nodeY + AppConstants.nodeBoxHeight;
    final targetScroll =
        nodeBottom - (viewportHeight * AppConstants.scrollTargetRatio);
    return targetScroll.clamp(0.0, maxScroll);
  }

  double calculateTotalHeight(int itemCount) {
    if (itemCount == 0) return AppConstants.minCanvasHeight;
    return (itemCount * AppConstants.nodeBoxHeight +
            (itemCount - 1) * CanvasConstants.nodeSpacing +
            2 * AppConstants.nodeStartY)
        .clamp(AppConstants.minCanvasHeight, double.infinity);
  }

  Widget buildNodeWidget(
    int index,
    dynamic node,
    Function(int, int) onNodeTap, {
    bool showIndex = true,
    int? displayIndex,
  }) {
    final actualIndex = displayIndex ?? index;

    return SizedBox(
      width:
          AppConstants.nodeBoxWidth +
          CanvasConstants.indexWidth +
          CanvasConstants.indexSpacing,
      height: AppConstants.nodeBoxHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIndex) ...[
            Container(
              width: CanvasConstants.indexWidth,
              alignment: Alignment.centerRight,
              child: Text(
                '[$actualIndex]',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppConstants.nodeTextSize * 0.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: CanvasConstants.indexSpacing),
          ],
          GestureDetector(
            onTap: () => onNodeTap(index, node.value),
            child: Container(
              width: AppConstants.nodeBoxWidth,
              height: AppConstants.nodeBoxHeight,
              decoration: BoxDecoration(
                color: _getNodeColor(node.color),
                borderRadius: BorderRadius.circular(
                  AppConstants.nodeBorderRadius,
                ),
                border: Border.all(
                  color: AppConstants.defaultNodeColor,
                  width: AppConstants.nodeBorderWidth,
                ),
              ),
              child: Center(
                child: Text(
                  node.value.toString(),
                  style: TextStyle(
                    color: _getTextColor(node.color),
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
  }

  Color _getNodeColor(Color? nodeColor) {
    return (nodeColor != null && nodeColor != AppConstants.defaultNodeColor)
        ? nodeColor
        : Colors.grey[100]!;
  }

  Color _getTextColor(Color? nodeColor) {
    return (nodeColor != null && nodeColor != AppConstants.defaultNodeColor)
        ? Colors.white
        : Colors.black;
  }
}

// Array-specific renderer
class ArrayRenderer extends DataStructureRenderer {
  @override
  Widget buildView(
    BuildContext context,
    BaseDataStructure dataStructure,
    DataStructureInfo dataStructureInfo,
    AnimationController animationController,
    ScrollController scrollController,
    Function(int, int) onNodeTap,
  ) {
    final totalHeight = calculateTotalHeight(dataStructure.nodes.length);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: double.infinity,
        height: totalHeight,
        child: Stack(
          children: [
            CustomPaint(
              painter: DataStructurePainter(
                dataStructure: dataStructure,
                dataStructureInfo: dataStructureInfo,
                animationValue: animationController.value,
              ),
              child: Container(),
            ),
            ..._buildNodes(context, dataStructure.nodes, onNodeTap),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNodes(
    BuildContext context,
    List<dynamic> nodes,
    Function(int, int) onNodeTap,
  ) {
    final totalItemWidth =
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing +
        AppConstants.nodeBoxWidth;
    final startX = (MediaQuery.of(context).size.width - totalItemWidth) / 2;

    return List.generate(nodes.length, (index) {
      final node = nodes[index];
      final y =
          AppConstants.nodeStartY +
          index * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);

      return Positioned(
        left: startX,
        top: y,
        child: buildNodeWidget(index, node, onNodeTap),
      );
    });
  }
}

// LinkedList-specific renderer
class LinkedListRenderer extends DataStructureRenderer {
  @override
  Widget buildView(
    BuildContext context,
    BaseDataStructure dataStructure,
    DataStructureInfo dataStructureInfo,
    AnimationController animationController,
    ScrollController scrollController,
    Function(int, int) onNodeTap,
  ) {
    final totalHeight = calculateTotalHeight(dataStructure.nodes.length);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            CustomPaint(
              painter: LinkedListPainter(
                dataStructure: dataStructure,
                animationValue: animationController.value,
                canvasWidth: MediaQuery.of(context).size.width,
              ),
              child: Container(),
            ),
            ..._buildNodes(context, dataStructure.nodes, onNodeTap),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNodes(
    BuildContext context,
    List<dynamic> nodes,
    Function(int, int) onNodeTap,
  ) {
    final nodeRowWidth =
        AppConstants.nodeBoxWidth +
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing;
    final startX = (MediaQuery.of(context).size.width - nodeRowWidth) / 2;

    return List.generate(nodes.length, (index) {
      final node = nodes[index];
      final y =
          AppConstants.nodeStartY +
          index * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);

      return Positioned(
        left: startX,
        top: y,
        child: buildNodeWidget(index, node, onNodeTap, showIndex: false),
      );
    });
  }
}

// Stack-specific renderer
class StackRenderer extends DataStructureRenderer {
  @override
  Widget buildView(
    BuildContext context,
    BaseDataStructure dataStructure,
    DataStructureInfo dataStructureInfo,
    AnimationController animationController,
    ScrollController scrollController,
    Function(int, int) onNodeTap,
  ) {
    final totalHeight = calculateTotalHeight(dataStructure.nodes.length);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: double.infinity,
        height: totalHeight,
        child: Stack(
          children: [
            CustomPaint(
              painter: StackTopArrowPainter(
                nodeCount: dataStructure.nodes.length,
                canvasWidth: MediaQuery.of(context).size.width,
              ),
              child: Container(),
            ),
            ..._buildNodes(context, dataStructure.nodes, onNodeTap),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNodes(
    BuildContext context,
    List<dynamic> nodes,
    Function(int, int) onNodeTap,
  ) {
    final nodeRowWidth =
        AppConstants.nodeBoxWidth +
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing;
    final startX = (MediaQuery.of(context).size.width - nodeRowWidth) / 2;

    return List.generate(nodes.length, (index) {
      final node = nodes[index]; // Display nodes[0] at bottom
      final actualIndex = index;
      final stackIndex = index; // Stack index: bottom=0, top=length-1
      final y =
          AppConstants.nodeStartY +
          (nodes.length - 1 - index) *
              (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);

      return Positioned(
        left: startX,
        top: y,
        child: buildNodeWidget(
          actualIndex,
          node,
          onNodeTap,
          displayIndex: stackIndex,
        ),
      );
    });
  }
}

// Queue Renderer - displays queue vertically with front at top, rear at bottom
class QueueRenderer extends DataStructureRenderer {
  @override
  Widget buildView(
    BuildContext context,
    BaseDataStructure dataStructure,
    DataStructureInfo dataStructureInfo,
    AnimationController animationController,
    ScrollController scrollController,
    Function(int, int) onNodeTap,
  ) {
    final totalHeight = calculateTotalHeight(dataStructure.nodes.length);

    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: double.infinity,
        height: totalHeight,
        child: Stack(
          children: [
            CustomPaint(
              painter: QueueIndicatorPainter(
                nodeCount: dataStructure.nodes.length,
                canvasWidth: MediaQuery.of(context).size.width,
              ),
              child: Container(),
            ),
            ..._buildNodes(context, dataStructure.nodes, onNodeTap),
            // Empty queue message
            if (dataStructure.nodes.isEmpty) ...[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Queue is empty\nAdd elements using Enqueue',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNodes(
    BuildContext context,
    List<dynamic> nodes,
    Function(int, int) onNodeTap,
  ) {
    final nodeRowWidth =
        AppConstants.nodeBoxWidth +
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing;
    final startX = (MediaQuery.of(context).size.width - nodeRowWidth) / 2;

    return List.generate(nodes.length, (index) {
      final node = nodes[index];
      // For queue: index 0 is front (top), index n-1 is rear (bottom)
      final y =
          AppConstants.nodeStartY +
          index * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);

      return Positioned(
        left: startX,
        top: y,
        child: buildNodeWidget(index, node, onNodeTap, displayIndex: index),
      );
    });
  }

  @override
  double calculateTotalHeight(int itemCount) {
    if (itemCount == 0) return AppConstants.minCanvasHeight;
    return (itemCount * AppConstants.nodeBoxHeight +
            (itemCount - 1) * CanvasConstants.nodeSpacing +
            2 * AppConstants.nodeStartY +
            100) // Extra space for indicators
        .clamp(AppConstants.minCanvasHeight, double.infinity);
  }

  @override
  double calculateScrollPosition(
    int nodeIndex,
    double viewportHeight,
    double maxScroll,
  ) {
    final nodeY =
        AppConstants.nodeStartY +
        nodeIndex * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);
    final nodeBottom = nodeY + AppConstants.nodeBoxHeight;
    final targetScroll =
        nodeBottom - (viewportHeight * AppConstants.scrollTargetRatio);
    return targetScroll.clamp(0.0, maxScroll);
  }
}

class TreeGraphRenderer extends DataStructureRenderer {
  @override
  Widget buildView(
    BuildContext context,
    BaseDataStructure dataStructure,
    DataStructureInfo dataStructureInfo,
    AnimationController animationController,
    ScrollController scrollController,
    Function(int, int) onNodeTap,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final nodes = dataStructure.nodes;
        final canvasWidth = constraints.maxWidth > 760
            ? constraints.maxWidth
            : 760.0;
        final maxY = nodes.isEmpty
            ? AppConstants.minCanvasHeight
            : nodes
                      .map((node) => node.position.dy)
                      .reduce((a, b) => a > b ? a : b) +
                  100;
        final canvasHeight = maxY < AppConstants.minCanvasHeight
            ? AppConstants.minCanvasHeight
            : maxY;
        return InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(80),
          minScale: 0.5,
          maxScale: 2.5,
          child: SizedBox(
            width: canvasWidth,
            height: canvasHeight,
            child: CustomPaint(
              painter: StructureConnectionPainter(
                nodes: nodes,
                graphEdges: dataStructure is GraphDataStructure
                    ? dataStructure.edges
                    : const [],
                isGraph: dataStructure is GraphDataStructure,
                color: dataStructureInfo.color,
              ),
              child: Stack(
                children: List.generate(nodes.length, (index) {
                  final node = nodes[index];
                  return Positioned(
                    left: node.position.dx - AppConstants.nodeBoxWidth / 2,
                    top: node.position.dy - AppConstants.nodeBoxHeight / 2,
                    child: buildNodeWidget(
                      index,
                      node,
                      (_, __) {},
                      showIndex: false,
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StructureConnectionPainter extends CustomPainter {
  StructureConnectionPainter({
    required this.nodes,
    required this.graphEdges,
    required this.isGraph,
    required this.color,
  });

  final List<dynamic> nodes;
  final List<(int, int)> graphEdges;
  final bool isGraph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withValues(alpha: 0.75);
    if (isGraph) {
      final byValue = {for (final node in nodes) (node.value as int): node};
      for (final edge in graphEdges) {
        final from = byValue[edge.$1];
        final to = byValue[edge.$2];
        if (from != null && to != null) {
          canvas.drawLine(from.position, to.position, paint);
        }
      }
      return;
    }
    final byIndex = <int, dynamic>{
      for (final node in nodes)
        if (int.tryParse(node.label ?? '') != null)
          int.parse(node.label!): node,
    };
    for (final entry in byIndex.entries) {
      if (entry.key == 0) continue;
      final parent = byIndex[(entry.key - 1) ~/ 2];
      if (parent != null) {
        canvas.drawLine(parent.position, entry.value.position, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StructureConnectionPainter oldDelegate) =>
      oldDelegate.nodes != nodes ||
      oldDelegate.graphEdges != graphEdges ||
      oldDelegate.isGraph != isGraph ||
      oldDelegate.color != color;
}

// Custom Painters with improved performance
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
    AppLogger.ui(
      'DataStructureCanvas.paint called with ${dataStructure.nodes.length} nodes',
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = dataStructureInfo.color;

    final nodes = dataStructure.nodes;

    // Draw connections for non-array data structures
    if (dataStructureInfo.type != DataStructureType.array) {
      for (int i = 0; i < nodes.length - 1; i++) {
        final start = nodes[i].position;
        final end = nodes[i + 1].position;
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DataStructurePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.dataStructure.nodes.length != dataStructure.nodes.length;
  }
}

class LinkedListPainter extends CustomPainter {
  final BaseDataStructure dataStructure;
  final double animationValue;
  final double canvasWidth;

  LinkedListPainter({
    required this.dataStructure,
    required this.animationValue,
    required this.canvasWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodes = dataStructure.nodes;
    final nodeCount = nodes.length;
    if (nodeCount == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppConstants.defaultNodeColor;

    final nodeRowWidth =
        AppConstants.nodeBoxWidth +
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing;
    final startX = (canvasWidth - nodeRowWidth) / 2;

    _drawHeadArrow(canvas, paint, startX, nodeCount);
    _drawCurrentArrow(canvas, paint, startX, nodeRowWidth, nodes);
    _drawNodeConnections(canvas, paint, startX, nodeRowWidth, nodeCount);
    _drawTailArrow(canvas, paint, startX, nodeCount);
  }

  void _drawHeadArrow(
    Canvas canvas,
    Paint paint,
    double startX,
    int nodeCount,
  ) {
    final nodeCenterY =
        AppConstants.nodeStartY + AppConstants.nodeBoxHeight / 2;
    final arrowEndX = startX;
    final arrowStartX = startX - CanvasConstants.arrowOffset;

    _drawHorizontalArrow(
      canvas,
      paint,
      arrowStartX,
      arrowEndX,
      nodeCenterY,
      true,
    );
    _drawLabel(
      canvas,
      'Head',
      (arrowStartX + arrowEndX) / 2,
      nodeCenterY - CanvasConstants.labelOffset,
      AppConstants.defaultNodeColor,
    );
  }

  void _drawCurrentArrow(
    Canvas canvas,
    Paint paint,
    double startX,
    double nodeRowWidth,
    List<dynamic> nodes,
  ) {
    int activeIndex = 0;
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].color == AppConstants.currentNodeColor) {
        activeIndex = i;
        break;
      }
    }

    final activeNodeY =
        AppConstants.nodeStartY +
        activeIndex *
            (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);
    final currentArrowEndX = startX + nodeRowWidth;
    final currentArrowStartX = currentArrowEndX + CanvasConstants.arrowOffset;
    final currentArrowY = activeNodeY + AppConstants.nodeBoxHeight / 2;

    _drawHorizontalArrow(
      canvas,
      paint,
      currentArrowStartX,
      currentArrowEndX,
      currentArrowY,
      false,
    );
    _drawLabel(
      canvas,
      'current',
      currentArrowStartX,
      currentArrowY - CanvasConstants.labelOffset,
      Colors.orange,
    );
  }

  void _drawNodeConnections(
    Canvas canvas,
    Paint paint,
    double startX,
    double nodeRowWidth,
    int nodeCount,
  ) {
    for (int i = 0; i < nodeCount - 1; i++) {
      final x = startX + nodeRowWidth / 2;
      final y1 =
          AppConstants.nodeStartY +
          i * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing) +
          AppConstants.nodeBoxHeight;
      final y2 =
          AppConstants.nodeStartY +
          (i + 1) * (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
      _drawVerticalArrowhead(canvas, paint, x, y2);
    }
  }

  void _drawTailArrow(
    Canvas canvas,
    Paint paint,
    double startX,
    int nodeCount,
  ) {
    final nodeCenterY =
        AppConstants.nodeStartY +
        (nodeCount - 1) *
            (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing) +
        AppConstants.nodeBoxHeight / 2;
    final arrowEndX = startX;
    final arrowStartX = startX - CanvasConstants.arrowOffset;

    _drawHorizontalArrow(
      canvas,
      paint,
      arrowStartX,
      arrowEndX,
      nodeCenterY,
      true,
    );
    _drawLabel(
      canvas,
      'Tail',
      (arrowStartX + arrowEndX) / 2,
      nodeCenterY + CanvasConstants.labelOffset,
      AppConstants.defaultNodeColor,
    );
  }

  void _drawHorizontalArrow(
    Canvas canvas,
    Paint paint,
    double startX,
    double endX,
    double y,
    bool pointingRight,
  ) {
    canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);

    final path = Path();
    if (pointingRight) {
      path.moveTo(endX, y);
      path.lineTo(
        endX - CanvasConstants.arrowSize,
        y - CanvasConstants.arrowSize / 2,
      );
      path.moveTo(endX, y);
      path.lineTo(
        endX - CanvasConstants.arrowSize,
        y + CanvasConstants.arrowSize / 2,
      );
    } else {
      path.moveTo(endX, y);
      path.lineTo(
        endX + CanvasConstants.arrowSize,
        y - CanvasConstants.arrowSize / 2,
      );
      path.moveTo(endX, y);
      path.lineTo(
        endX + CanvasConstants.arrowSize,
        y + CanvasConstants.arrowSize / 2,
      );
    }
    canvas.drawPath(path, paint);
  }

  void _drawVerticalArrowhead(Canvas canvas, Paint paint, double x, double y) {
    final path = Path();
    path.moveTo(x, y);
    path.lineTo(
      x - CanvasConstants.arrowSize / 2,
      y - CanvasConstants.arrowSize,
    );
    path.moveTo(x, y);
    path.lineTo(
      x + CanvasConstants.arrowSize / 2,
      y - CanvasConstants.arrowSize,
    );
    canvas.drawPath(path, paint);
  }

  void _drawLabel(Canvas canvas, String text, double x, double y, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height),
    );
  }

  @override
  bool shouldRepaint(covariant LinkedListPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.dataStructure.nodes.length != dataStructure.nodes.length;
  }
}

class StackTopArrowPainter extends CustomPainter {
  final int nodeCount;
  final double canvasWidth;

  StackTopArrowPainter({required this.nodeCount, required this.canvasWidth});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount == 0) return;

    final nodeRowWidth =
        AppConstants.nodeBoxWidth +
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing;
    final startX = (canvasWidth - nodeRowWidth) / 2;
    final topNodeY = AppConstants.nodeStartY;
    final arrowStartX = startX + nodeRowWidth + CanvasConstants.topArrowOffset;
    final arrowEndX = startX + nodeRowWidth;
    final arrowY = topNodeY + AppConstants.nodeBoxHeight / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = AppConstants.defaultNodeColor;

    // Draw left-pointing arrow
    canvas.drawLine(
      Offset(arrowStartX, arrowY),
      Offset(arrowEndX, arrowY),
      paint,
    );

    // Draw arrowhead
    final path = Path();
    path.moveTo(arrowEndX, arrowY);
    path.lineTo(
      arrowEndX + CanvasConstants.arrowSize,
      arrowY - CanvasConstants.arrowSize / 2,
    );
    path.moveTo(arrowEndX, arrowY);
    path.lineTo(
      arrowEndX + CanvasConstants.arrowSize,
      arrowY + CanvasConstants.arrowSize / 2,
    );
    canvas.drawPath(path, paint);

    // Draw 'Top' label
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Top',
        style: TextStyle(
          color: AppConstants.defaultNodeColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final labelX =
        arrowStartX + (arrowEndX - arrowStartX) / 2 - textPainter.width / 2;
    final labelY = arrowY - textPainter.height - CanvasConstants.labelOffset;
    textPainter.paint(canvas, Offset(labelX, labelY));
  }

  @override
  bool shouldRepaint(covariant StackTopArrowPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount;
  }
}

class QueueIndicatorPainter extends CustomPainter {
  final int nodeCount;
  final double canvasWidth;

  QueueIndicatorPainter({required this.nodeCount, required this.canvasWidth});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount == 0) return;

    final nodeRowWidth =
        AppConstants.nodeBoxWidth +
        CanvasConstants.indexWidth +
        CanvasConstants.indexSpacing;
    final startX = (canvasWidth - nodeRowWidth) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw Front indicator (pointing to top/first node)
    final frontNodeY = AppConstants.nodeStartY;
    final frontArrowStartX =
        startX + nodeRowWidth + CanvasConstants.topArrowOffset;
    final frontArrowEndX = startX + nodeRowWidth;
    final frontArrowY = frontNodeY + AppConstants.nodeBoxHeight / 2;

    paint.color = Colors.blue;
    canvas.drawLine(
      Offset(frontArrowStartX, frontArrowY),
      Offset(frontArrowEndX, frontArrowY),
      paint,
    );

    // Draw arrowhead pointing left
    final frontPath = Path();
    frontPath.moveTo(frontArrowEndX, frontArrowY);
    frontPath.lineTo(
      frontArrowEndX + CanvasConstants.arrowSize,
      frontArrowY - CanvasConstants.arrowSize / 2,
    );
    frontPath.moveTo(frontArrowEndX, frontArrowY);
    frontPath.lineTo(
      frontArrowEndX + CanvasConstants.arrowSize,
      frontArrowY + CanvasConstants.arrowSize / 2,
    );
    canvas.drawPath(frontPath, paint);

    // Draw 'Front' label
    final frontTextPainter = TextPainter(
      text: TextSpan(
        text: 'Front',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    frontTextPainter.layout();
    final frontLabelX =
        frontArrowStartX +
        (frontArrowEndX - frontArrowStartX) / 2 -
        frontTextPainter.width / 2;
    final frontLabelY =
        frontArrowY - frontTextPainter.height - CanvasConstants.labelOffset;
    frontTextPainter.paint(canvas, Offset(frontLabelX, frontLabelY));

    // Draw Rear indicator (pointing to bottom/last node)
    final rearNodeY =
        AppConstants.nodeStartY +
        (nodeCount - 1) *
            (AppConstants.nodeBoxHeight + CanvasConstants.nodeSpacing);
    final rearArrowStartX =
        startX + nodeRowWidth + CanvasConstants.topArrowOffset;
    final rearArrowEndX = startX + nodeRowWidth;
    final rearArrowY = rearNodeY + AppConstants.nodeBoxHeight / 2;

    paint.color = Colors.green;
    canvas.drawLine(
      Offset(rearArrowStartX, rearArrowY),
      Offset(rearArrowEndX, rearArrowY),
      paint,
    );

    // Draw arrowhead pointing left
    final rearPath = Path();
    rearPath.moveTo(rearArrowEndX, rearArrowY);
    rearPath.lineTo(
      rearArrowEndX + CanvasConstants.arrowSize,
      rearArrowY - CanvasConstants.arrowSize / 2,
    );
    rearPath.moveTo(rearArrowEndX, rearArrowY);
    rearPath.lineTo(
      rearArrowEndX + CanvasConstants.arrowSize,
      rearArrowY + CanvasConstants.arrowSize / 2,
    );
    canvas.drawPath(rearPath, paint);

    // Draw 'Rear' label
    final rearTextPainter = TextPainter(
      text: TextSpan(
        text: 'Rear',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    rearTextPainter.layout();
    final rearLabelX =
        rearArrowStartX +
        (rearArrowEndX - rearArrowStartX) / 2 -
        rearTextPainter.width / 2;
    final rearLabelY = rearArrowY + CanvasConstants.labelOffset;
    rearTextPainter.paint(canvas, Offset(rearLabelX, rearLabelY));
  }

  @override
  bool shouldRepaint(covariant QueueIndicatorPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount;
  }
}
