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

  const DataStructureScreen({super.key, required this.dataStructureType});

  @override
  ConsumerState<DataStructureScreen> createState() =>
      _DataStructureScreenState();
}

class _DataStructureScreenState extends ConsumerState<DataStructureScreen>
    with TickerProviderStateMixin {
  // --- State ---
  late BaseDataStructure _dataStructure;
  late DataStructureInfo _dataStructureInfo;
  late AnimationController _animationController;
  late AnimationService _animationService;
  final GlobalKey<DataStructureCanvasState> _canvasKey =
      GlobalKey<DataStructureCanvasState>();
  bool _isPlaying = false;
  bool _showProgressIndicator = false;
  double _playbackSpeed = 1.0;

  // ================== PUBLIC METHODS (LIFECYCLE, BUILD) ==================
  @override
  void initState() {
    super.initState();
    _dataStructureInfo = DataStructureFactory.getInfo(
      DataStructureFactory.getTypeFromString(widget.dataStructureType),
    );
    _dataStructure = DataStructureFactory.createDataStructure(
      _dataStructureInfo.type,
    );
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
                    appBar: AppBar(title: const Text('Learning Mode')),
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
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
      bottomNavigationBar: _buildAnimationControls(
        hasAnimation,
        currentStep,
        totalSteps,
      ),
    );
  }

  // ================== PRIVATE METHODS (HELPERS, UI BUILDERS, LOGIC) ==================
  // --- Animation/Progress Logic ---
  void _showProgress() {
    AppLogger.ui(
      'Setting _showProgressIndicator = true (showing progress indicator, hiding operations section)',
    );
    setState(() {
      _showProgressIndicator = true;
    });
  }

  void _hideProgress() {
    AppLogger.ui(
      'Setting _showProgressIndicator = false (hiding progress indicator, showing operations section)',
    );
    setState(() {
      _showProgressIndicator = false;
    });
  }

  void _onStepChanged() {
    setState(() {}); // Force rebuild
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

  void _onAnimationStateChangedFromControls(bool isPlaying) {
    if (isPlaying) {
      _animationService.startAnimation(_dataStructure, speed: _playbackSpeed);
    } else {
      _animationService.pauseAnimation();
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _animationService.pauseAnimation();
    } else {
      _animationService.startAnimation(_dataStructure, speed: _playbackSpeed);
    }
  }

  void _goToPreviousStep() {
    setState(() {
      _dataStructure.previousStep();
      _isPlaying = false;
    });
    _scrollToHighlightedNode();
  }

  void _goToNextStep() {
    setState(() {
      _dataStructure.nextStep();
      _isPlaying = false;
    });
    _scrollToHighlightedNode();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _dataStructure.goToStep(value.toInt());
      _isPlaying = false;
    });
    _scrollToHighlightedNode();
  }

  void _resetToDefault() {
    setState(() {
      _isPlaying = false;
      _dataStructure.resetToDefault();
    });
    _hideProgress();
  }

  // --- Highlight/Scroll Logic ---
  void _scrollToHighlightedNode() {
    final nodes = _dataStructure.nodes;
    int nodeToScrollTo = -1;
    for (int j = 0; j < nodes.length; j++) {
      if (nodes[j].color == AppConstants.currentNodeColor) {
        nodeToScrollTo = j;
        break;
      }
    }
    if (nodeToScrollTo == -1) {
      for (int j = 0; j < nodes.length; j++) {
        if (nodes[j].color == AppConstants.foundNodeColor) {
          nodeToScrollTo = j;
          break;
        }
      }
    }
    if (nodeToScrollTo != -1) {
      AppLogger.ui(
        'Scrolling to node $nodeToScrollTo with color ${nodes[nodeToScrollTo].color}',
      );
      _canvasKey.currentState?.scrollToNode(nodeToScrollTo);
    }
  }

  // --- Step Icon/Label Helpers ---
  IconData _getStepIcon(String description) {
    final lower = description.toLowerCase();
    if (lower.contains('search')) return Icons.search;
    if (lower.contains('insert') ||
        lower.contains('push') ||
        lower.contains('enqueue'))
      return Icons.add_circle_outline;
    if (lower.contains('delete') ||
        lower.contains('pop') ||
        lower.contains('dequeue'))
      return Icons.remove_circle_outline;
    if (lower.contains('traverse') || lower.contains('visit'))
      return Icons.list_alt;
    if (lower.contains('found')) return Icons.check_circle_outline;
    if (lower.contains('not found')) return Icons.cancel_outlined;
    if (lower.contains('compare')) return Icons.compare_arrows;
    if (lower.contains('swap')) return Icons.swap_horiz;
    if (lower.contains('move')) return Icons.arrow_forward;
    return Icons.info_outline;
  }

  TextStyle _tableLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      );
  TextStyle _tableValueStyle(BuildContext context) => Theme.of(
    context,
  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600);
  String _getStepAction(String description) {
    final lower = description.toLowerCase();
    if (lower.contains('search')) return 'Search';
    if (lower.contains('insert') ||
        lower.contains('push') ||
        lower.contains('enqueue'))
      return 'Insert';
    if (lower.contains('delete') ||
        lower.contains('pop') ||
        lower.contains('dequeue'))
      return 'Delete';
    if (lower.contains('traverse') || lower.contains('visit'))
      return 'Traverse';
    if (lower.contains('found')) return 'Found';
    if (lower.contains('not found')) return 'Not Found';
    if (lower.contains('compare')) return 'Compare';
    if (lower.contains('swap')) return 'Swap';
    if (lower.contains('move')) return 'Move';
    return 'Info';
  }

  // --- Layout Extraction ---
  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DataStructureCanvas(
            key: _canvasKey,
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
        if (_showProgressIndicator)
          const SizedBox.shrink()
        else
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: OperationControls(
                dataStructure: _dataStructure,
                dataStructureInfo: _dataStructureInfo,
                onOperationPerformed: () {
                  setState(() {});
                },
                onAnimationStateChanged: _onAnimationStateChangedFromControls,
                onShowProgress: _showProgress,
                onHideProgress: _hideProgress,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: DataStructureCanvas(
            key: _canvasKey,
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
        if (_showProgressIndicator)
          const SizedBox.shrink()
        else
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: OperationControls(
                dataStructure: _dataStructure,
                dataStructureInfo: _dataStructureInfo,
                onOperationPerformed: () {
                  setState(() {});
                },
                onAnimationStateChanged: _onAnimationStateChangedFromControls,
                onShowProgress: _showProgress,
                onHideProgress: _hideProgress,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimationControls(
    bool hasAnimation,
    int currentStep,
    int totalSteps,
  ) {
    if (!hasAnimation) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasAnimation && currentStep < totalSteps)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _getStepIcon(
                        _dataStructure.animationSteps[currentStep].description,
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Text('Step:', style: _tableLabelStyle(context)),
                              Text(
                                '${currentStep + 1} of $totalSteps',
                                style: _tableValueStyle(context),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Action:', style: _tableLabelStyle(context)),
                              Text(
                                _getStepAction(
                                  _dataStructure
                                      .animationSteps[currentStep]
                                      .description,
                                ),
                                style: _tableValueStyle(context),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Details:',
                                style: _tableLabelStyle(context),
                              ),
                              Text(
                                _dataStructure
                                    .animationSteps[currentStep]
                                    .description,
                                style: _tableValueStyle(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              Slider(
                value: currentStep.toDouble(),
                min: 0,
                max: (totalSteps - 1).toDouble(),
                divisions: totalSteps > 1 ? totalSteps - 1 : null,
                onChanged: _onSliderChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.speed, size: 18),
                  const SizedBox(width: 8),
                  DropdownButton<double>(
                    value: _playbackSpeed,
                    items: const [
                      DropdownMenuItem(value: 0.5, child: Text('0.5×')),
                      DropdownMenuItem(value: 1.0, child: Text('1×')),
                      DropdownMenuItem(value: 1.5, child: Text('1.5×')),
                      DropdownMenuItem(value: 2.0, child: Text('2×')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _playbackSpeed = value);
                      if (_isPlaying) {
                        _animationService.pauseAnimation();
                        _animationService.startAnimation(
                          _dataStructure,
                          speed: _playbackSpeed,
                        );
                      }
                    },
                  ),
                ],
              ),
              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _dataStructure.isAtStart
                        ? null
                        : _goToPreviousStep,
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
                    icon: const Icon(Icons.close, color: Colors.red),
                    tooltip: 'Reset',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
