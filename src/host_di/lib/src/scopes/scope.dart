abstract class Scope {
  T? resolve<T>({String? key});
  Iterable<T> iterate<T>({String? key});
}
