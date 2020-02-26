import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class ButtonModelable extends StatefulComposableModel {
  String text;
  VoidCallback onPressed;
}

class ButtonComposer extends Composer<ButtonComposable>
    implements ButtonModelable {
  @override
  var onPressed;

  @override
  String text;

  void title(String title) => text = title;
  void handler(VoidCallback callback) => onPressed = callback;

  @override
  ButtonComposable compose() {
    var composableModel =
        ButtonComposableModel(text: text, onPressed: onPressed);
    composableModel.key = key;
    return ButtonComposable(composableModel, key: ValueKey("KEY"));
  }
}

class ButtonComposableModel extends ButtonModelable {
  String text;
  VoidCallback onPressed;

  ButtonComposableModel({String text, VoidCallback onPressed}) {
    this.onPressed = onPressed;
    this.text = text;
  }
}

class ButtonComposable extends StatefulComposable<ButtonModelable> {
  ButtonComposable(ButtonModelable componentModel, {Key key})
      : super(componentModel);

  @override
  _ButtonComposableState createState() => _ButtonComposableState();
}

class _ButtonComposableState
    extends ComposableState<ButtonComposable, ButtonComposableModel> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.composableModel;
    return FlatButton(
      color: Colors.red,
      onPressed: viewModel.onPressed,
      child: Text(viewModel.text),
    );
  }
}

