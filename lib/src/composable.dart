import 'package:compose/src/utils/sliver_animations.dart';
import 'package:compose/src/utils/validateable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Composable<T extends ComposableModel> extends Widget {
  T get composableModel;
  set composableModel(T composableModel);
}

class ComposableNotifier<T extends ComposableModel> extends ValueNotifier {
  ComposableNotifier(value) : super(value);
}

abstract class ComposableModel {
  Key key;
  ComposableModel({this.key});
}

abstract class StatelessComposableModel extends ComposableModel {}

abstract class StatefulComposableModel extends ComposableModel {
  List<Validator> validators = [];
}

abstract class ComposableSection {
  Composable sectionComposable;
  List<Composable> rows;
  bool pinned;
  double height;
  SliverAnimation animation;
}

class Section implements ComposableSection {
  Section({@required this.sectionComposable, this.rows});

  @override
  List<Composable> rows;

  @override
  bool pinned = false;

  @override
  Composable sectionComposable;

  @override
  double height;

  @override
  SliverAnimation animation = SliverAnimation.none;
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
