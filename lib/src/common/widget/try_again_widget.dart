import 'package:flutter/material.dart';

/// {@template try_again_widget}
/// TryAgainWidget widget.
/// {@endtemplate}
class TryAgainWidget extends StatelessWidget {
  /// {@macro try_again_widget}
  const TryAgainWidget(this.tryAgain, {super.key});

  /// Try again callback
  final void Function(BuildContext context) tryAgain;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Center(
          child: IconButton.filledTonal(
            onPressed: () => tryAgain(context),
            iconSize: switch (constraints.biggest.shortestSide) {
              > 128 => 128,
              > 64 => 64,
              > 48 => 48,
              > 32 => 32,
              > 24 => 24,
              _ => constraints.biggest.shortestSide,
            },
            padding: switch (constraints.biggest.shortestSide) {
              > 96 => const EdgeInsets.all(16),
              > 64 => const EdgeInsets.all(8),
              > 40 => const EdgeInsets.all(4),
              _ => EdgeInsets.zero,
            },
            tooltip: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
            color: Theme.of(context).colorScheme.error,
            icon: const Icon(Icons.refresh),
          ),
        ),
      );
}
