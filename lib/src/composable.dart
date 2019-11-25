import 'package:flutter/widgets.dart';

abstract class Composable<T> extends Widget {
  final ComponentModel<T> viewModel;
  Composable({this.viewModel});
}

class ComponentModel<T> extends ValueNotifier {
  ComponentModel(value) : super(value);
}
