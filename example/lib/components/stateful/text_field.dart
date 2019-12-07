import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ValidateCallback = void Function(bool);

abstract class TextFieldComposable {
  int maximumLength;
}

class TextFieldComponentModel implements TextFieldComposable {
  @override
  int maximumLength;

  TextFieldComponentModel(int maximumLength) {
    this.maximumLength = maximumLength;
  }
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
    textController.addListener(printText);
  }

  void printText() {
    validationState.validate();
    print(textController.text);
  }

  @override
  bool validate() {
    print("ONVALDİATE");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
