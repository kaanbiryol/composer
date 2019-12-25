import 'package:compose/compose.dart';
import 'package:example/components/stateless/section.dart';
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
  KeyValueComponent keyValueRowComponent;

  @override
  List<Section> prepareCompose(BuildContext context) {
    List<Section> sections = [];
    flatButtonComponent = (ButtonComposer()
          ..handler(onPressed)
          ..title("Title"))
        .compose();
    var textFieldComponent = (TextFieldComposer()
          ..maxLength(5)
          ..withValidators([EmptyValidator()]))
        .compose();
    // var keyValueComponent = makeKeyValue();
    var keyValueComponent = (KeyValueComposer()
          ..withKey("KEY")
          ..withValue("VALUE"))
        .compose();

    var firstSectionWidget =
        (SectionComposer()..withTitle("Section Title")).compose();
    var firstSection = Section(firstSectionWidget,
        [flatButtonComponent, keyValueComponent, textFieldComponent]);
    sections.add(firstSection);
    return [sections.first];
  }

  Composable makeTextField() {
    var textFieldComponentViewModel = TextFieldComponentModel(2);
    var textFieldComponent =
        TextFieldComponent(textFieldComponentViewModel, [EmptyValidator()]);
    return textFieldComponent;
  }

  Composable makeKeyValue() {
    var keyValueViewModel =
        KeyValueComponentViewModel(key: "Key", value: "Value");
    keyValueRowComponent = KeyValueComponent(componentModel: keyValueViewModel);
    return keyValueRowComponent;
  }

  void onPressed() {
    // var viewModel =
    //     ButtonComponentViewModel(text: "onPressed", onPressed: onPressed);
    // Composable composable = componentWith(ValueKey("kaan"));
    // composable.componentModel = viewModel;
    appendRow(section: null, composable: makeKeyValue(), index: 0);
    validate();
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
