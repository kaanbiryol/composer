import 'package:composer/composer.dart';
import 'package:example/composables/stateful/text_field.dart';
import 'package:example/composables/stateless/section.dart';
import 'package:example/validators/validators.dart';
import 'package:flutter/material.dart';

import 'composables/stateful/flat_button.dart';

class SecondPage extends ComposedWidget {
  @override
  State<StatefulWidget> createState() {
    return SecondPageState();
  }
}

class SecondPageState extends ComposedWidgetState {
  Future future;

  @override
  void initState() {
    super.initState();
    future = Future.delayed(const Duration(milliseconds: 1000), () {
      var section = prepareSection();
      composables = [section];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
      ),
      body: FutureBuilder(
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
          }),
    );
  }

  Section prepareSection() {
    var sectionWidget =
        (SectionComposer()..withTitle("Back Section")).compose();
    var backButton = (ButtonComposer()
          ..handler(() {
            Navigator.pop(context);
          })
          ..title("Navigate to First Page"))
        .compose();

    var footerSectionButton = (ButtonComposer()
          ..handler(footerHandler)
          ..title("Footer Composable"))
        .compose();

    var headerSectionButton = (ButtonComposer()
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

    Section section = Section(sectionComposable: sectionWidget, rows: [
      footerSectionButton,
      headerSectionButton,
      removeHeader,
      removeFooter,
      backButton,
      makeTextField(),
    ]);
    return section;
  }

  void footerHandler() {
    Composable footerbutton = (ButtonComposer()
          ..title("Validate")
          ..handler(() {
            validate();
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

  Composable makeTextField() {
    return (TextFieldComposer()
          ..maxLength(2)
          ..withValidators([EmptyValidator()]))
        .compose();
  }
}
