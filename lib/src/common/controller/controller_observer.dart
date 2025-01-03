import 'package:control/control.dart';
import 'package:l/l.dart';

/// Observer for [Controller], react to changes in the any controller.
class ControllerObserver implements IControllerObserver {
  const ControllerObserver();

  @override
  void onCreate(Controller controller) {
    l.v6('Control | ${controller.name}.new');
  }

  @override
  void onDispose(Controller controller) {
    l.v5('Control | ${controller.name}.dispose');
  }

  @override
  void onHandler(HandlerContext context) {
    l.d(
      'Control | ' '${context.controller.name}.${context.name}',
      context.meta,
    );
  }

  @override
  void onStateChanged<S extends Object>(
    StateController<S> controller,
    S prevState,
    S nextState,
  ) {
    final context = Controller.context;
    if (context == null) {
      // State change occurred outside of the handler
      l.d(
        'Control | '
        '${controller.name} | '
        '$prevState -> $nextState',
      );
    } else {
      // State change occurred inside the handler
      l.d(
        'Control | '
        '${controller.name}.${context.name} | '
        '$prevState -> $nextState',
        context.meta,
      );
    }
  }

  @override
  void onError(Controller controller, Object error, StackTrace stackTrace) {
    final context = Controller.context;
    if (context == null) {
      // Error occurred outside of the handler
      l.w(
        'Control | '
        '${controller.name} | '
        '$error',
        stackTrace,
      );
    } else {
      // Error occurred inside the handler
      l.w(
        'Control | '
        '${controller.name}.${context.name} | '
        '$error',
        stackTrace,
        context.meta,
      );
    }
  }
}
