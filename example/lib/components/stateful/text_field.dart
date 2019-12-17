import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class TextFieldComposable {
  int maximumLength;
  String text;
  String errorText;
}

class TextFieldComposer extends Composer<TextFieldComponent>
    implements TextFieldComposable {
  @override
  TextFieldComponent compose() {
    var textFieldComponentViewModel = TextFieldComponentModel(maximumLength);
    return TextFieldComponent(textFieldComponentViewModel, validators);
  }

  void maxLength(int length) {
    maximumLength = length;
  }

  @override
  String errorText;

  @override
  int maximumLength;

  @override
  String text;
}

class TextFieldComponentModel
    implements TextFieldComposable, ViewModelValidateable {
  TextFieldComponentModel(int maximumLength) {
    this.maximumLength = maximumLength;
  }

  @override
  int maximumLength;

  @override
  String errorText;

  @override
  String text;

  @override
  bool validate(List<Validator> validators) {
    for (var validator in validators) {
      if (validator.validate(text) == false) {
        errorText = validator.errorText;
        return false;
      }
    }
    errorText = null;
    return true;
  }
}

class TextFieldComponent extends ComposableStatefulWidget<TextFieldComposable> {
  TextFieldComponent(
      TextFieldComposable componentModel, List<Validator> validators)
      : super.validateable(
            componentModel, validators, GlobalKey<_TextFieldComponentState>());

  @override
  State<StatefulWidget> createState() {
    return _TextFieldComponentState();
  }
}

class _TextFieldComponentState
    extends ComposableState<TextFieldComponent, TextFieldComposable> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(_textChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(errorText: widgetModel.errorText),
      controller: textController,
    );
  }

  void _textChangedListener() {
    widgetModel.text = textController.text;
    validate();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
