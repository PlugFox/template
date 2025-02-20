import 'dart:ui' show DisplayFeature, DisplayFeatureState;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// --- Target --- //

/// A link that can be established between a [EnhancedCompositedTransformTarget] and a
/// [EnhancedCompositedTransformFollower].
///
/// The only difference between this and the original [LayerLink] is that this
/// class has a [leaderRenderObject] property that is used to store the render
/// object of the leader.
class EnhancedLayerLink extends LayerLink {
  /// The render object of the leader.
  EnhancedRenderLeaderLayer? leaderRenderObject;

  /// The render object of the follower.
  EnhancedRenderFollowerLayer? followerRenderObject;

  /// Callback that is called when the size of the leader changes.
  void leaderUpdated(Size? size) {
    leaderSize = size;
    followerRenderObject?.leaderUpdated();
  }
}

/// A widget that can be targeted by a [CompositedTransformFollower].
///
/// When this widget is composited during the compositing phase (which comes
/// after the paint phase, as described in [WidgetsBinding.drawFrame]), it
/// updates the [link] object so that any [CompositedTransformFollower] widgets
/// that are subsequently composited in the same frame and were given the same
/// [LayerLink] can position themselves at the same screen location.
///
/// A single [EnhancedCompositedTransformTarget] can be followed by multiple
/// [CompositedTransformFollower] widgets.
///
/// The [EnhancedCompositedTransformTarget] must come earlier in the paint order than
/// any linked [CompositedTransformFollower]s.
///
/// See also:
///
///  * [CompositedTransformFollower], the widget that can target this one.
///  * [LeaderLayer], the layer that implements this widget's logic.
class EnhancedCompositedTransformTarget extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// The [link] property must not be currently used by any other
  /// [EnhancedCompositedTransformTarget] object that is in the tree.
  const EnhancedCompositedTransformTarget({required this.link, super.key, super.child});

  /// The link object that connects this [EnhancedCompositedTransformTarget] with one or
  /// more [CompositedTransformFollower]s.
  ///
  /// The link must not be associated with another [EnhancedCompositedTransformTarget]
  /// that is also being painted.
  final EnhancedLayerLink link;

  @override
  EnhancedRenderLeaderLayer createRenderObject(BuildContext context) => EnhancedRenderLeaderLayer(link: link);

  @override
  void updateRenderObject(BuildContext context, EnhancedRenderLeaderLayer renderObject) {
    renderObject.link = link;
  }
}

/// Provides an anchor for a [RenderFollowerLayer].
///
/// See also:
///
///  * [EnhancedCompositedTransformTarget], the corresponding widget.
///  * [LeaderLayer], the layer that this render object creates.
class EnhancedRenderLeaderLayer extends RenderProxyBox {
  /// Creates a render object that uses a [LeaderLayer].
  EnhancedRenderLeaderLayer({required EnhancedLayerLink link, RenderBox? child}) : _link = link, super(child);

