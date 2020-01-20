import 'package:compose/compose.dart';
import 'package:compose/src/exceptions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'compose_test_mocks.dart';

Widget get mockWidget => buildTestableWidget(MockPage());
MockPageState getState(WidgetTester tester) {
  return tester.state(find.byType(MockPage));
}

void main() {
  testWidgets('append row', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    state.appendRow(section: mockSection, composable: mockComposable);

    var currentSection =
        sections.firstWhere((section) => identical(section, mockSection));
    expect(currentSection.composables.length, 2);
  });

  testWidgets('append row to index', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable =
        MockComposable(MockComposableViewModel("Mock Text Index 0"));
    state.appendRow(section: mockSection, composable: mockComposable, index: 0);

    var currentSection =
        sections.firstWhere((section) => identical(section, mockSection));

    expect(currentSection.composables.first, mockComposable);
  });

  testWidgets('remove row', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;
    var composable = state.mockComposable;

    state.removeRow(section: mockSection, composable: composable);

    var currentSection =
        sections.firstWhere((section) => identical(section, mockSection));
    expect(currentSection.composables.length, 0);
  });

  testWidgets('append section', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    mockSection = Section(mockComposable, [mockComposable]);

    state.appendSection(section: mockSection);

    expect(sections.length, 2);
  });

  testWidgets('append section to index', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    mockSection = Section(mockComposable, [mockComposable]);

    state.appendSection(section: mockSection, index: 0);

    expect(sections.first, mockSection);
  });

  testWidgets('remove section', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    state.removeSection(mockSection);

    expect(sections.length, 0);
  });

  testWidgets('validate false', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var viewModel = MockValidateableComposableViewModel("A very long text");
    var composable = MockValidateableComposable(viewModel, [MockValidator(5)]);

    state.appendRow(section: mockSection, composable: composable);

    await tester.pump();

    expect(state.validate(), false);
  });

  testWidgets('validate true', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var viewModel = MockValidateableComposableViewModel("true");
    var composable = MockValidateableComposable(viewModel, [MockValidator(5)]);

    state.appendRow(section: mockSection, composable: composable);

    await tester.pump();

    expect(state.validate(), true);
  });

  testWidgets('set viewmodel', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var viewModel = MockStatefulComposableViewModel("old");
    var composable = MockStatefulComposable(viewModel);

    state.appendRow(section: mockSection, composable: composable);

    var updatedViewModel = MockStatefulComposableViewModel("new");
    composable.componentModel = updatedViewModel;

    await tester.pump();

    expect(composable.componentModel.text, "new");
  });

  testWidgets('identical viewmodel', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);

    var viewModel = MockComposableViewModel("old");
    var composable = MockComposable(viewModel);

    expect(composable.componentModel, viewModel);
  });

  testWidgets('statelesswidget re-set viewModel error',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);

    var viewModel = MockComposableViewModel("old");
    var composable = MockComposable(viewModel);

    try {
      composable.componentModel = viewModel;
    } catch (e) {
      expect(e, isInstanceOf<StatelessActingException>());
    }
  });

  testWidgets('statelesswidget validate viewModel error',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);

    var viewModel = MockComposableViewModel("old");
    var composable = MockComposable(viewModel);

    try {
      composable.validate();
    } catch (e) {
      expect(e, isInstanceOf<StatelessActingException>());
    }
  });
}
