import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'components/stateful/flat_button.dart';
import 'components/stateful/text_field.dart';
import 'components/stateless/key_value_row.dart';

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

    var textFieldComponentViewModel = TextFieldComponentModel(2);
    var textFieldComponent = TextFieldComponent(textFieldComponentViewModel);

    return [flatButtonComponent, keyValueComponent, textFieldComponent];
  }

  void onPressed() {
    var viewModel = ButtonComponentViewModel(text: "YES", onPressed: onPressed);
    flatButtonComponent.componentModel = viewModel;
  }
}