  /// The link object that connects this [EnhancedRenderLeaderLayer] with one or more
  /// [RenderFollowerLayer]s.
  ///
  /// The object must not be associated with another [EnhancedRenderLeaderLayer] that is
  /// also being painted.
  EnhancedLayerLink get link => _link;
  EnhancedLayerLink _link;
  set link(EnhancedLayerLink value) {
    if (_link == value) {
      return;
    }
    _link.leaderUpdated(null);
    _link = value;
    _link.leaderRenderObject = this;
    if (_previousLayoutSize != null) {
      _link.leaderUpdated(_previousLayoutSize);
    }
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  // The latest size of this [RenderBox], computed during the previous layout
  // pass. It should always be equal to [size], but can be accessed even when
  // [debugDoingThisResize] and [debugDoingThisLayout] are false.
  Size? _previousLayoutSize;

  @override
  void performLayout() {
    super.performLayout();
    if (_previousLayoutSize != size) {
      // calculate rect
      link.leaderUpdated(size);
      _previousLayoutSize = size;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final ContainerLayer childLayer;
    switch (layer) {
      case LeaderLayer leaderLayer:
        childLayer =
            leaderLayer
              ..link = link
              ..offset = offset;
      case ContainerLayer containerLayer:
        assert(false, 'This should never happen');
        childLayer = containerLayer;
      case null:
        childLayer = layer = LeaderLayer(link: link, offset: offset);
    }
    context.pushLayer(childLayer, super.paint, Offset.zero);
    assert(() {
      childLayer.debugCreator = debugCreator;
      return true;
    }(), 'Set debugCreator to the LeaderLayer in the paint method of RenderLeaderLayer');
  }

  @override
  void attach(PipelineOwner owner) {
    link.leaderRenderObject = this;
    super.attach(owner);
  }

  @override
  void detach() {
    layer = null;
    link.leaderRenderObject = null;
    _previousLayoutSize = null;
    super.detach();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LayerLink>('link', link));
  }
}

// --- Follower --- //

/// A widget that follows a [CompositedTransformTarget].
///
/// The only difference between this widget and [CompositedTransformFollower] is
/// that this widget prevents the follower from overflowing the screen.
///
/// When this widget is composited during the compositing phase (which comes
/// after the paint phase, as described in [WidgetsBinding.drawFrame]), it
/// applies a transformation that brings [targetAnchor] of the linked
/// [CompositedTransformTarget] and [followerAnchor] of this widget together.
/// The [LayerLink] object used as the [link] must be the same object as that
/// provided to the matching [CompositedTransformTarget].
///
/// The [CompositedTransformTarget] must come earlier in the paint order than
/// this [EnhancedCompositedTransformFollower].
///
/// Hit testing on descendants of this widget will only work if the target
/// position is within the box that this widget's parent considers to be
/// hittable. If the parent covers the screen, this is trivially achievable, so
/// this widget is usually used as the root of an [OverlayEntry] in an app-wide
/// [Overlay] (e.g. as created by the [MaterialApp] widget's [Navigator]).
///
/// See also:
///
///  * [CompositedTransformTarget], the widget that this widget can target.
///  * [FollowerLayer], the layer that implements this widget's logic.
///  * [Transform], which applies an arbitrary transform to a child.
class EnhancedCompositedTransformFollower extends SingleChildRenderObjectWidget {
  /// Creates a composited transform target widget.
  ///
  /// If the [link] property was also provided to a [CompositedTransformTarget],
  /// that widget must come earlier in the paint order.
  ///
  /// The [showWhenUnlinked] argument must not be null.
  const EnhancedCompositedTransformFollower({
    required this.link,
    required this.displayFeatureBounds,
    this.targetAnchor = Alignment.topLeft,
    this.followerAnchor = Alignment.topLeft,
    this.showWhenUnlinked = false,
    this.enforceLeaderWidth = false,
    this.enforceLeaderHeight = false,
    this.flipWhenOverflow = true,
    this.moveWhenOverflow = true,
    super.child,
    super.key,
  });

  /// The link object that connects this [EnhancedCompositedTransformFollower] with a
  /// [CompositedTransformTarget].
  final EnhancedLayerLink link;

  /// Whether to show the widget's contents when there is no corresponding
  /// [CompositedTransformTarget] with the same [link].
  ///
  /// When the widget is linked, the child is positioned such that it has the
  /// same global position as the linked [CompositedTransformTarget].
  ///
  /// When the widget is not linked, then: if [showWhenUnlinked] is true, the
  /// child is visible and not repositioned; if it is false, then child is
  /// hidden.
  final bool showWhenUnlinked;

  /// The anchor point on the linked [CompositedTransformTarget] that
  /// [followerAnchor] will line up with.
  ///
  /// {@template flutter.widgets.CompositedTransformFollower.targetAnchor}
  /// For example, when [targetAnchor] and [followerAnchor] are both
  /// [Alignment.topLeft], this widget will be top left aligned with the linked
  /// [CompositedTransformTarget]. When [targetAnchor] is
  /// [Alignment.bottomLeft] and [followerAnchor] is [Alignment.topLeft], this
  /// widget will be left aligned with the linked [CompositedTransformTarget],
  /// and its top edge will line up with the [CompositedTransformTarget]'s
  /// bottom edge.
  /// {@endtemplate}
  ///
  /// Defaults to [Alignment.topLeft].
  final Alignment targetAnchor;

