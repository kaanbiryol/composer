import 'package:compose/src/utils/exceptions.dart';
import 'package:compose/src/utils/validateable.dart';
import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatelessWidget<T> extends StatelessWidget
    implements Composable<T> {
  final ComposableModel<T> _composableModel;
  final List<Validator> validators = [];

  ComposableStatelessWidget(T composableModel, {Key key})
      : this._composableModel = ComposableModel(composableModel),
        super(key: key);

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
