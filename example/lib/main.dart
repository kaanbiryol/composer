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
        body: ExamplePage(),
      ),
    );
  }
}

class ExamplePage extends ComposedWidget {
  @override
  State<StatefulWidget> createState() {
    return ExamplePageState();
  }
}

class ExamplePageState extends ComposedWidgetState {
  ButtonComponent flatButtonComponent;
  KeyValueRowComponent keyValueRowComponent;

  @override
  List<Composable> prepareCompose(BuildContext context) {
    var viewModel = ButtonComponentViewModel(text: "NO", onPressed: onPressed);
    flatButtonComponent = ButtonComponent(viewModel, key: ValueKey("kaan"));
    var keyValueComponent = makeKeyValue();
    var textFieldComponent = makeTextField();

    return [flatButtonComponent, keyValueComponent, textFieldComponent];
  }

  Composable makeTextField() {
    var textFieldComponentViewModel = TextFieldComponentModel(2);
    var textFieldComponent = TextFieldComponent(textFieldComponentViewModel);
    return textFieldComponent;
  }

  Composable makeKeyValue() {
    var keyValueViewModel =
        KeyValueComponentViewModel(key: "Key", value: "Value");
    keyValueRowComponent =
        KeyValueRowComponent(componentModel: keyValueViewModel);
    return keyValueRowComponent;
  }

  void onPressed() {
    var viewModel =
        ButtonComponentViewModel(text: "onPressed", onPressed: onPressed);
    Composable composable = componentWith(ValueKey("kaan"));
    composable.componentModel = viewModel;
    // or we can : flatButtonComponent.componentModel = viewModel;
  }

  @override
  List<Composable> prepareBottom(BuildContext context) {
    var viewModel = ButtonComponentViewModel(text: "NO", onPressed: onPressed);
    flatButtonComponent = ButtonComponent(viewModel, key: ValueKey("kaan"));
    return [flatButtonComponent];
  }

  @override
  bool setupTraits() {
    seperatorStyle = SeperatorStyle.none;
    return true;
  }
}
