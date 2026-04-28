import 'package:floyd_rose_tuner/provider/error_log_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controllers in the app
base class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final errorLogger = context.container.read(errorLogProvider.notifier);
    final error = _findError(newValue);
    if (error != null) {
      final Object exception = error.error;
      errorLogger.logError(exception, stacktrace: error.stackTrace);
    }
  }

  AsyncError? _findError(Object? value) {
    if (value is AsyncValue && value.hasError) {
      return value.asError;
    } else {
      return null;
    }
  }
}
