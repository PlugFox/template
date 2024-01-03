import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/widget/shimmer.dart';

/// {@template text_placeholder}
/// TextPlaceholder widget.
/// {@endtemplate}
class TextPlaceholder extends StatelessWidget {
  /// {@macro text_placeholder}
  TextPlaceholder({
    double width = double.infinity,
    double height = 28,
    super.key,
  }) : size = Size(width, height);

  /// Size of the placeholder
  final Size size;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Shimmer(
          size: Size(
            math.min(size.width, constraints.maxWidth - 16),
            size.height,
          ),
          color: Colors.grey[400],
          backgroundColor: Colors.grey[100],
        ),
      );
}
