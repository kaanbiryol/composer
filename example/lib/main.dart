import 'package:compose/compose.dart';
import 'package:example/components/flat_button.dart';
import 'package:example/components/key_value_row.dart';
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
        body: TestPageWidget(),
      ),
    );
  }
}

class TestPageWidget extends ComposedWidget {
  ButtonComponent flatButtonComponent;

  @override
  List<Composable> prepareCompose(BuildContext context) {
    var viewModel = ButtonComponentViewModel(text: "NO", onPressed: onPressed);
    flatButtonComponent = ButtonComponent(viewModel);
    var keyValueViewModel =
        KeyValueComponentViewModel(key: "Key", value: "Value");
    var keyValueComponent =
        KeyValueRowComponent(componentModel: keyValueViewModel);
    return [flatButtonComponent, keyValueComponent];
  }

  void onPressed() {
    var viewModel = ButtonComponentViewModel(text: "YES", onPressed: onPressed);
    flatButtonComponent.componentModel = viewModel;
  }
}