  /// The anchor point on this widget that will line up with [targetAnchor] on
  /// the linked [CompositedTransformTarget].
  ///
  /// {@macro flutter.widgets.CompositedTransformFollower.targetAnchor}
  ///
  /// Defaults to [Alignment.topLeft].
  final Alignment followerAnchor;

  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on one side and
  /// on the other side there is enough space, the follower widget will be
  /// flipped to the other side.
  ///
  /// Defaults to `true`.
  final bool flipWhenOverflow;

  /// Whether to adjust the position of the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side for 20 pixels,
  /// it will be moved to the left side for 20 pixels, same for the top, bottom, and left sides.
  ///
  /// Defaults to `true`.
  final bool moveWhenOverflow;

  /// Whether to enforce the width of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same width as the leader widget.
  ///
  /// Defaults to `false`.
  final bool enforceLeaderWidth;

  /// Whether to enforce the height of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same height as the leader widget.
  ///
  /// Defaults to `false`.
  final bool enforceLeaderHeight;

  /// List of rects that may be obstructed by physical features.
  final Iterable<Rect> displayFeatureBounds;

  @override
  EnhancedRenderFollowerLayer createRenderObject(BuildContext context) => EnhancedRenderFollowerLayer(
    link: link,
    showWhenUnlinked: showWhenUnlinked,
    leaderAnchor: targetAnchor,
    followerAnchor: followerAnchor,
    enforceLeaderWidth: enforceLeaderWidth,
    enforceLeaderHeight: enforceLeaderHeight,
    flipWhenOverflow: flipWhenOverflow,
    moveWhenOverflow: moveWhenOverflow,
    displayFeatureBounds: displayFeatureBounds,
  );

  @override
  void updateRenderObject(BuildContext context, EnhancedRenderFollowerLayer renderObject) {
    renderObject
      ..link = link
      ..showWhenUnlinked = showWhenUnlinked
      ..leaderAnchor = targetAnchor
      ..followerAnchor = followerAnchor
      ..moveWhenOverflow = moveWhenOverflow
      ..flipWhenOverflow = flipWhenOverflow
      ..enforceLeaderWidth = enforceLeaderWidth
      ..enforceLeaderHeight = enforceLeaderHeight
      ..displayFeatureBounds = displayFeatureBounds;
  }
}

/// Transform the child so that its origin is offset from the origin of the
/// [RenderLeaderLayer] with the same [LayerLink].
///
/// The [RenderLeaderLayer] in question must be earlier in the paint order.
///
/// Hit testing on descendants of this render object will only work if the
/// target position is within the box that this render object's parent considers
/// to be hittable.
///
/// See also:
///
///  * [CompositedTransformFollower], the corresponding widget.
///  * [FollowerLayer], the layer that this render object creates.
class EnhancedRenderFollowerLayer extends RenderProxyBox {
  /// Creates a render object that uses a [FollowerLayer].
  EnhancedRenderFollowerLayer({
    required EnhancedLayerLink link,
    required Iterable<Rect> displayFeatureBounds,
    Alignment leaderAnchor = Alignment.topLeft,
    Alignment followerAnchor = Alignment.topLeft,
    bool showWhenUnlinked = true,
    bool flipWhenOverflow = true,
    bool moveWhenOverflow = true,
    bool enforceLeaderWidth = false,
    bool enforceLeaderHeight = false,
    RenderBox? child,
  }) : _link = link,
       _flipWhenOverflow = flipWhenOverflow,
       _moveWhenOverflow = moveWhenOverflow,
       _showWhenUnlinked = showWhenUnlinked,
       _leaderAnchor = leaderAnchor,
       _followerAnchor = followerAnchor,
       _enforceLeaderWidth = enforceLeaderWidth,
       _enforceLeaderHeight = enforceLeaderHeight,
       _displayFeatureBounds = displayFeatureBounds,
       super(child);

  /// Called when the size of the leader widget changes.
  void leaderUpdated() {
    if (_enforceLeaderHeight || _enforceLeaderWidth) {
      RendererBinding.instance.addPostFrameCallback((_) {
        markNeedsLayout();
      });
    }
  }

