import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {
  final ComponentModel<T> _componentModel;
  final GlobalKey<ComposableState> _validationKey;

  ComposableStatefulWidget(T componentModel, {Key key})
      : this._componentModel = ComponentModel(componentModel),
        this._validationKey = null,
        super(key: key);

  ComposableStatefulWidget.validateable(
      T componentModel, GlobalKey<ComposableState> key)
      : this._componentModel = ComponentModel(componentModel),
        this._validationKey = key,
        super(key: key);

  @override
  T get componentModel => _componentModel.value;
  @override
  set componentModel(T componentModel) =>
      _componentModel.value = componentModel;

  @override
  bool validate() {
    assert(_validationKey != null,
        "use Widget.validateable() if you wish to validate your component");
    return _validationKey.currentState.validate();
  }
}

abstract class ComposableState<T extends ComposableStatefulWidget>
    extends State<T> {
  @override
  @mustCallSuper
  void initState() {
    widget._componentModel.addListener(_componentModelNotifier);
    super.initState();
  }

  void _componentModelNotifier() {
    setState(() {});
  }

  @override
  @mustCallSuper
  void dispose() {
    widget._componentModel.removeListener(_componentModelNotifier);
    super.dispose();
  }

  ComposableState<ComposableStatefulWidget> get validationState =>
      widget._validationKey.currentState;

  bool validate() {
    return false;
  }
}
