import 'package:compose/compose.dart';
import 'package:flutter/widgets.dart';

abstract class Composable<T> extends Widget implements Validateable {
  T get componentModel;
  set componentModel(T componentModel);
}

class ComponentModel<T> extends ValueNotifier {
  ComponentModel(value) : super(value);
}

abstract class ComposableStrategy<Model, Component> {
  //TODO abstract viewmodel?
  Model model;
  Component component;
  Composable build();
}

//TODO: experimental
class ComposableBuilder {
  List<ComposableStrategy> _composableStrategies;

  ComposableBuilder(List<ComposableStrategy> _composableStrategies) {
    this._composableStrategies = _composableStrategies;
  }

  List<Composable> buildComposables() {
    List<Composable> _composables = [];
    _composableStrategies.forEach((strategy) {
      Composable composable = strategy.build();
      _composables.add(composable);
    });
    return _composables;
  }
}
