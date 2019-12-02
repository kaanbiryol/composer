import 'package:flutter/widgets.dart';

abstract class Composable<T> extends Widget {
  
  T get componentModel;
  set componentModel(T componentModel);
}

class ComponentModel<T> extends ValueNotifier {
  ComponentModel(value) : super(value);
}
