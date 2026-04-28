import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A helper [AsyncValue] extension to show an alert dialog on error
extension AsyncValueUI on AsyncValue<dynamic> {
  /// show an alert dialog if the current [AsyncValue] has an error and the
  /// state is not loading.
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        message: message,
      );
    }
  }

  String _errorMessage(Object? error) {
    return error.toString();
  }
}

void showExceptionAlertDialog({
  required BuildContext context,
  required title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(title: title, content: Text(message)),
  );
}
