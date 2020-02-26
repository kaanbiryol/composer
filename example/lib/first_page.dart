import 'package:composer/composer.dart';
import 'package:example/composables/stateful/flat_button.dart';
import 'package:example/second_page.dart';
import 'package:example/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'composables/stateful/text_field.dart';
import 'composables/stateless/key_value_row.dart';
import 'composables/stateless/section.dart';

class FirstPage extends ComposedWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstPageState();
  }
}

class FirstPageState extends ComposedWidgetState {
  Section firstSection;
  Section secondSection;

  ButtonComposable appendRowButton;
  ButtonComposable removeRowButton;
  ButtonComposable appendSectionButton;
  ButtonComposable removeSectionButton;
  ButtonComposable headerSectionButton;
  ButtonComposable footerSectionButton;
  ButtonComposable updateKeyValueButton;
  KeyValueComposable keyValueComposable;

  final updateComposableKey = ValueKey("updateComposableModel");
  final keyValueKey = ValueKey("FirstRow");

  Composable makeTextField() {
    return (TextFieldComposer()
          ..maxLength(2)
          ..withValidators([EmptyValidator()]))
        .compose();
  }

  Composable makeKeyValue() {
    return (KeyValueComposer()
          ..withKey(keyValueKey)
          ..withKeyValue("KEY")
          ..withValue("VALUE"))
        .compose();
  }

  void appendSectionHandler() {
    var secondSectionWidget =
        (SectionComposer()..withTitle("Second Section")).compose();
    secondSection = Section(
        sectionComposable: secondSectionWidget, rows: [makeTextField()]);
    appendSection(section: secondSection);
  }

  void removeSectionHandler() {
    removeSection(secondSection);
  }

  void appendButtonHandler() {
    Composable composable = makeKeyValue();
    appendRow(section: firstSection, composable: composable, index: 0);
  }

  void removeButtonHandler() {
    removeRow(composable: composableWith(keyValueKey), section: firstSection);
  }

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

    var updateKeyValueButton = (ButtonComposer()
          ..handler(() {
            Composable keyValueComposable = composableWith(updateComposableKey);
            keyValueComposable.composableModel =
                ButtonComposableModel(text: "State set", onPressed: () {});
          })
          ..title("Reset state")
          ..withKey(updateComposableKey))
        .compose();

    var resetComposables = (ButtonComposer()
          ..handler(() {
            var firstSectionWidget =
                (SectionComposer()..withTitle("NEW Section!")).compose();
            var newSection =
                Section(sectionComposable: firstSectionWidget, rows: [
              updateKeyValueButton,
              makeTextField(),
            ]);
            composables = [newSection];
          })
          ..title("Reset Composables"))
        .compose();

    var secondPageButton = (ButtonComposer()
          ..handler(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          })
          ..title("Navigate to Second Page"))
        .compose();

    var firstSectionWidget =
        (SectionComposer()..withTitle("First Section")).compose();
    firstSection = Section(sectionComposable: firstSectionWidget, rows: [
      appendRowButton,
      removeRowButton,
      appendSectionButton,
      removeSectionButton,
      updateKeyValueButton,
      secondPageButton,
      resetComposables,
    ]);

    return [firstSection];
  }
}
