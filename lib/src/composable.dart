import 'package:compose/compose.dart';
import 'package:flutter/widgets.dart';

abstract class Composable<T> extends Widget implements Validateable {
  T get componentModel;
  set componentModel(T componentModel);
  final List<Validator> validators = [];
}

class ComponentModel<T> extends ValueNotifier {
  ComponentModel(value) : super(value);
}

abstract class Composer<T> {
  List<Validator> validators;
  T compose();
  void withValidators(List<Validator> validatorList) {
    validators = validatorList;
  }
}
