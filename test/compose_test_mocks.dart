import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MockComposableViewModel implements ComposableModel {
  String text;
  MockComposableViewModel(this.text);

  @override
  Key key;
}

class MockComposable extends StatelessComposable<MockComposableViewModel> {
  MockComposable(MockComposableViewModel composableModel)
      : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Text("Composed Widget");
  }
}

class MockStatefulComposableViewModel implements ComposableModel {
  String text;
  MockStatefulComposableViewModel(this.text);

  @override
  Key key;
}

class MockStatefulComposable
    extends StatefulComposable<MockStatefulComposableViewModel> {
  MockStatefulComposable(MockStatefulComposableViewModel composableModel)
      : super(composableModel);

  @override
  State<StatefulWidget> createState() {
    return MockStatefulComposableState();
  }
}

class MockStatefulComposableState extends ComposableState<
    MockStatefulComposable, MockStatefulComposableViewModel> {
  @override
  Widget build(BuildContext context) {
    return Text(widgetModel.text);
  }
}

class MockValidateableComposableViewModel
    implements ComposableModel, ViewModelValidateable {
  String text;
  String errorText;
  MockValidateableComposableViewModel(this.text);

  @override
  bool validate(List<Validator> validators) {
    for (var validator in validators) {
      if (validator.validate(text) == false) {
        errorText = validator.errorText;
        return false;
      }
    }
    errorText = null;
    return true;
  }

  @override
  Key key;
}

class MockValidateableComposable
    extends StatefulComposable<MockValidateableComposableViewModel> {
  MockValidateableComposable(
      MockValidateableComposableViewModel composableModel,
      List<Validator> validators)
      : super.validateable(composableModel, validators,
            GlobalKey<MockValidateableComposableState>());

  @override
  State<StatefulWidget> createState() {
    return MockValidateableComposableState();
  }
}

class MockValidateableComposableState extends ComposableState<
    MockValidateableComposable, MockValidateableComposableViewModel> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(_textChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
    );
  }

  void _textChangedListener() {
    widgetModel.text = textController.text;
    validate();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
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
}

class MockValidator implements Validator<String> {
  int maxLength;
  MockValidator(this.maxLength, {String errorText}) {
    this.errorText = errorText ?? "This field cannot be left empty.";
  }

  @override
  bool validate(String value) {
    return value != null && value.length < maxLength;
  }

  @override
  String errorText;
}

Widget buildTestableWidget(Widget widget) {
  return MaterialApp(
    home: Scaffold(body: widget),
  );
}
