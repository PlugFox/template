import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Pie chart items.
typedef PieChartItems = List<PieChartItem>;

/// Pie chart item.
@immutable
class PieChartItem implements Comparable<PieChartItem> {
  /// Creates a pie chart item.
  const PieChartItem({required this.id, required this.value, required this.color});

  /// Unique identifier of the pie chart section.
  final String id;

  /// Value of the pie chart section.
  final double value;

  /// Color of the pie chart section.
  final Color color;

  /// Creates a copy of this pie chart item with the given fields replaced by the new values.
  PieChartItem copyWith({String? id, double? value, Color? color}) =>
      PieChartItem(id: id ?? this.id, value: value ?? this.value, color: color ?? this.color);

  @override
  int compareTo(PieChartItem other) => value.compareTo(other.value);

  @override
  int get hashCode => value.hashCode ^ color.toARGB32().hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PieChartItem && value == other.value && color.toARGB32() == other.color.toARGB32();

  @override
  String toString() => 'PieChartItem{id: $id, value: $value}';
}

/// Controller for widget PieChart.
final class _PieChartController with ChangeNotifier {
  _PieChartController(PieChartItems items) {
    apply(items)(1);
  }

  /// Linearly interpolate between two doubles.
  static double _lerpDouble(double a, double b, double t) => a * (1.0 - t) + b * t;

  /// Linearly interpolate between two integers.
  /* static double _lerpInt(int a, int b, double t) => a + (b - a) * t; */

  /// Same as [num.clamp] but specialized for non-null [int].
  /* static int _clampInt(int value, int min, int max) {
    if (value < min) {
      return min;
    } else if (value > max) {
      return max;
    } else {
      return value;
    }
  } */

  /// Linearly interpolate between two colors.
  static Color _lerpColor(Color a, Color b, double t) => Color.fromARGB(
    (_lerpDouble(a.a, b.a, t) * 255).clamp(0, 255).toInt(),
    (_lerpDouble(a.r, b.r, t) * 255).clamp(0, 255).toInt(),
    (_lerpDouble(a.g, b.g, t) * 255).clamp(0, 255).toInt(),
    (_lerpDouble(a.b, b.b, t) * 255).clamp(0, 255).toInt(),
  );

  final Map<String, PieChartItem> _from = <String, PieChartItem>{};
  final Map<String, PieChartItem> _to = <String, PieChartItem>{};
  final Map<String, PieChartItem> _current = <String, PieChartItem>{};

  /// Get the current pie chart items.
  List<PieChartItem> get current => UnmodifiableListView<PieChartItem>(_current.values.toList(growable: false)..sort());

  double _total = 0;

  /// Get the total value of the pie chart items.
  double get total => _total;

  double _progress = 0;

  /// Get the progress of the pie chart animation.
  double get progress => _progress;

  /// Set the new target values for the pie chart items.
  /// [items] - new pie chart items.
  ///
  /// Builds the function to animate the pie chart.
  /// The `delta` - progress of the beginning of the animation (0.0) to the end (1.0).
  void Function(double delta) apply(PieChartItems items) {
    final to = <String, PieChartItem>{for (final item in items) item.id: item};
    final ids = <String>{..._from.keys, ..._to.keys, ...to.keys}.toList();

    // Get the value of the pie chart item by its identifier.
    double valueOf(String id) => _lerpDouble(_from[id]?.value ?? .0, _to[id]?.value ?? .0, _progress);

    // Get the color of the pie chart item by its identifier.
    Color colorOf(String id) =>
        _lerpColor(_from[id]?.color ?? Colors.transparent, _to[id]?.color ?? Colors.transparent, _progress);

    // Get the pie chart item by its identifier.
    PieChartItem itemOf(String id) => PieChartItem(id: id, value: valueOf(id), color: colorOf(id));

    {
      _total = .0;
      for (var i = ids.length - 1; i >= 0; i--) {
        final id = ids[i];
        final a = itemOf(id);
        final b = to[id] ?? PieChartItem(id: id, value: 0, color: Colors.transparent);
        if (a.value == b.value && a.value <= .0) {
          // Remove the item if its value is 0 in both the current and target lists.
          ids.removeAt(i);
          _from.remove(id);
          _current.remove(id);
          _to.remove(id);
          continue;
        }
        _from[id] = _current[id] = a;
        _to[id] = b;
        _total += a.value;
      }
      _progress = .0;
    }

    return (double delta) {
      _total = .0;
      _progress = delta;
      for (var i = ids.length - 1; i >= 0; i--) {
        final id = ids[i];
        final item = itemOf(id);
        if (item.value <= .0 && !to.containsKey(id)) {
          // Remove the item if its value is 0 and it is not in the target list.
          // Because the item is not visible, it is not necessary to animate it.
          _from.remove(id);
          _current.remove(id);
          _to.remove(id);
          ids.removeAt(i);
          continue;
        }
        _current[id] = item;
        _total += item.value;
      }
      notifyListeners();
    };
  }
}

