import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class TextFieldModelable extends StatefulComposableModel {
  int maximumLength;
  String text;
  String errorText;
}

class TextFieldComposer extends Composer<TextFieldComposable>
    implements TextFieldModelable {
  @override
  TextFieldComposable compose() {
    var composableModel = TextFieldComposableModel(maximumLength);
    composableModel.validators = validators;
    return TextFieldComposable(composableModel, validators);
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

class TextFieldComposableModel extends TextFieldModelable
    implements ViewModelValidateable {
  TextFieldComposableModel(int maximumLength) {
    this.maximumLength = maximumLength;
  }

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

class TextFieldComposable extends StatefulComposable<TextFieldModelable> {
  TextFieldComposable(
      TextFieldModelable composableModel, List<Validator> validators)
      : super.validateable(
            composableModel, GlobalKey<_TextFieldComposableState>());

  @override
  State<StatefulWidget> createState() {
    return _TextFieldComposableState();
  }
}

class _TextFieldComposableState
    extends ComposableState<TextFieldComposable, TextFieldModelable> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(_textChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          errorText: widgetModel.errorText, hintText: "Placeholder"),
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
