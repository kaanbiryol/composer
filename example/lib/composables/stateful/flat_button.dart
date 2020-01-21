import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class ButtonComposable {
  String text;
  VoidCallback onPressed;
}

class ButtonComposer extends Composer<ButtonComponent>
    implements ButtonComposable {
  @override
  var onPressed;

  @override
  String text;

  void title(String title) => text = title;
  void handler(VoidCallback callback) => onPressed = callback;

  @override
  ButtonComponent compose() {
    var viewModel = ButtonComponentViewModel(text: text, onPressed: onPressed);
    //TODO: add key to Composer
    return ButtonComponent(viewModel, key: ValueKey("kaan"));
  }
}

class ButtonComponentViewModel implements ButtonComposable {
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

class _ButtonComponentState
    extends ComposableState<ButtonComponent, ButtonComponentViewModel> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.composableModel;
    return FlatButton(
      onPressed: viewModel.onPressed,
      child: Text(viewModel.text),
    );
  }
}