/// {@template pie_chart}
/// PieChart widget.
/// {@endtemplate}
class PieChart extends StatefulWidget {
  /// {@macro pie_chart}
  const PieChart.value(
    PieChartItems this.items, {
    this.diameter,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOut,
    this.innerRadius,
    this.gap,
    this.labelFormatter,
    this.onTap,
    this.child,
    super.key,
  }) : listenable = null;

  /// {@macro pie_chart}
  const PieChart.listenable(
    this.listenable, {
    this.diameter,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOut,
    this.innerRadius,
    this.gap,
    this.labelFormatter,
    this.onTap,
    this.child,
    super.key,
  }) : items = null;

  /// Pie chart items.
  final PieChartItems? items;

  /// Controller for the pie chart.
  final ValueListenable<PieChartItems>? listenable;

  /// Duration of the pie chart animation.
  final Duration duration;

  /// Curve for the pie chart animation.
  final Curve curve;

  /// Diameter of the pie chart.
  /// If not specified, the radius will be calculated based on the size of the widget.
  final double? diameter;

  /// Percentage of the inner (empty) radius of the pie chart.
  /// From 0.0 to 1.0. e.g. 0.6
  final double? innerRadius;

  /// Gap between the pie chart sections.
  /// In pixels. e.g. 4.0
  final double? gap;

  /// Formatter for the pie chart section labels.
  final String Function(PieChartItem item, double total)? labelFormatter;

  /// Callback for the pie chart section tap event.
  /// The `item` - the section that was tapped.
  final void Function(PieChartItem item)? onTap;

  /// Child widget at the center of the pie chart.
  final Widget? child;

  @override
  State<PieChart> createState() => _PieChartState();
}

/// State for widget PieChart.
class _PieChartState extends State<PieChart> with SingleTickerProviderStateMixin {
  /// Pie chart target items.
  PieChartItems get items => widget.items ?? widget.listenable?.value ?? const [];

  /// Controller for the pie chart state and animation.
  late final _PieChartController _controller = _PieChartController(items);

  /// Configuration of the pie chart.
  late final ValueNotifier<PieChart> _configuration = ValueNotifier<PieChart>(widget);

  /// Application theme.
  final ValueNotifier<ThemeData> _theme = ValueNotifier<ThemeData>(ThemeData.light());

  /// Painter for the pie chart.
  late final _PieChartPainter _painter = _PieChartPainter(
    controller: _controller,
    configuration: _configuration,
    theme: _theme,
  );

  /// Ticker for the pie chart animation.
  late final Ticker _ticker;

