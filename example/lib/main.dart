import 'package:compose/compose.dart';
import 'package:example/components/flat_button.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter"),
        ),
        body: StatelessWidgetTest(),
      ),
    );
  }
}

class StatelessWidgetTest extends ComposableStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  List<Composable> prepareCompose(BuildContext context) {
    var textComponent = TextComponent();
    var viewModel = ButtonComponentViewModel(onPressed: () {
      print("onPressed");
    });
    var flatButtonComponent = ButtonComponent(viewModel);
    return [textComponent, flatButtonComponent];
  }
}
