> [!WARNING]
> This project is under active development. The underlying libraries are subject to change.

<div align="center">

#

### **ISOLATED HOST**

<img src="Sticker512.png" width="128"/>

#

</div>

Isolated host infrastructure for dart and flutter.

# <img src="Sticker128.png" width="25" hspace="5" /> Example

### Dart

```dart
Future<void> main() {
  final builder = const AppHostFactory().create()
    ..extend(const ServicesModule())
    ..extend(const ServicesModule());
  return builder.build().run();
}

final class const ServicesModule() extends Module {
  this : super('services');

  @override
  void initialize(ScopeBuilder builder) {
    builder
      ..provide((scope) => MyService())
      ..initialize((scope) => scope.resolve<MyService>()!)
      ..dispose((scope) => scope.resolve<MyService>()!);
  }
}

final class MyService implements Initializeable, Disposable {
  @override
  Future<void>? initialize() {
    print('Service initialized');
    return null;
  }

  @override
  Future<void>? dispose() {
    print('Service disposed');
    return null;
  }
}
```

### Flutter

```dart
Future<void> main() {
  final builder = const FlutterHostFactory().create(
    run: (scope) => scope.wresolve<App>()!,
  );
  builder.wprovide((scope) => const App());
  builder.wprovide((scope) => const HelloPage());
  return builder.build().run();
}

final class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: scope(context).wresolve<HelloPage>()!,
    );
  }
}

final class const HelloPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
```

# <img src="Sticker128.png" width="25" hspace="5" /> License

This project is licensed under the **[MIT](license.md)**.

**© 2026, Falko**
