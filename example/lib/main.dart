import 'package:compose/compose.dart';
import 'package:example/components/flat_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Composable Demo"),
        ),
        body: StatelessWidgetTest(),
      ),
    );
  }
}

class StatelessWidgetTest extends ComposableStatelessWidget {
  ButtonComponent flatButtonComponent;

  @override
  List<Composable> prepareCompose(BuildContext context) {
    var viewModel = ButtonComponentViewModel(text: "NO", onPressed: onPressed);
    flatButtonComponent = ButtonComponent(viewModel);
    return [flatButtonComponent];
  }

  void onPressed() {
    var viewModel = ButtonComponentViewModel(text: "YES", onPressed: onPressed);
    notifyComposable<ButtonComponent, ButtonComponentViewModel>(
        flatButtonComponent, viewModel);
  }
}
