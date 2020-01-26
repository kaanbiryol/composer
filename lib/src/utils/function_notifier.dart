import 'package:flutter/foundation.dart';
import 'exceptions.dart';

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

  @protected
  bool get hasListeners {
    if (_listeners == null) return false;
    return _listeners.isNotEmpty;
  }

  @override
  void addListener(T listener) {
    if (_listeners != null) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(T listener) {
    if (_listeners != null) {
      _listeners.remove(listener);
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners = null;
  }

  void notifyListeners(V actionType) {
    if (_listeners != null) {
      final List<T> localListeners = List<T>.from(_listeners);
      for (T listener in localListeners) {
        try {
          if (_listeners.contains(listener)) listener(actionType);
        } catch (exception) {
          throw EmptyFunctionNotifier(
              "tried to notify listener $runtimeType while it is being deleted");
        }
      }
    }
  }
}
