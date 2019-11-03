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
  ButtonComponent(this.viewModel, {Key key}) : super();

  @override
  _ButtonComponentState createState() => _ButtonComponentState();

  @override
  ComposableValueNotifier<ButtonComponentViewModel> viewModel;
}

class _ButtonComponentState
    extends ComposableState<ButtonComponent, ButtonComponentViewModel> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel.value;
    return FlatButton(
      onPressed: viewModel.onPressed,
      child: Text(viewModel.text),
    );
  }
}
