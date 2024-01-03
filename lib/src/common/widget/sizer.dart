import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Measure and call callback after child size changed.
class Sizer extends SingleChildRenderObjectWidget {
  const Sizer({
    required super.child,
    this.onSizeChanged,
    this.dispatchNotification = false,
    super.key,
  });

  /// Callback when child size changed and after layout rebuild.
  final void Function(Size size)? onSizeChanged;

  /// Send [SizeChangedLayoutNotification] notification.
  final bool dispatchNotification;

  @override
  RenderObject createRenderObject(BuildContext context) => _SizerRenderObject((size) {
        final fn = onSizeChanged;
        if (fn != null) {
          SchedulerBinding.instance.addPostFrameCallback((_) => fn(size));
        }
        if (dispatchNotification) {
          SizeChangedNotification(size).dispatch(context);
        }
      });
}

/// Render object for [Sizer].
class _SizerRenderObject extends RenderProxyBox {
  _SizerRenderObject(this.onLayoutChangedCallback);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) => super.debugFillProperties(
        properties..add(StringProperty('oldSize', size.toString())),
      );

  /// Callback when child size changed and after layout rebuild.
  final void Function(Size size) onLayoutChangedCallback;

  /// Old size.
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final content = child;
    assert(content is RenderBox, 'Must contain content');
    assert(content?.hasSize ?? false, 'Content must obtain a size');
    final newSize = content?.size;
    if (newSize == null || newSize == _oldSize) return;
    _oldSize = newSize;
    onLayoutChangedCallback(newSize);
  }
}

/// Notification about size changed.
@immutable
class SizeChangedNotification extends SizeChangedLayoutNotification {
  const SizeChangedNotification(this.size);

  /// Current size of nested widget.
  final Size size;
}