  /// List of rects that may be obstructed by physical features.
  Iterable<Rect> get displayFeatureBounds => _displayFeatureBounds;
  Iterable<Rect> _displayFeatureBounds;
  set displayFeatureBounds(Iterable<Rect> value) {
    if (_displayFeatureBounds == value) {
      return;
    }
    _displayFeatureBounds = value;
    markNeedsPaint();
  }

  /// The link object that connects this [EnhancedRenderFollowerLayer] with a
  /// [RenderLeaderLayer] earlier in the paint order.
  EnhancedLayerLink get link => _link;
  EnhancedLayerLink _link;
  set link(EnhancedLayerLink value) {
    if (_link == value) {
      return;
    }
    _link = value;
    markNeedsPaint();
  }

  /// Whether to show the render object's contents when there is no
  /// corresponding [RenderLeaderLayer] with the same [link].
  ///
  /// When the render object is linked, the child is positioned such that it has
  /// the same global position as the linked [RenderLeaderLayer].
  ///
  /// When the render object is not linked, then: if [showWhenUnlinked] is true,
  /// the child is visible and not repositioned; if it is false, then child is
  /// hidden, and its hit testing is also disabled.
  bool get showWhenUnlinked => _showWhenUnlinked;
  bool _showWhenUnlinked;
  set showWhenUnlinked(bool value) {
    if (_showWhenUnlinked == value) {
      return;
    }
    _showWhenUnlinked = value;
    markNeedsPaint();
  }

  /// Whether to adjust the position of the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side for 20 pixels,
  /// it will be moved to the left side for 20 pixels, same for the top, bottom, and left sides.
  ///
  /// Defaults to `true`.
  bool get moveWhenOverflow => _moveWhenOverflow;
  bool _moveWhenOverflow;

  set moveWhenOverflow(bool value) {
    if (_moveWhenOverflow == value) {
      return;
    }
    _moveWhenOverflow = value;
    markNeedsPaint();
  }

  /// The anchor point on the linked [RenderLeaderLayer] that [followerAnchor]
  /// will line up with.
  ///
  /// {@template flutter.rendering.RenderFollowerLayer.leaderAnchor}
  /// For example, when [leaderAnchor] and [followerAnchor] are both
  /// [Alignment.topLeft], this [EnhancedRenderFollowerLayer] will be top left aligned
  /// with the linked [RenderLeaderLayer]. When [leaderAnchor] is
  /// [Alignment.bottomLeft] and [followerAnchor] is [Alignment.topLeft], this
  /// [EnhancedRenderFollowerLayer] will be left aligned with the linked
  /// [RenderLeaderLayer], and its top edge will line up with the
  /// [RenderLeaderLayer]'s bottom edge.
  /// {@endtemplate}
  ///
  /// Defaults to [Alignment.topLeft].
  Alignment get leaderAnchor => _leaderAnchor;
  Alignment _leaderAnchor;
  set leaderAnchor(Alignment value) {
    if (_leaderAnchor == value) {
      return;
    }
    _leaderAnchor = value;
    markNeedsPaint();
  }

  /// The anchor point on this [EnhancedRenderFollowerLayer] that will line up with
  /// [followerAnchor] on the linked [RenderLeaderLayer].
  ///
  /// {@macro flutter.rendering.RenderFollowerLayer.leaderAnchor}
  ///
  /// Defaults to [Alignment.topLeft].
  Alignment get followerAnchor => _followerAnchor;
  Alignment _followerAnchor;
  set followerAnchor(Alignment value) {
    if (_followerAnchor == value) {
      return;
    }
    _followerAnchor = value;
    markNeedsPaint();
  }

  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side,
  /// it will be flipped to the left side.
  ///
  /// Defaults to `true`.
  bool get flipWhenOverflow => _flipWhenOverflow;

  bool _flipWhenOverflow;
  set flipWhenOverflow(bool value) {
    if (_flipWhenOverflow == value) {
      return;
    }
    _flipWhenOverflow = value;
    markNeedsPaint();
  }

