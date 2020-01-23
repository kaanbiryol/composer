import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class TextFieldModelable implements ComposableModel {
  int maximumLength;
  String text;
  String errorText;
}

class TextFieldComposer extends Composer<TextFieldComposable>
    implements TextFieldModelable {
  @override
  TextFieldComposable compose() {
    var composableModel = TextFieldComposableModel(maximumLength);
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

  @override
  ThemeData themeData;
}

class TextFieldComposableModel
    implements TextFieldModelable, ViewModelValidateable {
  TextFieldComposableModel(int maximumLength) {
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

  @override
  Key key;

  @override
  ThemeData themeData;
}

class TextFieldComposable extends StatefulComposable<TextFieldModelable> {
  TextFieldComposable(
      TextFieldModelable composableModel, List<Validator> validators)
      : super.validateable(composableModel, validators,
            GlobalKey<_TextFieldComposableState>());

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
