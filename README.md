# todo_app

A new Flutter project just for learning

## Deps:

### Go Router

- see app/core/routes.dart and app/core/go_router_observer.dart
  
### Flutter localizations
 `flutter pub add flutter_localizations --sdk=flutter`

 - Need to add Localization delegates in the MaterialApp:
  ```
  localizationsDelegates: const [
    ...GlobalMaterialLocalizations.delegates,
    GlobalMaterialLocalizations.delegate
  ],
```

### Adaptative Scaffold
  `flutter pub add flutter_adaptive_scaffold`
  
## Some commands




### Golden test

- Updating or generating golden tests:

  `flutter test --update-goldens`

- Using local file system fonts
  1. Crete `flutter_test_config.dart` in the test folder. This file will be executed before all tests
  2. Add `platform` and `file` to the dev dependencies:
    `flutter pub add dev:file` & `flutter pub add dev:platform`
  3. Use the instructions on `matchesGoldenFile` matcher method doc to add the code to load fonts. (see `/test/flutter_test_config.dart`)

- For golden tests we can also use **[Alchemist](https://pub.dev/packages/alchemist)** framework

### Integration tests

- We need to add the integration_test lines to dev dependencies (like flutter_test):
  ```
    integration_test:
    sdk: flutter

  ```
 