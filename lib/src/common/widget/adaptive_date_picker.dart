import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/util/date_util.dart';
import 'package:intl/intl.dart';

/// {@template adaptive_date_picker}
/// AdaptiveDatePicker widget.
/// {@endtemplate}
class AdaptiveDatePicker extends StatelessWidget {
  /// {@macro adaptive_date_picker}
  const AdaptiveDatePicker({
    required this.label,
    required this.controller,
    this.hint,
    this.isRequired = false,
    this.floatingLabelBehavior,
    this.order,
    super.key, // ignore: unused_element
  });

  final String label;
  final String? hint;
  final bool isRequired;
  final double? order;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final ValueNotifier<DateTime?> controller;

  Widget focusOrder({required Widget child}) {
    if (order case double value) return FocusTraversalOrder(order: NumericFocusOrder(value), child: child);
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return focusOrder(
      child: SizedBox(
        height: 56,
        child: Center(
          child: GestureDetector(
            onTap: () => showDatePicker(
              context: context,
              initialDate: controller.value ?? now,
              firstDate: now.subtract(const Duration(days: 365 * 100)),
              lastDate: now.add(const Duration(days: 365 * 100)),
            ).then<void>((value) => controller.value = value ?? controller.value),
            child: InputDecorator(
              decoration: InputDecoration(
                isCollapsed: false,
                isDense: false,
                filled: true,
                labelText: label,
                hintText: hint,
                helperText: null,
                floatingLabelBehavior: floatingLabelBehavior,
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                prefixIcon: const Icon(Icons.calendar_today),
                prefixIconConstraints: const BoxConstraints.expand(width: 48, height: 48),
                suffixIcon: isRequired
                    ? null
                    : ValueListenableBuilder<DateTime?>(
                        valueListenable: controller,
                        builder: (context, value, child) => IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: value == null ? null : () => controller.value = null,
                        ),
                      ),
                suffixIconConstraints: const BoxConstraints.expand(width: 48, height: 48),
                counter: const SizedBox.shrink(),
                errorText: null,
                helperMaxLines: 0,
                errorMaxLines: 0,
              ),
              child: ValueListenableBuilder<DateTime?>(
                valueListenable: controller,
                builder: (context, value, child) => Text(
                  value?.format(format: DateFormat.yMMMd()) ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
