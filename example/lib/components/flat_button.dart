import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

typedef ViewModelHandler<T> = void Function(T viewModel);

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

  ButtonComponentViewModel viewModel;

  @override
  var onChanged;
}

class _ButtonComponentState
    extends ComposableState<ButtonComponent, ButtonComponentViewModel> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return FlatButton(
      onPressed: viewModel.onPressed,
      child: Text(viewModel.text),
    );
  }
}