  /// Whether to enforce the width of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same width as the leader widget.
  ///
  /// Defaults to `false`.
  bool get enforceLeaderWidth => _enforceLeaderWidth;
  bool _enforceLeaderWidth;
  set enforceLeaderWidth(bool value) {
    if (_enforceLeaderWidth == value) {
      return;
    }
    _enforceLeaderWidth = value;
    markNeedsPaint();
  }

  /// Whether to enforce the height of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same height as the leader widget.
  ///
  /// Defaults to `false`.
  bool get enforceLeaderHeight => _enforceLeaderHeight;
  bool _enforceLeaderHeight;
  set enforceLeaderHeight(bool value) {
    if (_enforceLeaderHeight == value) {
      return;
    }
    _enforceLeaderHeight = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    link.followerRenderObject = this;
    super.attach(owner);
  }

  @override
  void detach() {
    layer = null;
    link.followerRenderObject = null;
    super.detach();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  /// The layer we created when we were last painted.
  @override
  FollowerLayer? get layer => super.layer as FollowerLayer?;

  /// Return the transform that was used in the last composition phase, if any.
  ///
  /// If the [FollowerLayer] has not yet been created, was never composited, or
  /// was unable to determine the transform (see
  /// [FollowerLayer.getLastTransform]), this returns the identity matrix (see
  /// [Matrix4.identity].
  Matrix4 getCurrentTransform() => layer?.getLastTransform() ?? Matrix4.identity();

  @override
  void performLayout() {
    var constraints = this.constraints;
    // use leader size if enforceLeaderWidth or enforceLeaderHeight is true
    final leaderSize = link.leaderSize;

    if (leaderSize != null) {
      if (enforceLeaderWidth) {
        constraints = constraints.copyWith(minWidth: leaderSize.width, maxWidth: leaderSize.width);
      }

      if (enforceLeaderHeight) {
        constraints = constraints.copyWith(minHeight: leaderSize.height, maxHeight: leaderSize.height);
      }
    }

    size = (child!..layout(constraints, parentUsesSize: true)).size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final leaderRenderObject = link.leaderRenderObject;
    var linkedOffset = Offset.zero;

    if (leaderRenderObject != null) {
      final leaderGlobalPosition = leaderRenderObject.localToGlobal(Offset.zero);
      final leaderSize = leaderRenderObject.size;
      final overlayRect = Offset.zero & constraints.biggest;

      final subScreens = DisplayFeatureSubScreen.subScreensInBounds(overlayRect, displayFeatureBounds);

      // TODO(mlazebny): figure out how to correctly treat allowedRect
      // ignore: unused_local_variable
      final allowedRect = _closestScreen(subScreens, leaderGlobalPosition);

      // Where the follower would like to be positioned relative to the leader
      linkedOffset = leaderAnchor.alongSize(leaderSize) - followerAnchor.alongSize(size);
      final followerGlobalPosition = leaderGlobalPosition + linkedOffset;

      linkedOffset =
          calculateLinkedOffset(
            followerRect: followerGlobalPosition & size,
            targetRect: leaderGlobalPosition & leaderSize,
            screenSize: constraints.biggest,
            flipWhenOverflow: flipWhenOverflow,
            moveWhenOverflow: moveWhenOverflow,
          ) -
          leaderGlobalPosition;
    }

    if (layer == null) {
      layer = FollowerLayer(
        link: link,
        showWhenUnlinked: showWhenUnlinked,
        linkedOffset: linkedOffset,
        unlinkedOffset: offset,
      );
    } else {
      layer
        ?..link = link
        ..showWhenUnlinked = showWhenUnlinked
        ..linkedOffset = linkedOffset
        ..unlinkedOffset = offset;
    }

    context.pushLayer(
      layer!,
      super.paint,
      Offset.zero,
      childPaintBounds: const Rect.fromLTRB(
        double.negativeInfinity,
        double.negativeInfinity,
        double.infinity,
        double.infinity,
      ),
    );

    assert(() {
      layer!.debugCreator = debugCreator;
      return true;
    }(), '');
  }

  /// Calculate the offset of the follower widget.
  @visibleForTesting
  static Offset calculateLinkedOffset({
    required Rect followerRect,
    required Rect targetRect,
    required Size screenSize,
    required bool flipWhenOverflow,
    required bool moveWhenOverflow,
  }) {
    // Effective screen area considering edge padding
    const leftBoundary = 0.0;
    const topBoundary = 0.0;
    final rightBoundary = screenSize.width;
    final bottomBoundary = screenSize.height;

    // Helper function to adjust for overflow
    double adjust({
      required double position,
      required double size,
      required double minBoundary,
      required double maxBoundary,
      required double altPosition,
      required double altSize,
    }) {
      var adjustedPosition = position;

      if (flipWhenOverflow) {
        // If `flipWhenOverflow` is true, try placing on the opposite side if there's an overflow
        if (position + size > maxBoundary) {
          if (altPosition - size >= minBoundary) {
            adjustedPosition = altPosition - size;
          } else {
            adjustedPosition = maxBoundary - size;
          }
        } else if (position < minBoundary) {
          if (altPosition + altSize <= maxBoundary) {
            adjustedPosition = altPosition + altSize;
          } else {
            adjustedPosition = minBoundary;
          }
        }
      }

      // Handle moving when overflow
      if (moveWhenOverflow) {
        if (adjustedPosition + size > maxBoundary) {
          adjustedPosition = maxBoundary - size;
        } else if (adjustedPosition < minBoundary) {
          adjustedPosition = minBoundary;
        }
      }

      return adjustedPosition;
    }

    // Adjust horizontal position
    final dx = adjust(
      position: followerRect.left,
      size: followerRect.width,
      minBoundary: leftBoundary,
      maxBoundary: rightBoundary,
      altPosition: targetRect.left,
      altSize: targetRect.width,
    );

    // Adjust vertical position
    final dy = adjust(
      position: followerRect.top,
      size: followerRect.height,
      minBoundary: topBoundary,
      maxBoundary: bottomBoundary,
      altPosition: targetRect.top,
      altSize: targetRect.height,
    );

    return Offset(dx, dy);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(getCurrentTransform());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<LayerLink>('link', link))
      ..add(DiagnosticsProperty<bool>('showWhenUnlinked', showWhenUnlinked))
      ..add(TransformProperty('current transform matrix', getCurrentTransform()));
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Disables the hit testing if this render object is hidden.
    if (link.leader == null && !showWhenUnlinked) {
      return false;
    }
    // RenderFollowerLayer objects don't check if they are
    // themselves hit, because it's confusing to think about
    // how the untransformed size and the child's transformed
    // position interact.
    return hitTestChildren(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) => result.addWithPaintTransform(
    transform: getCurrentTransform(),
    position: position,
    hitTest: (result, position) => super.hitTestChildren(result, position: position),
  );
}

// --- Popup --- //

/// A function that builds a widget with a controller.
typedef PopupWidgetBuilder = Widget Function(BuildContext context, OverlayPortalController controller);

/// {@template popup}
/// A widget that shows a follower widget relative to a target widget.
///
/// Under the hood, it uses [OverlayPortal] that is a declarative version
/// of [OverlayEntry]. In order to position the follower widget relative to
/// the target widget, it uses [CompositedTransformTarget] and
/// [EnhancedCompositedTransformFollower].
///
/// This widget is useful when you want to show a popup, tooltip, or dropdown
/// relative to a target widget. It also automatically manages the position on
/// the screen and ensures that the follower widget is always visible
/// (i.e. it doesn't overflow the screen) by adjusting the position.
/// {@endtemplate}
class PopupBuilder extends StatefulWidget {
  /// Creates a new instance of [PopupBuilder].
  ///
  /// {@macro popup}
  const PopupBuilder({
    required this.followerBuilder,
    required this.targetBuilder,
    this.controller,
    this.followerAnchor = Alignment.topCenter,
    this.targetAnchor = Alignment.bottomCenter,
    this.flipWhenOverflow = true,
    this.moveWhenOverflow = true,
    this.enforceLeaderWidth = false,
    this.enforceLeaderHeight = false,
    super.key,
  });

