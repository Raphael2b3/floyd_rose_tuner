import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_log_provider.g.dart';

@riverpod
class ErrorLogNotifier extends _$ErrorLogNotifier {
  @override
  List<Object> build() {
    // TODO this will leak memory for sure
    return [];
  }

  void logError(Object errorMessage, {StackTrace? stacktrace}) {
    state.add(errorMessage);
    print("ErrorLogProvider: \n$errorMessage \nStacktrace:\n$stacktrace");
  }
}
