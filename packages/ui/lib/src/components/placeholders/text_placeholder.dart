import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ui/src/components/placeholders/shimmer.dart';

/// {@template text_placeholder}
/// TextPlaceholder widget.
/// {@endtemplate}
class TextPlaceholder extends StatelessWidget {
  /// {@macro text_placeholder}
  const TextPlaceholder({
    this.width = double.infinity,
    this.height = 28,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  /// Size of the placeholder
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: LayoutBuilder(
      builder:
          (context, constraints) => Shimmer(
            alignment: Alignment.centerLeft,
            size: Size(math.min(width, constraints.maxWidth), height),
            color: Colors.grey[400],
            backgroundColor: Colors.grey[100],
          ),
    ),
  );
}
