import 'package:flutter/foundation.dart';
import '../../compose.dart';

abstract class FunctionListenable<T extends Function> {
  const FunctionListenable();
  void addListener({@required Section section, @required T listener});
  void removeListener({@required Section section});
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
  Map<Section, T> _listeners = {};

  void notifyListeners(Section section, V actionType) {
    var listener = _listeners[section];
    if (listener != null) {
      listener(actionType);
    }
  }

  @protected
  bool get hasListeners {
    if (_listeners == null) return false;
    return _listeners.isNotEmpty;
  }

  @override
  void addListener({@required Section section, @required T listener}) {
    if (_listeners != null) {
      _listeners[section] = listener;
    }
  }

  @override
  void removeListener({@required Section section}) {
    if (section != null) {
      _listeners.remove(section);
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}
