import 'package:compose/src/utils/sliver_animations.dart';
import 'package:compose/src/utils/validateable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ComposableSection {
  Composable sectionComposable;
  List<Composable> composables;
  bool pinned;
  double height;
  SliverAnimation animation;
}

class Section implements ComposableSection {
  Section(this.sectionComposable, this.composables);

  @override
  List<Composable> composables;

  @override
  bool pinned = false;

  @override
  Composable sectionComposable;

  @override
  double height;

  @override
  SliverAnimation animation = SliverAnimation.none;
}

abstract class Composable<T> extends Widget implements Validateable {
  T get composableModel;
  set composableModel(T composableModel);
  final List<Validator> validators = [];
}

abstract class ComposableModel {
  Key key;
  ComposableModel({this.key});
}

class ComposableNotifier<T extends ComposableModel> extends ValueNotifier {
  ComposableNotifier(value) : super(value);
}

abstract class Composer<T> {
  Key key;
  List<Validator> validators;

  T compose();

  void withValidators(List<Validator> validatorList) {
    this.validators = validatorList;
  }

  void withKey(Key key) {
    this.key = key;
  }
}
