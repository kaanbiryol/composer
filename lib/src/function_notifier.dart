import 'package:flutter/foundation.dart';

abstract class FunctionListenable<T extends Function> {
  const FunctionListenable();
  void addListener(T listener);
  void removeListener(T listener);
}

class FunctionNotifier<Item, V, T extends Function(V)>
    extends GenericChangeNotifier<V, T> {
  FunctionNotifier(this._value);

  Item get value => _value;
  Item _value;
  set value(Item newValue) {
    if (_value == newValue) return;
    _value = newValue;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class GenericChangeNotifier<V, T extends Function(V)>
    implements FunctionListenable<T> {
  ObserverList<T> _listeners = ObserverList<T>();

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('A $runtimeType was used after being disposed.'),
          ErrorDescription(
              'Once you have called dispose() on a $runtimeType, it can no longer be used.')
        ]);
      }
      return true;
    }());
    return true;
  }

  @protected
  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners.isNotEmpty;
  }

  @override
  void addListener(T listener) {
    assert(_debugAssertNotDisposed());
    _listeners.add(listener);
  }

  @override
  void removeListener(T listener) {
    assert(_debugAssertNotDisposed());
    _listeners.remove(listener);
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }

  void notifyListeners(V actionType) {
    assert(_debugAssertNotDisposed());
    if (_listeners != null) {
      final List<T> localListeners = List<T>.from(_listeners);
      for (T listener in localListeners) {
        try {
          if (_listeners.contains(listener)) listener(actionType);
        } catch (exception, stack) {
          FlutterError.reportError(FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'foundation library',
            context: ErrorDescription(
                'while dispatching notifications for $runtimeType'),
            informationCollector: () sync* {
              yield DiagnosticsProperty<GenericChangeNotifier>(
                'The $runtimeType sending notification was',
                this,
                style: DiagnosticsTreeStyle.errorProperty,
              );
            },
          ));
        }
      }
    }
  }
}
