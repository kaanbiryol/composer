import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatelessWidget<T> extends StatelessWidget
    implements Composable<T> {
  final ComponentModel<T> _componentModel;
  final List<Validator> validators = [];

  ComposableStatelessWidget(T componentModel, {Key key})
      : this._componentModel = ComponentModel(componentModel),
        super(key: key);

  @override
  T get componentModel => _componentModel.value;

  @override
  set componentModel(T componentModel) {
    throw "can't notify component model. use ComposableStatefulWidget instead!";
  }

  @override
  bool validate() {
    throw "can't validate statelesswidget use stateful instead!";
  }
}
