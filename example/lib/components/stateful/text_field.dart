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
  TextFieldComponent(TextFieldComposable componentModel, {Key key})
      : super(componentModel, key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextFieldComponentState();
  }

  @override
  bool validate() {
    print("VALİDTEA");
    validateCallback(false);
    componentModel.maximumLength = 200;
    return false;
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
    // if (widget.validate() == false) {
    //   setState(() {
    //     widget.componentModel.maximumLength = 20;
    //   });
    // }

    print(textController.text);
  }

  void test(bool bulmac) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("KAAN" + widget.componentModel.maximumLength.toString());
    widget.validateCallback = test;

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
