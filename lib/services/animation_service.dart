import 'dart:async';
import 'package:flutter/material.dart';
import '../models/base_data_structure.dart';
import '../utils/logger.dart';
import '../utils/constants.dart';

class AnimationService {
  Timer? _animationTimer;
  bool _isPlaying = false;
  final VoidCallback? onStepChanged;
  final VoidCallback? onAnimationComplete;
  final VoidCallback? onAnimationStateChanged;

  AnimationService({
    this.onStepChanged,
    this.onAnimationComplete,
    this.onAnimationStateChanged,
  });

  bool get isPlaying => _isPlaying;

  void startAnimation(BaseDataStructure dataStructure) {
    if (dataStructure.animationSteps.isEmpty) {
      AppLogger.warning('No animation steps available');
      return;
    }

    _isPlaying = true;
    onAnimationStateChanged?.call();
    
    _animationTimer = Timer.periodic(AppConstants.animationDuration, (timer) {
      _onTick(dataStructure);
    });
    
    AppLogger.animation('Animation started');
  }

  void pauseAnimation() {
    _isPlaying = false;
    _animationTimer?.cancel();
    onAnimationStateChanged?.call();
    AppLogger.animation('Animation paused');
  }

  void stopAnimation() {
    _isPlaying = false;
    _animationTimer?.cancel();
    onAnimationStateChanged?.call();
    AppLogger.animation('Animation stopped');
  }

  void _onTick(BaseDataStructure dataStructure) {
    if (!_isPlaying || dataStructure.animationSteps.isEmpty) {
      stopAnimation();
      return;
    }

    if (dataStructure.currentStep < dataStructure.animationSteps.length - 1) {
      dataStructure.nextStep();
      onStepChanged?.call();
    } else {
      stopAnimation();
      onAnimationComplete?.call();
    }
  }

  void dispose() {
    _animationTimer?.cancel();
  }
} 