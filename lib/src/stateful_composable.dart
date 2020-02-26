import 'package:composer/src/utils/exceptions.dart';
import 'package:composer/src/utils/validateable.dart';
import 'package:flutter/widgets.dart';
import '../composer.dart';

abstract class StatefulComposable<T extends StatefulComposableModel>
    extends StatefulWidget implements Composable<T>, Validateable {
  final ComposableNotifier<T> _composableModelNotifier;
  final GlobalKey<ComposableState> _validationKey;

  StatefulComposable(T composableModel)
      : this._composableModelNotifier = ComposableNotifier(composableModel),
        this._validationKey = null,
        super(key: composableModel.key);

  StatefulComposable.validateable(
      T composableModel, GlobalKey<ComposableState> key)
      : this._composableModelNotifier = ComposableNotifier(composableModel),
        this._validationKey = key,
        super(key: key);

  @override
  T get composableModel => _composableModelNotifier.value;
  @override
  set composableModel(T composableModel) =>
      _composableModelNotifier.value = composableModel;

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
    widget._composableModelNotifier.addListener(_composableModelNotifier);
    super.initState();
  }

  void _composableModelNotifier() {
    setState(() {});
  }

  @override
  @mustCallSuper
  void dispose() {
    widget._composableModelNotifier.removeListener(_composableModelNotifier);
    super.dispose();
  }

  V get composableModel => widget._composableModelNotifier.value;
  List<Validator> get validators =>
      widget._composableModelNotifier.value.validators;

  bool validate() {
    if (composableModel is! ViewModelValidateable) {
      throw NonValidateableStatefulWidget(
          "ComposableModel must implement ViewModelValidateable!");
    }
    final validationModel = composableModel as ViewModelValidateable;
    bool isValid = validationModel.validate(validators);
    setState(() {});
    return isValid;
  }
}