  /// Animate the pie chart data with the given delta.
  void Function(double delta) _animate = (delta) => false;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    widget.listenable?.addListener(_update);
    _ticker = createTicker((duration) {
      if (duration >= widget.duration) {
        _animate(1);
        _ticker.stop();
      } else {
        var delta = (duration.inMilliseconds / widget.duration.inMilliseconds).clamp(.0, 1.0);
        delta = widget.curve.transform(delta);
        if (delta <= .0) return;
        _animate(delta);
        if (delta >= 1) _ticker.stop();
      }
    });
    _update();
  }

  @override
  void didUpdateWidget(covariant PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.listenable, oldWidget.listenable)) {
      oldWidget.listenable?.removeListener(_update);
      widget.listenable?.addListener(_update);
    }
    _configuration.value = widget;
    _update();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme.value = Theme.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    _ticker
      ..stop()
      ..dispose();
    widget.listenable?.removeListener(_update);
    _controller.dispose();
    _configuration.dispose();
    _theme.dispose();
  }
  /* #endregion */

  /// Update the data displayed in the pie chart.
  void _update() {
    if (!mounted) return;
    _animate = _controller.apply(items);
    _ticker
      ..stop()
      ..start().ignore();
  }

  /// Fit the child into a square box.
  static Widget _fit({required Widget child, required double diameter}) => FittedBox(
    alignment: Alignment.center,
    fit: BoxFit.contain,
    clipBehavior: Clip.none,
    child: SizedBox.square(dimension: diameter, child: child),
  );

  @override
  Widget build(BuildContext context) {
    Widget chart = Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTapDown: (details) {
            final onTap = widget.onTap;
            if (onTap == null) return;
            final section = _painter.hitSection(details.localPosition);
            if (section != null) onTap(section);
          },
          child: CustomPaint(painter: _painter, child: widget.child),
        ),
      ),
    );
    if (widget.diameter case double value when value > .0) chart = _fit(child: chart, diameter: value);
    return chart;
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({required this.controller, required this.configuration, required this.theme})
    : super(repaint: Listenable.merge([controller, configuration, theme]));

  /// Controller for the pie chart state and animation.
  final _PieChartController controller;

  /// Configuration of the pie chart.
  final ValueNotifier<PieChart> configuration;

  /// Application theme.
  final ValueNotifier<ThemeData> theme;

  /// List of pie chart sections.
  final List<({PieChartItem item, Path path})> _sections = <({PieChartItem item, Path path})>[];

  /// Last size of the pie chart.
  final Path _innerCircle = Path();

  /// Calculate the contrasting text color for the given background color.
  static Color contrastingTextColor(Color color) {
    final r = (color.toARGB32() >> 16) & 0xFF;
    final g = (color.toARGB32() >> 8) & 0xFF;
    final b = color.toARGB32() & 0xFF;

    final brightness = (299 * r + 587 * g + 114 * b) / 1000;
    return brightness > 128 ? Colors.black : Colors.white;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Get data from the controller, configuration, and theme
    final _PieChartController(:double total, current: List<PieChartItem> sections) = controller;
    final widget = configuration.value;
    final themeData = theme.value;

    // Clear the list of pie chart sections
    _sections.clear();

    // Calculate the pie chart parameters
    final diameter = size.shortestSide;
    final radius = diameter / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final innerRadius = radius * (widget.innerRadius?.clamp(0.0, 1.0) ?? .6); // Inner radius of the pie chart
    _innerCircle
      ..reset()
      ..addOval(Rect.fromCircle(center: center, radius: innerRadius));
    final strokeWidth = radius - innerRadius; // Stroke width of the pie chart sections
    var gap = (widget.gap?.clamp(0, 64) ?? 4) / 2 / radius; // Gap between sections
    var startAngle = -math.pi / 2; // Start from top (12 o'clock position)
    final labelFormatter =
        widget.labelFormatter ?? (item, total) => '${(item.value / total * 100).toStringAsFixed(1)}%';

    // Create a paint object for the pie chart sections
    final paint = Paint();

    if (sections.isEmpty) {
      // Nothing to draw
      return;
    } else if (sections.length == 1) {
      // Draw a single section with a stroke
      final item = sections.single;
      if (item.value <= 0) return;
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = item.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius + strokeWidth / 2),
        0,
        2 * math.pi,
        false,
        paint,
      );

      final outerCircle = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius + strokeWidth));
      final innerCircle = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));
      final path = Path.combine(PathOperation.difference, outerCircle, innerCircle);

      _sections.add((path: path, item: item));
      final text = labelFormatter(item, total);
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: themeData.textTheme.labelMedium?.copyWith(height: 1, color: contrastingTextColor(item.color)),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 1,
      )..layout();
      final textRadius = innerRadius + strokeWidth / 2; // Midpoint of the section
      final sectionCenter = center + Offset(math.cos(startAngle) * textRadius, math.sin(startAngle) * textRadius);
      textPainter.paint(canvas, sectionCenter - Offset(textPainter.width / 2, textPainter.height / 2));
      return;
    }

    // Draw the pie chart sections and labels
    for (final item in sections) {
      final sweepAngle = (item.value / total) * 2 * math.pi - gap;
      if (sweepAngle <= 0) continue;

      paint
        ..style =
            PaintingStyle
                .fill // Fill the section
        ..color = item.color; // Set the color of the section

      // Draw the pie chart section
      var sectionPath =
          Path()
            ..addArc(
              Rect.fromCircle(center: center, radius: innerRadius),
              startAngle + gap / 2, // Move the start angle by half the gap size
              sweepAngle,
            )
            ..lineTo(
              center.dx + math.cos(startAngle + sweepAngle) * radius,
              center.dy + math.sin(startAngle + sweepAngle) * radius,
            )
            ..arcTo(
              Rect.fromCircle(center: center, radius: radius),
              startAngle + sweepAngle - gap / 2, // Move the start angle by half the gap size
              -sweepAngle,
              false,
            )
            ..lineTo(center.dx + math.cos(startAngle) * innerRadius, center.dy + math.sin(startAngle) * innerRadius)
            ..close();

      canvas.drawPath(sectionPath, paint);
      _sections.add((path: sectionPath, item: item));

      // Calculate the position for the text

      //final sectionCenter = sectionPath.getBounds().center;
      final textRadius = innerRadius + strokeWidth / 2; // Midpoint of the section
      final sectionCenter =
          center +
          Offset(
            math.cos(startAngle + sweepAngle / 2) * textRadius,
            math.sin(startAngle + sweepAngle / 2) * textRadius,
          );

      // Draw the text
      final text = labelFormatter(item, total);
      if (text.isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: themeData.textTheme.labelMedium?.copyWith(height: 1, color: contrastingTextColor(item.color)),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          maxLines: 1,
        )..layout();

        // Calculate the available space for the text as the arc length
        final arcLength = innerRadius * sweepAngle;

        // If the text width is less than the available space, draw it
        if (textPainter.width <= arcLength) {
          textPainter.paint(canvas, sectionCenter - Offset(textPainter.width / 2, textPainter.height / 2));
        }
      }

      // Increment the start angle for the next section with the gap size
      startAngle += sweepAngle + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) =>
      !identical(controller, oldDelegate.controller) ||
      !identical(configuration, oldDelegate.configuration) ||
      !identical(theme, oldDelegate.theme);

  @override
  bool shouldRebuildSemantics(covariant _PieChartPainter oldDelegate) => false;

  /// Find the pie chart section that was tapped.
  PieChartItem? hitSection(Offset position) {
    if (_innerCircle.contains(position)) return null;
    for (final section in _sections) {
      if (section.path.contains(position)) {
        return section.item;
      }
    }
    return null;
  }

  @override
  bool? hitTest(Offset position) => hitSection(position) != null;
}
