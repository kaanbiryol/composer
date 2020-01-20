/*
 * Thrown when Stateless widget tries to act like Stateful widget.
 */
class StatelessActingException implements Exception {
  final String message;
  const StatelessActingException([this.message = ""]);
  String toString() => "StatelessActingException: $message";
}
