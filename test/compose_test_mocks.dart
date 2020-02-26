import 'package:compose/compose.dart';
import 'package:compose/src/utils/widget_state_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MockComposableViewModel extends StatelessComposableModel {
  String text;
  MockComposableViewModel(this.text);
}

class MockComposable extends StatelessComposable<MockComposableViewModel> {
  MockComposable(MockComposableViewModel composableModel)
      : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Text("Composed Widget");
  }
}

class MockStatefulComposableViewModel extends StatefulComposableModel {
  String text;
  MockStatefulComposableViewModel(this.text);
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

class MockValidateableComposableViewModel extends StatefulComposableModel
    implements ViewModelValidateable {
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
}

class MockValidateableComposable
    extends StatefulComposable<MockValidateableComposableViewModel> {
  MockValidateableComposable(
      MockValidateableComposableViewModel composableModel)
      : super.validateable(
            composableModel, GlobalKey<MockValidateableComposableState>());

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

class StatelessMockComposer extends Composer {
  @override
  compose() {
    var viewModel = MockComposableViewModel("A very long text");
    viewModel.key = key;
    var composable = MockComposable(viewModel);
    return composable;
  }
}

class ValidateableMockComposer extends Composer {
  @override
  compose() {
    var viewModel = MockValidateableComposableViewModel("A very long text");
    viewModel.validators = validators;
    var composable = MockValidateableComposable(viewModel);
    return composable;
  }
}

class MockPage extends ComposedWidget {
  @override
  State<StatefulWidget> createState() {
    return MockPageState();
  }
}

class MockPageState extends ComposedWidgetState with WidgetStateListener {
  bool widgetAppeared = false;
  Section mockSection;
  var mockComposable =
      MockComposable(MockComposableViewModel("Stateless Mock"));
  var statefulMockComposable =
      MockStatefulComposable(MockStatefulComposableViewModel("Stateful Mock"));

  @override
  List<Section> prepareCompose(BuildContext context) {
    mockSection = Section(
        sectionComposable: mockComposable,
        rows: [mockComposable, statefulMockComposable]);
    return [mockSection];
  }

  @override
  void widgetDidAppear(BuildContext context) {
    widgetAppeared = true;
  }
}

class MockCharacterLengthValidator implements Validator<String> {
  int maxLength;
  MockCharacterLengthValidator(this.maxLength, {String errorText}) {
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
