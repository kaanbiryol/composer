import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

class ButtonComponentViewModel {
  VoidCallback onPressed;

  ButtonComponentViewModel({VoidCallback onPressed}) {
    this.onPressed = onPressed;
  }
}

class ButtonComponent implements Composable<ButtonComponentViewModel> {
  ButtonComponent(ButtonComponentViewModel viewModel) {
    this.viewModel = viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: viewModel.onPressed,
      child: Text("BUTTON NAME"),
    );
  }

  @override
  ButtonComponentViewModel viewModel;
}
