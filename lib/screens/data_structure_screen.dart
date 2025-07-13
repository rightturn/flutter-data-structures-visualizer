import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/data_structure.dart';
import '../utils/data_structure_factory.dart';
import '../widgets/data_structure_canvas.dart';
import '../widgets/operation_controls.dart';
import '../widgets/learning_panel.dart';
import 'package:flutter/scheduler.dart';

class DataStructureScreen extends ConsumerStatefulWidget {
  final String dataStructureType;

  const DataStructureScreen({
    super.key,
    required this.dataStructureType,
  });

  @override
  ConsumerState<DataStructureScreen> createState() => _DataStructureScreenState();
}

class _DataStructureScreenState extends ConsumerState<DataStructureScreen>
    with TickerProviderStateMixin {
  late DataStructure _dataStructure;
  late DataStructureInfo _dataStructureInfo;
  late AnimationController _animationController;
  final GlobalKey<DataStructureCanvasState> _canvasKey = GlobalKey<DataStructureCanvasState>();

  // Animation controls state
  bool _isPlaying = false;
  Timer? _animationTimer;
  int _canvasRebuildKey = 0; // Key to force canvas rebuild

  @override
  void initState() {
    super.initState();
    _dataStructureInfo = DataStructureFactory.getInfo(
      DataStructureFactory.getTypeFromString(widget.dataStructureType),
    );
    _dataStructure = DataStructureFactory.createDataStructure(_dataStructureInfo.type);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _onTick() {
    if (_isPlaying && _dataStructure.animationSteps.isNotEmpty) {
      if (_dataStructure.currentStep < _dataStructure.animationSteps.length - 1) {
        setState(() {
          _dataStructure.nextStep();
        });
        
        // Handle scrolling to highlighted nodes
        _scrollToHighlightedNode();
      } else {
        setState(() {
          _isPlaying = false;
        });
        _animationTimer?.cancel();
      }
    }
  }

  void _scrollToHighlightedNode() {
    final nodes = _dataStructure.nodes;
    int nodeToScrollTo = -1;
    
    // Priority: blue (current) > green (found) > red (checked)
    for (int j = 0; j < nodes.length; j++) {
      if (nodes[j].color == Colors.blue) {
        nodeToScrollTo = j;
        break; // Blue has highest priority
      }
    }
    
    if (nodeToScrollTo == -1) {
      for (int j = 0; j < nodes.length; j++) {
        if (nodes[j].color == Colors.green) {
          nodeToScrollTo = j;
          break; // Green has second priority
        }
      }
    }
    
    if (nodeToScrollTo != -1) {
      debugPrint('Scrolling to node $nodeToScrollTo with color ${nodes[nodeToScrollTo].color}');
      _canvasKey.currentState?.scrollToNode(nodeToScrollTo);
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startAnimationTimer();
      } else {
        _animationTimer?.cancel();
      }
    });
  }

  void _goToPreviousStep() {
    setState(() {
      _dataStructure.previousStep();
      _isPlaying = false;
      _animationTimer?.cancel();
    });
    // Scroll to highlighted node after manual step change
    _scrollToHighlightedNode();
  }

  void _goToNextStep() {
    setState(() {
      _dataStructure.nextStep();
      _isPlaying = false;
      _animationTimer?.cancel();
    });
    // Scroll to highlighted node after manual step change
    _scrollToHighlightedNode();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _dataStructure.goToStep(value.toInt());
      _isPlaying = false;
      _animationTimer?.cancel();
    });
    // Scroll to highlighted node after manual step change
    _scrollToHighlightedNode();
  }

  void _onAnimationStateChanged(bool isPlaying) {
    setState(() {
      _isPlaying = isPlaying;
      if (isPlaying) {
        _startAnimationTimer();
      } else {
        _animationTimer?.cancel();
      }
    });
  }

  void _startAnimationTimer() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _onTick();
    });
  }

  void _resetToDefault() {
    setState(() {
      _isPlaying = false;
      _animationTimer?.cancel();
      // Reset to default state by clearing animation steps and colors
      if (_dataStructure is ArrayDataStructure) {
        final arrayStructure = _dataStructure as ArrayDataStructure;
        // Reset to default state
        arrayStructure.resetToDefault();
      }
      // Force canvas to rebuild completely
      _canvasRebuildKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArray = _dataStructureInfo.type == DataStructureType.array;
    final hasAnimation = _dataStructure.animationSteps.isNotEmpty;
    final currentStep = _dataStructure.currentStep;
    final totalSteps = _dataStructure.animationSteps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_dataStructureInfo.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: 'Learning Mode',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Learning Mode'),
                    ),
                    body: LearningPanel(
                      dataStructure: _dataStructure,
                      dataStructureInfo: _dataStructureInfo,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Main visualization area
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(51),
                ),
              ),
              child: DataStructureCanvas(
                key: ValueKey(_canvasRebuildKey),
                dataStructure: _dataStructure,
                animationController: _animationController,
                dataStructureInfo: _dataStructureInfo,
                onNodeHighlighted: (nodeIndex) {
                  _canvasKey.currentState?.scrollToNode(nodeIndex);
                },
                onNodeUpdated: () {
                  setState(() {});
                },
              ),
            ),
          ),
          // Animation controls (only for array and when there are animation steps)
          if (isArray && hasAnimation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Animation controls (only shown when there are animation steps)
                  if (hasAnimation) ...[
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      tooltip: 'Previous Step',
                      onPressed: currentStep > 0 ? _goToPreviousStep : null,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      tooltip: _isPlaying ? 'Pause' : 'Play',
                      onPressed: (currentStep < totalSteps - 1) ? _togglePlayPause : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      tooltip: 'Next Step',
                      onPressed: currentStep < totalSteps - 1 ? _goToNextStep : null,
                    ),
                    Expanded(
                      child: Slider(
                        value: currentStep.toDouble(),
                        min: 0,
                        max: (totalSteps > 0 ? (totalSteps - 1).toDouble() : 0),
                        divisions: totalSteps > 1 ? totalSteps - 1 : 1,
                        label: 'Step ${currentStep + 1}/$totalSteps',
                        onChanged: (totalSteps > 1) ? _onSliderChanged : null,
                      ),
                    ),
                  ] else ...[
                    // Placeholder when no animation
                    Expanded(child: Container()),
                  ],
                  // Reset button (always visible when there are nodes)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset to Default',
                    onPressed: _resetToDefault,
                  ),
                ],
              ),
            ),
          // Everything else is scrollable
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  OperationControls(
                    dataStructure: _dataStructure,
                    dataStructureInfo: _dataStructureInfo,
                    onOperationPerformed: () {
                      setState(() {});
                    },
                    onNodeHighlighted: (nodeIndex) {
                      _canvasKey.currentState?.scrollToNode(nodeIndex);
                    },
                    onAnimationStateChanged: _onAnimationStateChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 