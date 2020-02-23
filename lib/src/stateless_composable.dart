import 'package:compose/src/utils/exceptions.dart';
import 'package:compose/src/utils/validateable.dart';
import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class StatelessComposable<T extends ComposableModel>
    extends StatelessWidget implements Composable<T> {
  final ComposableNotifier<T> _composableModel;
  final List<Validator> validators = [];

  StatelessComposable(T composableModel)
      : this._composableModel = ComposableNotifier(composableModel),
        super(key: composableModel.key);

  @override
  T get composableModel => _composableModel.value;

  @override
  set composableModel(T composableModel) {
    throw StatelessActingException(
        "can't notify composable model. use ComposableStatefulWidget instead!");
  }

  @override
  bool validate() {
    throw StatelessActingException(
        "can't validate statelesswidget use stateful instead!");
  }
}
