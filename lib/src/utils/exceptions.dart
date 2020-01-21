abstract class BaseException implements Exception {
  final String message;
  BaseException(this.message);
  String toString() => runtimeType.toString() + " $message";
}

/*
 * Thrown when Stateless widget tries to act like Stateful widget.
 */

class StatelessActingException implements BaseException {
  final String message;
  const StatelessActingException([this.message = ""]);
}

class EmptyFunctionNotifier implements Exception {
  final String message;
  const EmptyFunctionNotifier([this.message = ""]);
}

class NonValidateableStatefulWidget implements Exception {
  final String message;
  const NonValidateableStatefulWidget([this.message = ""]);
}
