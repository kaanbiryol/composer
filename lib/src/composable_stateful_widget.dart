import 'package:compose/src/utils/exceptions.dart';
import 'package:compose/src/utils/validateable.dart';
import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class ComposableStatefulWidget<T> extends StatefulWidget
    implements Composable<T> {
  final ComposableModel<T> _composableModel;
  final GlobalKey<ComposableState> _validationKey;
  final List<Validator> validators;

  //TODO: required optional named parameters
  ComposableStatefulWidget(T composableModel, {Key key})
      : this._composableModel = ComposableModel(composableModel),
        this._validationKey = null,
        this.validators = [],
        super(key: key);

  ComposableStatefulWidget.validateable(T composableModel,
      List<Validator> validators, GlobalKey<ComposableState> key)
      : this._composableModel = ComposableModel(composableModel),
        this._validationKey = key,
        this.validators = validators,
        super(key: key);

  @override
  T get composableModel => _composableModel.value;
  @override
  set composableModel(T composableModel) =>
      _composableModel.value = composableModel;

  @override
  bool validate() {
    return _validationKey == null
        ? throw NonValidateableStatefulWidget(
            "use ComposableStatefulWidget.validateable() if you wish to validate your composable")
        : _validationKey.currentState.validate();
  }
}

abstract class ComposableState<T extends ComposableStatefulWidget, V>
    extends State<T> {
  @override
  @mustCallSuper
  void initState() {
    widget._composableModel.addListener(_composableModelNotifier);
    super.initState();
  }

  void _composableModelNotifier() {
    setState(() {});
  }

  @override
  @mustCallSuper
  void dispose() {
    widget._composableModel.removeListener(_composableModelNotifier);
    super.dispose();
  }

  V get widgetModel => widget._composableModel.value;

  bool validate() {
    if (widgetModel is! ViewModelValidateable) {
      throw NonValidateableStatefulWidget(
          "ComposableModel must implement ViewModelValidateable!");
    }
    final validationModel = widgetModel as ViewModelValidateable;
    bool isValid = validationModel.validate(widget.validators);
    setState(() {});
    return isValid;
  }
}
