import 'package:flutter/material.dart';
import 'package:host_flutter/host_flutter.dart';

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
