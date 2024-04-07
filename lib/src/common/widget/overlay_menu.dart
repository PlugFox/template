import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/router/routes.dart';
import 'package:octopus/octopus.dart';

/// {@template overlay_menu}
/// OverlayMenu widget.
/// {@endtemplate}
class OverlayMenu extends StatefulWidget {
  /// {@macro overlay_menu}
  const OverlayMenu({
    required this.child,
    this.navigator = true,
    super.key, // ignore: unused_element
  });

  /// Add additional navigator (for modal dialogs) to the widget tree.
  final bool navigator;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<OverlayMenu> createState() => _OverlayMenuState();
}

/// State for widget OverlayMenu.
class _OverlayMenuState extends State<OverlayMenu> with SingleTickerProviderStateMixin, _PanelController {
  late final FlowDelegate _overlayDelegate;

  @override
  void initState() {
    super.initState();
    _overlayDelegate = _OverlayMenuFlowDelegate(animation: _panelAnimationController);
    // implement right panel
  }

  Widget addNavigator(Widget child) => widget.navigator
      ? Navigator(
          reportsRouteUpdateToEngine: false,
          pages: <Page<Object?>>[MaterialPage<void>(child: child)],
          onPopPage: (route, result) => route.didPop(result),
        )
      : child;

  @override
  Widget build(BuildContext context) => _InheritedOverlayMenu(
        scope: this,
        child: addNavigator(
          Flow(
            delegate: _overlayDelegate,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              const _MenuRail(),
              widget.child,
              /* ValueListenableBuilder<Widget?>(
                valueListenable: _panelNotifier,
                builder: (context, panel, _) => panel ?? const Offstage(),
              ), */
            ],
          ),
        ),
      );
}

mixin _PanelController on State<OverlayMenu>, SingleTickerProviderStateMixin<OverlayMenu> {
  late final AnimationController _panelAnimationController;
  final ValueNotifier<Widget?> _panelNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _panelAnimationController.dispose();
    _panelNotifier.dispose();
    super.dispose();
  }

  Future<void> showPanel(Widget panel) async {
    await hidePanel();
    _panelNotifier.value = panel;
    await _panelAnimationController.forward().catchError((_, __) {});
  }

  Future<void> hidePanel() async {
    if (_panelAnimationController.isDismissed && _panelNotifier.value == null) return;
    await _panelAnimationController.reverse().catchError((_, __) {});
    _panelNotifier.value = null;
  }
}

class _InheritedOverlayMenu extends InheritedWidget {
  const _InheritedOverlayMenu({
    required this.scope,
    required super.child,
    super.key, // ignore: unused_element
  });

  final _OverlayMenuState scope;

  @override
  bool updateShouldNotify(covariant _InheritedOverlayMenu oldWidget) => false;
}

class _OverlayMenuFlowDelegate extends FlowDelegate {
  _OverlayMenuFlowDelegate({this.animation}) : super(repaint: animation);

  static const double railWidth = 72;

  final Animation<double>? animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    context
      ..paintChild(0, transform: Matrix4.translationValues(0, 0, 0))
      ..paintChild(1, transform: Matrix4.translationValues(railWidth, 0, 0));
    //..paintChild(2, transform: Matrix4.translationValues(railWidth, 0, 0));
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) => switch (i) {
        0 => BoxConstraints.tightFor(width: railWidth, height: constraints.maxHeight),
        1 => BoxConstraints.tightFor(width: constraints.maxWidth - railWidth, height: constraints.maxHeight),
        2 => BoxConstraints.tightFor(width: constraints.maxWidth - railWidth, height: constraints.maxHeight),
        _ => throw Exception('Invalid index: $i'),
      };

  @override
  bool shouldRepaint(covariant _OverlayMenuFlowDelegate oldDelegate) => !identical(oldDelegate.animation, animation);
}

class _MenuRail extends StatelessWidget {
  const _MenuRail({
    super.key, // ignore: unused_element
  });

  static final List<({String name, NavigationRailDestination destination})> _destinations = [
    (
      name: Routes.home.name,
      destination: const NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
    ),
    (
      name: Routes.profile.name,
      destination: const NavigationRailDestination(icon: Icon(Icons.business), label: Text('Profile')),
    ),
    (
      name: Routes.settings.name,
      destination: const NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
    ),
  ];

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: _OverlayMenuFlowDelegate.railWidth,
          child: ValueListenableBuilder(
            valueListenable: Octopus.instance.observer,
            builder: (context, state, _) {
              final currentName = state.children.last.name;
              int? currentIdx = _destinations.indexWhere((element) => element.name == currentName);
              if (currentIdx == -1) currentIdx = null;
              return NavigationRail(
                selectedIndex: currentIdx,
                destinations: _destinations.map((e) => e.destination).toList(growable: false),
                onDestinationSelected: (index) {
                  if (index == currentIdx) return;
                  if (index == 0) {
                    Octopus.instance
                        .setState((state) => state..removeWhere((element) => element.name != Routes.home.name));
                  } else {
                    final destination = _destinations[index];
                    Octopus.instance.setState((state) {
                      state.removeWhere(
                          (element) => element.name != destination.name && element.name != Routes.home.name);
                      if (state.children.none((element) => element.name == destination.name))
                        state.add(OctopusNode.mutable(destination.name));
                      return state;
                    });
                  }
                },
                extended: false,
                minWidth: _OverlayMenuFlowDelegate.railWidth,
              );
            },
          ),
        ),
      );
}