  /// The target widget that the follower widget [followerBuilder] is positioned relative to.
  final PopupWidgetBuilder targetBuilder;

  /// The widget that is positioned relative to the target widget [targetBuilder].
  final PopupWidgetBuilder followerBuilder;

  /// The alignment of the follower widget relative to the target widget.
  ///
  /// Defaults to [Alignment.topCenter].
  final Alignment followerAnchor;

  /// The alignment of the target widget relative to the follower widget.
  ///
  /// Defaults to [Alignment.bottomCenter].
  final Alignment targetAnchor;

  /// The controller that is used to show/hide the overlay.
  ///
  /// If not provided, a new controller is created.
  final OverlayPortalController? controller;

  /// Whether to flip the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side,
  /// it will be flipped to the left side.
  ///
  /// Defaults to `true`.
  final bool flipWhenOverflow;

  /// Whether to adjust the position of the follower widget when it overflows the screen.
  ///
  /// For example, if the follower widget overflows the screen on the right side for 20 pixels,
  /// it will be moved to the left side for 20 pixels, same for the top, bottom, and left sides.
  ///
  /// Defaults to `true`.
  final bool moveWhenOverflow;

  /// Whether to enforce the width of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same width as the leader widget.
  ///
  /// Defaults to `false`.
  final bool enforceLeaderWidth;

