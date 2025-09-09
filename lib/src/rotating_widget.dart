// ignore_for_file: comment_references

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// A widget that can rotate in 3D space based on user interaction.
class RotatingWidget extends StatefulWidget {
  /// Creates a rotatable widget.
  const RotatingWidget({
    required this.child,
    super.key,
    this.isInitialRotate = false,

    /// Maximum rotation angle as a percentage of full rotation (0.15 = 15%).
    /// Defines the range within which the widget can rotate.
    /// Defaults to 0.15.
    /// Must not exceed 1.0 (100%).
    this.rotationPercentage = 0.15,
    this.isReturnedStartPosition = true,
    // ! add NSMotionUsageDescription in iOS
    this.gyroscopeRotate = false,
    this.isToTouchableRotate = false,
  }) : assert(
         rotationPercentage <= 1.0,
         'rotationPercentage must not exceed 1.0 (100%)',
       );

  /// The widget that will be rotated.
  final Widget child;

  /// Whether the widget should rotate after initialization.
  /// If set to true, the widget will perform a small rotation on startup
  /// to show the user that it can be rotated. Defaults to false.
  final bool isInitialRotate;

  /// Maximum rotation angle as a percentage of full rotation (0.15 = 15%).
  /// Defines the range within which the widget can rotate.
  /// Defaults to 0.15.
  final double rotationPercentage;

  /// Whether the widget should
  /// return to its initial position after the gesture ends.
  /// If true, the widget will smoothly return to the starting position
  /// after the gesture is completed. Defaults to true.
  final bool isReturnedStartPosition;

  /// Whether the widget should rotate based on device tilt.
  /// If true, the widget will rotate based on the device's gyroscope data.
  /// Defaults to false.
  final bool gyroscopeRotate;

  /// Whether the widget can be rotated by touch.
  /// If true, the widget will rotate when touched and dragged.
  /// Defaults to false.
  final bool isToTouchableRotate;

  @override
  State<RotatingWidget> createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget> {
  double rotationX = 0; // Current rotation angle on X axis
  double rotationY = 0; // Current rotation angle on Y axis
  double targetRotationX = 0; // Target rotation angle on X axis
  double targetRotationY = 0; // Target rotation angle on Y axis

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  Timer? _initialRotationTimer1;
  Timer? _initialRotationTimer2;

  @override
  void initState() {
    super.initState();

    // Start initial rotation animation if enabled
    if (widget.isInitialRotate) {
      _performInitialRotation();
    }

    // Subscribe to gyroscope data if gyroscope rotation is enabled
    if (widget.gyroscopeRotate) {
      _gyroscopeSubscription = gyroscopeEventStream().listen((
        GyroscopeEvent event,
      ) {
        if (mounted) {
          setState(() {
            targetRotationX = (targetRotationX + event.x * 0.1).clamp(
              -widget.rotationPercentage,
              widget.rotationPercentage,
            );
            targetRotationY = (targetRotationY + event.y * 0.1).clamp(
              -widget.rotationPercentage,
              widget.rotationPercentage,
            );
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    _initialRotationTimer1?.cancel();
    _initialRotationTimer2?.cancel();
    super.dispose();
  }

  /// Starts the initial rotation animation to show the user
  /// that the widget can be rotated.
  void _performInitialRotation() {
    _initialRotationTimer1 = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          targetRotationX = widget.rotationPercentage / 2;
          targetRotationY = -widget.rotationPercentage / 2;
        });
      }
    });

    // Return the widget to its initial position after 800ms
    _initialRotationTimer2 = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          targetRotationX = 0;
          targetRotationY = 0;
        });
      }
    });
  }

  /// Updates the widget's rotation angle when dragging on the screen.
  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isToTouchableRotate) {
      setState(() {
        targetRotationY = (targetRotationY + details.delta.dx * 0.01).clamp(
          -widget.rotationPercentage,
          widget.rotationPercentage,
        );
        targetRotationX = (targetRotationX - details.delta.dy * 0.01).clamp(
          -widget.rotationPercentage,
          widget.rotationPercentage,
        );
      });
    }
  }

  /// Ends the rotation and returns the widget to its initial position
  /// if [isReturnedStartPosition] parameter is set to true.
  void _onPanEnd(DragEndDetails details) {
    if (widget.isReturnedStartPosition) {
      setState(() {
        targetRotationX = 0;
        targetRotationY = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: TweenAnimationBuilder(
        tween: Tween(begin: rotationX, end: targetRotationX),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        builder: (context, double x, child) {
          rotationX = x;
          return TweenAnimationBuilder(
            tween: Tween(begin: rotationY, end: targetRotationY),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, double y, child) {
              rotationY = y;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(
                    3,
                    2,
                    0.001,
                  ) // Perspective projection for 3D effect
                  ..rotateX(rotationX)
                  ..rotateY(rotationY),
                alignment: FractionalOffset.center,
                child: widget.child,
              );
            },
          );
        },
      ),
    );
  }
}
