import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class TextFieldComposable {
  int maximumLength;
  String errorText;
}

class TextFieldComponentModel implements TextFieldComposable {
  TextFieldComponentModel(int maximumLength) {
    this.maximumLength = maximumLength;
  }

  @override
  int maximumLength;

  @override
  String errorText;
}

class TextFieldComponent extends ComposableStatefulWidget<TextFieldComposable> {
  TextFieldComponent(TextFieldComposable componentModel)
      : super.validateable(
            componentModel, GlobalKey<_TextFieldComponentState>());

  @override
  State<StatefulWidget> createState() {
    return _TextFieldComponentState();
  }
}

class _TextFieldComponentState extends ComposableState<TextFieldComponent> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(_textChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(errorText: widget.componentModel.errorText),
      controller: textController,
    );
  }

  void _textChangedListener() {
    widget.componentModel.errorText = null;
    widget.validate();
    print(textController.text);
  }

  @override
  bool validate(List<Validator> validators) {
    for (var validator in validators) {
      if (validator.validate(textController.text) == false) {
        widget.componentModel.errorText = validator.errorText;
        setState(() {});
        return false;
      }
    }
    setState(() {});
    return true;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
