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
Future<void>? main() {
  final builder = const FlutterHostFactory().create(
    run: (scope) => scope.resolve(key: 'initial')!,
  );

  builder.provide((scope) => 'Incrementer', key: 'title');

  builder.wprovide((scope) => const IncrementerApp());
  builder.provide((scope) => scope.wresolve<IncrementerApp>()!, key: 'initial');

  builder.wprovide((scope) => const IncrementPage());
  builder.provide((scope) => IncrementNotifier());

  return builder.build().run();
}

final class const IncrementerApp({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: scope(context).resolve(key: 'title')!,
      home: scope(context).wresolve<IncrementPage>()!,
    );
  }
}

final class const IncrementPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final incrementer = scope(context).resolve<IncrementNotifier>()!;
    return Scaffold(
      appBar: AppBar(title: Text(scope(context).resolve(key: 'title')!)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            ValueListenableBuilder(
              valueListenable: incrementer,
              builder: (context, value, child) => Text(
                '$value',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementer.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

final class IncrementNotifier() extends ValueNotifier<int> {
  this : super(0);

  void increment() => value++;
}
```

# <img src="Sticker128.png" width="25" hspace="5" /> License

This project is licensed under the **[MIT](license.md)**.

**© 2026, Falko**
