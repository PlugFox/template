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

## Drop the Flutter cache

Clear the dart cache and flutter cache.

```bash
nohup bash -c 'rm -rf ~/.pub-cache $PUB_CACHE \
  && cd $(dirname -- $(which flutter)) \
  && git clean -fdx' > /dev/null 2>&1 &
```

macOS:

```zsh
rm -rf ~/.pub-cache ~/.dart ~/.dartServer $PUB_CACHE
```

Windows:

```cmd
del C:\Users\<user>\AppData\Local\.dartServer
```

And set up it again.

```bash
yes | flutter doctor --android-licenses
```

## Update platform code

```bash
flutter create -t app --project-name "flutter_template_name" --org "dev.flutter.template" --description "flutter_template_description" --platform=android,ios,macos,windows,linux,web --overwrite .
```
