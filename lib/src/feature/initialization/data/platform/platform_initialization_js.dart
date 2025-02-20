// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:web/web.dart';

Future<void> $platformInitialization() async {
  // setUrlStrategy(const HashUrlStrategy());

  // Remove splash screen
  Future<void>.delayed(const Duration(seconds: 1), () {
    // Before running your app:
    // setUrlStrategy(null); // const HashUrlStrategy();
    // setUrlStrategy(NoHistoryUrlStrategy());

    document.getElementById('splash')?.remove();
    document.getElementById('splash-branding')?.remove();
    document.body?.style.background = 'transparent';

    final elements = document.getElementsByClassName('splash-loading');
    for (var i = elements.length - 1; i >= 0; i--) elements.item(i)?.remove();
  });
}

/* class NoHistoryUrlStrategy extends PathUrlStrategy {
  @override
  void pushState(Object? state, String title, String url) => replaceState(state, title, url);
}
*/
