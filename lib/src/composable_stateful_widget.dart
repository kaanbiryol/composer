import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {
  final ComponentModel<T> _componentModel;
  final GlobalKey<ComposableState> _validationKey;
  final List<Validator> validators;

  //TODO: required optional named parameters
  ComposableStatefulWidget(T componentModel, {Key key})
      : this._componentModel = ComponentModel(componentModel),
        this._validationKey = null,
        this.validators = [],
        super(key: key);

  ComposableStatefulWidget.validateable(T componentModel,
      List<Validator> validators, GlobalKey<ComposableState> key)
      : this._componentModel = ComponentModel(componentModel),
        this._validationKey = key,
        this.validators = validators,
        super(key: key);

  @override
  T get componentModel => _componentModel.value;
  @override
  set componentModel(T componentModel) =>
      _componentModel.value = componentModel;

  @override
  bool validate() {
    assert(_validationKey != null,
        "use ComposableStatefulWidget.validateable() if you wish to validate your component");
    return _validationKey.currentState.validate();
  }
}

abstract class ComposableState<T extends ComposableStatefulWidget, V>
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

  V get widgetModel => widget._componentModel.value;

  bool validate() {
    assert(widgetModel is ViewModelValidateable,
        "ComponentModel must implement ViewModelValidateable!");
    final validationModel = widgetModel as ViewModelValidateable;
    bool isValid = validationModel.validate(widget.validators);
    setState(() {});
    return isValid;
  }
}
