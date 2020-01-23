import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class ButtonModelable implements ComposableModel {
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
        ButtonComponentViewModel(text: text, onPressed: onPressed);
    composableModel.key = key;
    return ButtonComposable(composableModel, key: ValueKey("kaan"));
  }

  @override
  ThemeData themeData;
}

class ButtonComponentViewModel implements ButtonModelable {
  String text;
  VoidCallback onPressed;

  ButtonComponentViewModel({String text, VoidCallback onPressed}) {
    this.onPressed = onPressed;
    this.text = text;
  }

  @override
  Key key;

  @override
  ThemeData themeData;
}

class ButtonComposable extends StatefulComposable<ButtonModelable> {
  ButtonComposable(ButtonModelable componentModel, {Key key})
      : super(componentModel);

  @override
  _ButtonComposableState createState() => _ButtonComposableState();
}

class _ButtonComposableState
    extends ComposableState<ButtonComposable, ButtonComponentViewModel> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.composableModel;
    return FlatButton(
      onPressed: viewModel.onPressed,
      child: Text(viewModel.text),
    );
  }
}
