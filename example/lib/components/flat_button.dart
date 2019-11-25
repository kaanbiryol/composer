import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

class ButtonComponentViewModel {
  String text;
  VoidCallback onPressed;

  ButtonComponentViewModel({String text, VoidCallback onPressed}) {
    this.onPressed = onPressed;
    this.text = text;
  }
}

class ButtonComponent
    extends ComposableStatefulWidget<ButtonComponentViewModel> {
  ButtonComponent(ButtonComponentViewModel componentModel, {Key key})
      : super(componentModel, key: key);

  @override
  _ButtonComponentState createState() => _ButtonComponentState();
}

class _ButtonComponentState extends ComposableState<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.componentModel;
    return FlatButton(
      onPressed: viewModel.onPressed,
      child: Text(viewModel.text),
    );
  }
}