  /// Whether to enforce the height of the leader widget on the follower widget.
  ///
  /// This can be useful to make follower widget be the same height as the leader widget.
  ///
  /// Defaults to `false`.
  final bool enforceLeaderHeight;

  /// Returns the areas of the screen that are obstructed by display features.
  ///
  /// A [DisplayFeature] obstructs the screen when the area it occupies is
  /// not 0 or the `state` is [DisplayFeatureState.postureHalfOpened].
  static Iterable<Rect> findDisplayFeatureBounds(List<DisplayFeature> features) => features
      .where((d) => d.bounds.shortestSide > 0 || d.state == DisplayFeatureState.postureHalfOpened)
      .map((d) => d.bounds);

  @override
  State<PopupBuilder> createState() => _PopupBuilderState();
}

class _PopupBuilderState extends State<PopupBuilder> {
  /// The link between the target widget and the follower widget.
  final _layerLink = EnhancedLayerLink();

  /// The controller that is used to show/hide the overlay.
  late OverlayPortalController portalController;

  @override
  void initState() {
    super.initState();
    portalController = widget.controller ?? OverlayPortalController(debugLabel: 'Popup');
  }

  @override
  void didUpdateWidget(covariant PopupBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.controller, oldWidget.controller)) {
      portalController = widget.controller ?? OverlayPortalController(debugLabel: 'Popup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayFeatureBounds = PopupBuilder.findDisplayFeatureBounds(MediaQuery.displayFeaturesOf(context));

    return EnhancedCompositedTransformTarget(
      link: _layerLink, // link the target widget to the follower widget.
      child: OverlayPortal(
        controller: portalController,
        child: widget.targetBuilder(context, portalController),
        overlayChildBuilder:
            (context) => Center(
              child: EnhancedCompositedTransformFollower(
                link: _layerLink, // link the follower widget to the target widget.
                followerAnchor: widget.followerAnchor,
                targetAnchor: widget.targetAnchor,
                enforceLeaderWidth: widget.enforceLeaderWidth,
                enforceLeaderHeight: widget.enforceLeaderHeight,
                moveWhenOverflow: widget.moveWhenOverflow,
                flipWhenOverflow: widget.flipWhenOverflow,
                displayFeatureBounds: displayFeatureBounds,
                child: widget.followerBuilder(context, portalController),
              ),
            ),
      ),
    );
  }
}

/// Follower builder that wraps the child widget.
typedef PopupFollowerBuilder = Widget Function(BuildContext context, Widget? child);

/// Handles for follower widgets.
abstract interface class PopupFollowerController {
  /// Dismisses the popup.
  void dismiss();
}

/// {@template popup_follower}
/// A widget that adds additional functionality to the child widget.
///
/// It listens for the escape key and dismisses the popup when pressed.
/// It also listens for the tap outside the child widget and dismisses the popup.
/// {@endtemplate}
class PopupFollower extends StatefulWidget {
  /// Creates a new instance of [PopupFollower].
  ///
  /// {@macro popup_follower}
  const PopupFollower({
    required this.child,
    this.onDismiss,
    this.tapRegionGroupId,
    this.focusScopeNode,
    this.skipTraversal,
    this.consumeOutsideTaps = false,
    this.dismissOnResize = false,
    this.dismissOnScroll = true,
    this.constraints = const BoxConstraints(),
    this.autofocus = true,
    super.key,
  });

