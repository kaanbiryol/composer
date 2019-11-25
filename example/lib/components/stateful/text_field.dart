import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

class TextFieldComponent
    extends ComposableStatefulWidget<TextFieldComposable> {
  TextFieldComponent(TextFieldComposable componentModel, {Key key})
      : super(componentModel, key: key);

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
    print(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.componentModel.maximumLength,
      controller: textController,
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
