import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/base_data_structure.dart';
import '../models/data_structure_info.dart';
import '../utils/data_structure_factory.dart';
import '../utils/logger.dart';
import '../utils/constants.dart';
import '../services/animation_service.dart';
import '../widgets/data_structure_canvas.dart';
import '../widgets/operation_controls.dart';
import '../widgets/learning_panel.dart';

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
  late BaseDataStructure _dataStructure;
  late DataStructureInfo _dataStructureInfo;
  late AnimationController _animationController;
  late AnimationService _animationService;
  final GlobalKey<DataStructureCanvasState> _canvasKey = GlobalKey<DataStructureCanvasState>();

  // Animation controls state
  bool _isPlaying = false;
  int _canvasRebuildKey = 0; // Key to force canvas rebuild

  @override
  void initState() {
    super.initState();
    _dataStructureInfo = DataStructureFactory.getInfo(
      DataStructureFactory.getTypeFromString(widget.dataStructureType),
    );
    _dataStructure = DataStructureFactory.createDataStructure(_dataStructureInfo.type);
    
    _animationController = AnimationController(
      duration: AppConstants.stepDuration,
      vsync: this,
    );

    _animationService = AnimationService(
      onStepChanged: _onStepChanged,
      onAnimationComplete: _onAnimationComplete,
      onAnimationStateChanged: _onAnimationStateChanged,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationService.dispose();
    super.dispose();
  }

  void _onStepChanged() {
    setState(() {
      // Force rebuild when step changes
    });
    
    // Handle scrolling to highlighted nodes
    _scrollToHighlightedNode();
  }

  void _onAnimationComplete() {
    setState(() {
      _isPlaying = false;
    });
    AppLogger.animation('Animation completed');
  }

  void _onAnimationStateChanged() {
    setState(() {
      _isPlaying = _animationService.isPlaying;
    });
  }

  void _scrollToHighlightedNode() {
    final nodes = _dataStructure.nodes;
    int nodeToScrollTo = -1;
    
    // Priority: blue (current) > green (found) > red (checked)
    for (int j = 0; j < nodes.length; j++) {
      if (nodes[j].color == AppConstants.currentNodeColor) {
        nodeToScrollTo = j;
        break; // Blue has highest priority
      }
    }
    
    if (nodeToScrollTo == -1) {
      for (int j = 0; j < nodes.length; j++) {
        if (nodes[j].color == AppConstants.foundNodeColor) {
          nodeToScrollTo = j;
          break; // Green has second priority
        }
      }
    }
    
    if (nodeToScrollTo != -1) {
      AppLogger.ui('Scrolling to node $nodeToScrollTo with color ${nodes[nodeToScrollTo].color}');
      _canvasKey.currentState?.scrollToNode(nodeToScrollTo);
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _animationService.pauseAnimation();
    } else {
      _animationService.startAnimation(_dataStructure);
    }
  }

  void _goToPreviousStep() {
    setState(() {
      _dataStructure.previousStep();
      _isPlaying = false;
    });
    // Scroll to highlighted node after manual step change
    _scrollToHighlightedNode();
  }

  void _goToNextStep() {
    setState(() {
      _dataStructure.nextStep();
      _isPlaying = false;
    });
    // Scroll to highlighted node after manual step change
    _scrollToHighlightedNode();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _dataStructure.goToStep(value.toInt());
      _isPlaying = false;
    });
    // Scroll to highlighted node after manual step change
    _scrollToHighlightedNode();
  }

  void _onAnimationStateChangedFromControls(bool isPlaying) {
    if (isPlaying) {
      _animationService.startAnimation(_dataStructure);
    } else {
      _animationService.pauseAnimation();
    }
  }

  void _resetToDefault() {
    setState(() {
      _isPlaying = false;
      // Reset to default state by clearing animation steps and colors
      _dataStructure.resetToDefault();
    });
    // Force canvas to rebuild completely
    _canvasRebuildKey++;
  }

  @override
  Widget build(BuildContext context) {
    final hasAnimation = _dataStructure.animationSteps.isNotEmpty;
    final currentStep = _dataStructure.currentStep;
    final totalSteps = _dataStructure.animationSteps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_dataStructureInfo.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            // Wide screen: side-by-side
            return Row(
              children: [
                // Left panel - Canvas
                Expanded(
                  flex: 2,
                  child: DataStructureCanvas(
                    key: ValueKey(_canvasRebuildKey),
                    dataStructure: _dataStructure,
                    animationController: _animationController,
                    dataStructureInfo: _dataStructureInfo,
                    onNodeHighlighted: (index) {
                      AppLogger.ui('Node highlighted: $index');
                    },
                    onNodeUpdated: () {
                      setState(() {});
                    },
                  ),
                ),
                // Right panel - Controls and Learning
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        OperationControls(
                          dataStructure: _dataStructure,
                          dataStructureInfo: _dataStructureInfo,
                          onOperationPerformed: () {
                            setState(() {});
                          },
                          onAnimationStateChanged: _onAnimationStateChangedFromControls,
                        ),
                        LearningPanel(
                          dataStructure: _dataStructure,
                          dataStructureInfo: _dataStructureInfo,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Narrow screen: stacked
            return Column(
              children: [
                // Canvas
                Expanded(
                  flex: 2,
                  child: DataStructureCanvas(
                    key: ValueKey(_canvasRebuildKey),
                    dataStructure: _dataStructure,
                    animationController: _animationController,
                    dataStructureInfo: _dataStructureInfo,
                    onNodeHighlighted: (index) {
                      AppLogger.ui('Node highlighted: $index');
                    },
                    onNodeUpdated: () {
                      setState(() {});
                    },
                  ),
                ),
                // Right panel - Controls and Learning
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        OperationControls(
                          dataStructure: _dataStructure,
                          dataStructureInfo: _dataStructureInfo,
                          onOperationPerformed: () {
                            setState(() {});
                          },
                          onAnimationStateChanged: _onAnimationStateChangedFromControls,
                        ),
                        LearningPanel(
                          dataStructure: _dataStructure,
                          dataStructureInfo: _dataStructureInfo,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      // Animation controls (only show when there are animation steps)
      bottomNavigationBar: hasAnimation
          ? Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress bar
                  Slider(
                    value: currentStep.toDouble(),
                    min: 0,
                    max: (totalSteps - 1).toDouble(),
                    divisions: totalSteps - 1,
                    onChanged: _onSliderChanged,
                  ),
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _dataStructure.isAtStart ? null : _goToPreviousStep,
                        icon: const Icon(Icons.skip_previous),
                        tooltip: 'Previous Step',
                      ),
                      IconButton(
                        onPressed: _togglePlayPause,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        tooltip: _isPlaying ? 'Pause' : 'Play',
                      ),
                      IconButton(
                        onPressed: _dataStructure.isAtEnd ? null : _goToNextStep,
                        icon: const Icon(Icons.skip_next),
                        tooltip: 'Next Step',
                      ),
                      IconButton(
                        onPressed: _resetToDefault,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Reset',
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
} 