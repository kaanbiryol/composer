import 'package:compose/src/utils/exceptions.dart';
import 'package:compose/src/utils/validateable.dart';
import 'package:flutter/widgets.dart';
import '../compose.dart';

abstract class StatefulComposable<T extends StatefulComposableModel>
    extends StatefulWidget implements Composable<T>, Validateable {
  final ComposableNotifier<T> _composableModel;
  final GlobalKey<ComposableState> _validationKey;

  StatefulComposable(T composableModel)
      : this._composableModel = ComposableNotifier(composableModel),
        this._validationKey = null,
        super(key: composableModel.key);

  StatefulComposable.validateable(
      T composableModel, GlobalKey<ComposableState> key)
      : this._composableModel = ComposableNotifier(composableModel),
        this._validationKey = key,
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

abstract class ComposableState<T extends StatefulComposable, V>
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
  List<Validator> get validators => widget._composableModel.value.validators;

  bool validate() {
    if (widgetModel is! ViewModelValidateable) {
      throw NonValidateableStatefulWidget(
          "ComposableModel must implement ViewModelValidateable!");
    }
    final validationModel = widgetModel as ViewModelValidateable;
    bool isValid = validationModel.validate(validators);
    setState(() {});
    return isValid;
  }
}
