import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MockComposableViewModel {
  String text;
  MockComposableViewModel(this.text);
}

class MockComposable
    extends ComposableStatelessWidget<MockComposableViewModel> {
  MockComposable(MockComposableViewModel componentModel)
      : super(componentModel);

  @override
  Widget build(BuildContext context) {
    return Text("Composed Widget");
  }
}

class MockPage extends ComposedWidget {
  @override
  State<StatefulWidget> createState() {
    return MockPageState();
  }
}

class MockPageState extends ComposedWidgetState {
  Section mockSection;
  var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));

  @override
  List<Section> prepareCompose(BuildContext context) {
    mockSection = Section(mockComposable, [mockComposable]);
    return [mockSection];
  }

  @override
  bool setupTraits() {
    return true;
  }
}

class MockValidator implements Validator<String> {
  MockValidator({String errorText}) {
    this.errorText = errorText ?? "This field cannot be left empty.";
  }

  @override
  bool validate(String value) {
    return value != null && value.isNotEmpty;
  }

  @override
  String errorText;
}

Widget buildTestableWidget(Widget widget) {
  return MaterialApp(
    home: Scaffold(body: widget),
  );
}


