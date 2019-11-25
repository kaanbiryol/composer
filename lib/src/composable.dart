import 'package:flutter/widgets.dart';

abstract class Composable<T> implements Widget {
  final ComponentModel<T> _componentModel;
  Composable(this._componentModel);
  T get componentModel;
  set componentModel(T componentModel);
}

class ComponentModel<T> extends ValueNotifier {
  ComponentModel(value) : super(value);
}
