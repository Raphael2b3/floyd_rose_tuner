@riverpod
Stream<int> streamExample(Ref ref) async* {
  // Every 1 second, yield a number from 0 to 41.
  // This could be replaced with a Stream from Firestore or GraphQL or anything else.
  for (var i = 0; i < 42; i++) {
    yield i;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}