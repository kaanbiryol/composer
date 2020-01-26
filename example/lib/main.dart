import 'package:compose/compose.dart';
import 'package:example/composables/stateless/section.dart';
import 'package:example/validators/validators.dart';
import 'package:flutter/material.dart';
import 'composables/stateful/flat_button.dart';
import 'composables/stateful/text_field.dart';
import 'composables/stateless/key_value_row.dart';

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
  Section firstSection;
  ButtonComposable appendRowButton;
  ButtonComposable removeRowButton;

  ButtonComposable appendSectionButton;
  ButtonComposable removeSectionButton;
  KeyValueComposable keyValueRowComponent;

  Section secondSection;

  @override
  List<Section> prepareCompose(BuildContext context) {
    appendRowButton = (ButtonComposer()
          ..handler(appendButtonHandler)
          ..title("Append Row"))
        .compose();
    removeRowButton = (ButtonComposer()
          ..handler(removeButtonHandler)
          ..title("Remove Row"))
        .compose();

    appendSectionButton = (ButtonComposer()
          ..handler(appendSectionHandler)
          ..title("Append Section"))
        .compose();

    removeSectionButton = (ButtonComposer()
          ..withKey(ValueKey("KAAN"))
          ..handler(removeSectionHandler)
          ..title("Remove Section"))
        .compose();

    keyValueRowComponent = (KeyValueComposer()
          ..withKeyValue("KEY")
          ..withValue("VALUE"))
        .compose();

    var firstSectionWidget =
        (SectionComposer()..withTitle("Section Title")).compose();
    firstSection = Section(firstSectionWidget, [
      keyValueRowComponent,
      appendRowButton,
      removeRowButton,
      makeTextField(),
      appendSectionButton,
      removeSectionButton
    ]);

    return [firstSection];
  }

  Composable makeTextField() {
    var textFieldComponentViewModel = TextFieldComposableModel(2);
    var textFieldComponent =
        TextFieldComposable(textFieldComponentViewModel, [EmptyValidator()]);
    return textFieldComponent;
  }

  Composable makeKeyValue() {
    var keyValueViewModel =
        KeyValueComposableModel(keyValue: "Key", value: "Value");
    keyValueRowComponent = KeyValueComposable(keyValueViewModel);
    return keyValueRowComponent;
  }

  void appendSectionHandler() {
    var secondSectionWidget =
        (SectionComposer()..withTitle("New Section")).compose();
    secondSection = Section(secondSectionWidget, [makeTextField()]);
    appendSection(section: secondSection);
  }

  void removeSectionHandler() {
    removeSection(secondSection);
  }

  void appendButtonHandler() {
    // var viewModel =
    //     ButtonComponentViewModel(text: "onPressed", onPressed: onPressed);
    // Composable composable = componentWith(ValueKey("kaan"));
    // composable.componentModel = viewModel;
    /*appendRow(
        section: firstSection, composable: keyValueRowComponent, index: 0);
    validate();*/

    print(composableWith(ValueKey("KAAN")));

    var secondSectionWidget =
        (SectionComposer()..withTitle("New Section")).compose();
    secondSection = Section(secondSectionWidget, [makeTextField()]);

    composables = [secondSection];
    // or we can : flatButtonComponent.componentModel = viewModel;
  }

  void removeButtonHandler() {
    var removeRowButton = (ButtonComposer()
          ..handler(removeButtonHandler)
          ..title("Remove Row"))
        .compose();
    bottomComposable = removeRowButton;

    // or we can : flatButtonComponent.componentModel = viewModel;
  }
}
