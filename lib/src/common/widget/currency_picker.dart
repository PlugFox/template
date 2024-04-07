import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/widget/input_text_field.dart';
import 'package:money2/money2.dart';

/// {@template currency_picker}
/// CurrencyPicker widget.
/// {@endtemplate}
class CurrencyPicker extends StatelessWidget {
  /// {@macro currency_picker}
  const CurrencyPicker({
    required this.label,
    required this.controller,
    this.initialValue,
    this.hint,
    this.suggestionsLimit = 10,
    this.order,
    this.textInputAction,
    this.floatingLabelBehavior,
    this.prefixIcon,
    this.filter,
    super.key, // ignore: unused_element
  });

  final TextEditingValue? initialValue;
  final String label;
  final String? hint;
  final int suggestionsLimit;
  final double? order;
  final TextInputAction? textInputAction;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Widget? prefixIcon;
  final ValueNotifier<Currency> controller;
  final bool Function(Currency currency)? filter;

  static String? _lastSearchText;
  Future<List<Currency>> optionsBuilder(BuildContext context, TextEditingValue value) async {
    final text = _lastSearchText = value.text.trim().toLowerCase();
    final currencies = CommonCurrencies().asList();
    final where = filter?.call ?? (_) => true;
    if (text.isEmpty) return currencies.where(where).take(suggestionsLimit).toList(growable: false);
    final result = <Currency>[];
    final stopwatch = Stopwatch()..start();
    try {
      for (final c in currencies) {
        final Currency(:name, :code, :symbol, :country, :unit) = c;
        final contains = name.toLowerCase().contains(text) ||
            code.toLowerCase().contains(text) ||
            symbol.toLowerCase().contains(text) ||
            country.toLowerCase().contains(text) ||
            unit.toLowerCase().contains(text);
        if (contains && where(c)) result.add(c);
        if (result.length >= suggestionsLimit) break;
        if (stopwatch.elapsedMilliseconds > 8) {
          await Future<void>.delayed(Duration.zero);
          if (text != _lastSearchText) break;
          stopwatch.reset();
        }
      }
    } finally {
      stopwatch.stop();
    }
    return result;
  }

  Widget focusOrder({required Widget child}) {
    if (order case double value) return FocusTraversalOrder(order: NumericFocusOrder(value), child: child);
    return child;
  }

  @override
  Widget build(BuildContext context) => focusOrder(
        child: SizedBox(
          height: 56,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Autocomplete<Currency>(
                initialValue: initialValue ?? TextEditingValue(text: controller.value.name),
                optionsBuilder: (textEditingValue) => optionsBuilder(context, textEditingValue),
                displayStringForOption: (option) => option.name,
                onSelected: (value) => controller.value = value,
                optionsViewBuilder: (context, onSelected, options) => Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    height: math.min(options.length * 48.0, 5 * 48.0),
                    width: 320,
                    child: Material(
                      elevation: 4,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemExtent: 48,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) => InputTextField(
                  controller: textController,
                  focusNode: focusNode,
                  expands: false,
                  keyboardType: TextInputType.text,
                  //autofillHints: const <String>[AutofillHints.currencyName],
                  autocorrect: true,
                  textInputAction: textInputAction,
                  label: label,
                  hint: hint,
                  floatingLabelBehavior: floatingLabelBehavior,
                  prefixIcon: prefixIcon,
                  suffixIcon: ValueListenableBuilder<Currency?>(
                    valueListenable: controller,
                    builder: (context, value, child) => IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: value == null
                          ? null
                          : () {
                              //controller.value = CommonCurrencies().usd;
                              textController.clear();
                            },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
