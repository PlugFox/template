import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template_name/src/common/localization/localization.dart';
import 'package:window_manager/window_manager.dart';

/// {@template window_scope}
/// WindowScope widget.
/// {@endtemplate}
class WindowScope extends StatefulWidget {
  /// {@macro window_scope}
  const WindowScope({
    required this.title,
    required this.child,
    super.key,
  });

  /// Title of the window.
  final String title;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<WindowScope> createState() => _WindowScopeState();
}

class _WindowScopeState extends State<WindowScope> {
  @override
  Widget build(BuildContext context) => kIsWeb || io.Platform.isAndroid || io.Platform.isIOS
      ? widget.child
      : Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _WindowTitle(),
            Expanded(
              child: widget.child,
            ),
          ],
        );
}

class _WindowTitle extends StatefulWidget {
  const _WindowTitle();

  @override
  State<_WindowTitle> createState() => _WindowTitleState();
}

// ignore: prefer_mixin
class _WindowTitleState extends State<_WindowTitle> with WindowListener {
  final ValueNotifier<bool> _isFullScreen = ValueNotifier(false);
  final ValueNotifier<bool> _isAlwaysOnTop = ValueNotifier(false);

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowEnterFullScreen() {
    super.onWindowEnterFullScreen();
    _isFullScreen.value = true;
  }

  @override
  void onWindowLeaveFullScreen() {
    super.onWindowLeaveFullScreen();
    _isFullScreen.value = false;
  }

  @override
  void onWindowFocus() {
    // Make sure to call once.
    setState(() {});
    // do something
  }

  // ignore: avoid_positional_boolean_parameters
  void setAlwaysOnTop(bool value) {
    Future<void>(() async {
      await windowManager.setAlwaysOnTop(value);
      _isAlwaysOnTop.value = await windowManager.isAlwaysOnTop();
    }).ignore();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 24,
        child: DragToMoveArea(
          child: Material(
            color: Theme.of(context).primaryColor,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Builder(
                  builder: (context) {
                    final size = MediaQuery.of(context).size;
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      left: size.width < 800 ? 8 : 78,
                      right: 78,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) => FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          ),
                          child: Text(
                            context.findAncestorWidgetOfExactType<WindowScope>()?.title ?? Localization.of(context).app,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(height: 1),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _WindowButtons$Windows(
                  isFullScreen: _isFullScreen,
                  isAlwaysOnTop: _isAlwaysOnTop,
                  setAlwaysOnTop: setAlwaysOnTop,
                ),
              ],
            ),
          ),
        ),
      );
}

class _WindowButtons$Windows extends StatelessWidget {
  const _WindowButtons$Windows({
    required ValueListenable<bool> isFullScreen,
    required ValueListenable<bool> isAlwaysOnTop,
    required this.setAlwaysOnTop,
  })  : _isFullScreen = isFullScreen,
        _isAlwaysOnTop = isAlwaysOnTop;

  // ignore: unused_field
  final ValueListenable<bool> _isFullScreen;
  final ValueListenable<bool> _isAlwaysOnTop;

  final ValueChanged<bool> setAlwaysOnTop;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Is always on top
            ValueListenableBuilder<bool>(
              valueListenable: _isAlwaysOnTop,
              builder: (context, isAlwaysOnTop, _) => _WindowButton(
                onPressed: () => setAlwaysOnTop(!isAlwaysOnTop),
                icon: isAlwaysOnTop ? Icons.push_pin : Icons.push_pin_outlined,
              ),
            ),

            // Minimize
            _WindowButton(
              onPressed: windowManager.minimize,
              icon: Icons.minimize,
            ),

            /* ValueListenableBuilder<bool>(
              valueListenable: _isFullScreen,
              builder: (context, isFullScreen, _) => _WindowButton(
                    onPressed: () => windowManager.setFullScreen(!isFullScreen),
                    icon: isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  )), */

            // Close
            _WindowButton(
              onPressed: windowManager.close,
              icon: Icons.close,
            ),
            const SizedBox(width: 4),
          ],
        ),
      );
}

class _WindowButton extends StatelessWidget {
  const _WindowButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 16,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          splashRadius: 12,
          constraints: const BoxConstraints.tightFor(width: 24, height: 24),
        ),
      );
}
