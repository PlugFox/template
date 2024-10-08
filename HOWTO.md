# How to...

## Initialize the Firebase

```bash
npm install -g firebase-tools
firebase login
firebase init
dart pub global activate flutterfire_cli
flutterfire configure \
	-i tld.domain.app \
	-m tld.domain.app \
	-a tld.domain.app \
	-p project \
	-e email@gmail.com \
	-o lib/src/common/constant/firebase_options.g.dart
```
