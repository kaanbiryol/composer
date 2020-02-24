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

  var future;
  @override
  void initState() {
    super.initState();
    future = Future.delayed(const Duration(milliseconds: 1000), () {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 300),
        content: Text("FutureBuilder completed!"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return super.build(context);
            default:
              return Center(child: Text(snapshot.data));
          }
        });
  }

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
    secondSection = Section(secondSectionWidget, [makeTextField()]);
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

  void footerHandler() {
    Composable footerbutton = (ButtonComposer()
          ..title("Footer Button")
          ..handler(() {
            Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 300),
              content: Text("Footer Button Tapped!"),
            ));
          }))
        .compose();
    bottomComposables = [footerbutton];
  }

  void headerHandler() {
    Composable headerButton = (ButtonComposer()
          ..title("Header Button")
          ..handler(() {
            Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 300),
              content: Text("Header Button Tapped!"),
            ));
          }))
        .compose();
    topComposables = [headerButton, headerButton];
  }

  void removeHeaderHandler() {
    topComposables = [];
  }

  void removeFooterHandler() {
    bottomComposables = [];
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

    footerSectionButton = (ButtonComposer()
          ..handler(footerHandler)
          ..title("Footer Composable"))
        .compose();

    headerSectionButton = (ButtonComposer()
          ..handler(headerHandler)
          ..title("Header Composable"))
        .compose();

    var removeHeader = (ButtonComposer()
          ..handler(removeHeaderHandler)
          ..title("Remove Header"))
        .compose();

    var removeFooter = (ButtonComposer()
          ..handler(removeFooterHandler)
          ..title("Remove Footer"))
        .compose();

    var updateKeyValueButton = (ButtonComposer()
          ..handler(() {
            Composable keyValueComposable = composableWith(updateComposableKey);
            keyValueComposable.composableModel =
                ButtonComposableModel(text: "Updated Text", onPressed: () {});
          })
          ..title("Update Button Text")
          ..withKey(updateComposableKey))
        .compose();

    var firstSectionWidget =
        (SectionComposer()..withTitle("First Section")).compose();
    firstSection = Section(firstSectionWidget, [
      appendRowButton,
      removeRowButton,
      appendSectionButton,
      removeSectionButton,
      headerSectionButton,
      footerSectionButton,
      removeHeader,
      removeFooter,
      updateKeyValueButton,
      makeTextField(),
    ]);

    return [firstSection];
  }
}