  /// The child widget that is wrapped.
  final Widget child;

  /// The callback that is called when the popup is dismissed.
  ///
  /// If this callback is not provided, the popup will not be dismissible.
  final VoidCallback? onDismiss;

  /// Follower constraints, if any.
  final BoxConstraints constraints;

  /// The group id of the [TapRegion].
  ///
  /// Refers to the [TapRegion.groupId].
  final Object? tapRegionGroupId;

  /// Whether to consume the outside taps.
  ///
  /// Refers to the [TapRegion.consumeOutsideTaps].
  final bool consumeOutsideTaps;

  /// Whether to dismiss the popup when the window is resized.
  final bool dismissOnResize;

  /// Whether to dismiss the popup when the scroll occurs.
  final bool dismissOnScroll;

  /// Whether the focus should be set to the child widget.
  final bool autofocus;

  /// The focus scope node.
  final FocusScopeNode? focusScopeNode;

  /// Whether to skip the focus traversal.
  final bool? skipTraversal;

  @override
  State<PopupFollower> createState() => _PopupFollowerState();
}

class _PopupFollowerState extends State<PopupFollower> with WidgetsBindingObserver implements PopupFollowerController {
  _FollowerScope? _parent;
  ScrollPosition? _scrollPosition;

  /// Whether the current widget is the root widget.
  bool get isRoot => _parent == null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    _scrollPosition?.removeListener(_scrollableListener);
    _scrollPosition = Scrollable.maybeOf(context)?.position?..addListener(_scrollableListener);
    _parent = _FollowerScope.maybeOf(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void didChangeMetrics() {
    if (widget.dismissOnResize) {
      widget.onDismiss?.call();
    }
    super.didChangeMetrics();
  }

  void _scrollableListener() {
    if (widget.onDismiss != null && widget.dismissOnScroll && isRoot) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dismiss() {
    if (widget.onDismiss != null && isRoot) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollPosition?.removeListener(_scrollableListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FollowerScope(
    controller: this,
    parent: _parent,
    child: Actions(
      actions: {DismissIntent: CallbackAction<DismissIntent>(onInvoke: (intent) => widget.onDismiss?.call())},
      child: Shortcuts(
        debugLabel: 'PopupFollower',
        shortcuts: {LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent()},
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: FocusScope(
            debugLabel: 'PopupFollower',
            node: widget.focusScopeNode,
            skipTraversal: widget.skipTraversal,
            canRequestFocus: true,
            child: TapRegion(
              debugLabel: 'PopupFollower',
              groupId: widget.tapRegionGroupId,
              consumeOutsideTaps: widget.consumeOutsideTaps,
              onTapOutside: (_) => widget.onDismiss?.call(),
              child: ConstrainedBox(constraints: widget.constraints, child: widget.child),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Follower Scope
class _FollowerScope extends InheritedWidget {
  /// Creates a new instance of [_FollowerScope].
  const _FollowerScope({
    required super.child,
    required this.controller,
    this.parent,
    super.key, // ignore: unused_element_parameter
  });

  /// The controller that is used to dismiss the popup.
  final PopupFollowerController controller;

  /// The parent [_FollowerScope] instance.
  final _FollowerScope? parent;

  /// Returns the closest [_FollowerScope] instance.
  static _FollowerScope? maybeOf(BuildContext context, {bool listen = false}) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<_FollowerScope>()
          : context.getElementForInheritedWidgetOfExactType<_FollowerScope>()?.widget as _FollowerScope?;

  @override
  bool updateShouldNotify(_FollowerScope oldWidget) => false;
}
