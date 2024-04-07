import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template output_field}
/// OutputField widget.
/// {@endtemplate}
class OutputTextField<T> extends StatelessWidget {
  /// {@macro output_field}
  const OutputTextField({
    required this.controller,
    required this.output,
    this.enabled = true,
    this.label,
    this.hint,
    this.multiline = false,
    this.expands = false,
    this.floatingLabelBehavior,
    this.focusNode,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.order,
    super.key, // ignore: unused_element
  });

  final ValueListenable<T> controller;
  final String Function(T value) output;
  final bool enabled;
  final String? label;
  final String? hint;
  final bool multiline;
  final bool expands;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? order;

  Widget focusOrder({required Widget child}) {
    if (order case double value) return FocusTraversalOrder(order: NumericFocusOrder(value), child: child);
    return child;
  }

  @override
  Widget build(BuildContext context) => focusOrder(
        child: SizedBox(
          height: 56,
          child: Center(
            child: ValueListenableBuilder<T>(
              valueListenable: controller,
              builder: (context, value, child) {
                final text = output(value);
                return InputDecorator(
                  expands: multiline && expands,
                  isEmpty: text.isEmpty,
                  baseStyle: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    isCollapsed: false,
                    isDense: false,
                    filled: true,
                    floatingLabelBehavior: floatingLabelBehavior,
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                    //hoverColor: colorScheme.surface,
                    labelText: label,
                    hintText: hint,
                    helperText: null,
                    prefixIcon: prefixIcon,
                    prefixIconConstraints: const BoxConstraints.expand(width: 48, height: 48),
                    suffixIcon: suffixIcon,
                    suffixIconConstraints: const BoxConstraints.expand(width: 48, height: 48),
                    counter: const SizedBox.shrink(),
                    errorText: null,
                    helperMaxLines: 0,
                    errorMaxLines: 0,
                  ),
                  child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
                );
              },
            ),
          ),
        ),
      );
}
