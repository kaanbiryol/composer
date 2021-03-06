import 'package:composer/composer.dart';
import 'package:composer/src/sliver_composable_list.dart';
import 'package:composer/src/utils/exceptions.dart';
import 'package:composer/src/utils/sliver_animations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'compose_test_mocks.dart';

Widget get mockWidget => buildTestableWidget(MockPage());
MockPageState getState(WidgetTester tester) {
  return tester.state(find.byType(MockPage));
}

void main() {
  testWidgets('composedwidget: append row', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    state.appendRow(section: mockSection, composable: mockComposable);

    var currentSection =
        sections.firstWhere((section) => identical(section, mockSection));
    expect(currentSection.rows.length, 3);
  });

  testWidgets('composedwidget: append row to index',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable =
        MockComposable(MockComposableViewModel("Mock Text Index 0"));
    state.appendRow(section: mockSection, composable: mockComposable, index: 0);

    var currentSection =
        sections.firstWhere((section) => identical(section, mockSection));

    expect(currentSection.rows.first, mockComposable);
  });

  testWidgets('composedwidget: remove row', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;
    var composable = state.mockComposable;

    state.removeRow(section: mockSection, composable: composable);

    var currentSection =
        sections.firstWhere((section) => identical(section, mockSection));
    expect(currentSection.rows.length, 1);
  });

  testWidgets('composedwidget: append section', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    mockSection =
        Section(sectionComposable: mockComposable, rows: [mockComposable]);

    state.appendSection(section: mockSection);

    await tester.pumpAndSettle();

    expect(sections.length, 2);
  });

  testWidgets('composedwidget: append section to index',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    mockSection =
        Section(sectionComposable: mockComposable, rows: [mockComposable]);

    state.appendSection(section: mockSection, index: 0);

    expect(sections.first, mockSection);
  });

  testWidgets('composedwidget: remove section', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var sections = state.controller.dataSource.sectionList;
    var mockSection = state.mockSection;

    state.removeSection(mockSection);

    await tester.pumpAndSettle();

    expect(sections.length, 0);
  });

  testWidgets('validation: validate false', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var viewModel = MockValidateableComposableViewModel("A very long text");
    viewModel.validators = [MockCharacterLengthValidator(5)];
    var composable = MockValidateableComposable(viewModel);
    state.appendRow(section: mockSection, composable: composable);

    await tester.pump();

    expect(state.validate(), false);
  });

  testWidgets('validation: validate true', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var viewModel = MockValidateableComposableViewModel("true");
    var composable = MockValidateableComposable(viewModel);
    state.appendRow(section: mockSection, composable: composable);

    await tester.pump();

    expect(state.validate(), true);
  });

  testWidgets('statefulcomposable: validateable error',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);

    var viewModel = MockStatefulComposableViewModel("old");
    var composable = MockStatefulComposable(viewModel);

    try {
      composable.validate();
    } catch (e) {
      expect(e, isInstanceOf<NonValidateableStatefulWidget>());
    }
  });

  test('statefulcomposable: identical viewmodel', () async {
    var viewModel = MockComposableViewModel("old");
    var composable = MockComposable(viewModel);

    expect(composable.composableModel, viewModel);
  });

  test('statelesswidget: re-set viewModel error', () async {
    var viewModel = MockComposableViewModel("old");
    var composable = MockComposable(viewModel);

    try {
      composable.composableModel = viewModel;
    } catch (e) {
      expect(e, isInstanceOf<StatelessActingException>());
    }
  });

  test('function notifier: get value', () async {
    var value = SliverListDataSource([]);
    var controller = SliverListNotifier(value);
    expect(controller.value, value);
  });

  testWidgets('function notifier: set value', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var value = SliverListDataSource([]);
    var controller = SliverListNotifier(value);

    var mockComposable = MockComposable(MockComposableViewModel("Text"));

    var section =
        Section(sectionComposable: mockComposable, rows: [mockComposable]);

    var newValue = SliverListDataSource([section]);
    controller.value = newValue;

    expect(controller.value, newValue);
  });

  testWidgets('function notifier: notify after dispose error',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    try {
      state.controller.notifyListeners(null, null);
    } catch (e) {
      expect(e, isInstanceOf<EmptyFunctionNotifier>());
    }
  });

  testWidgets('function notifier: has listeners', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    expect(state.controller.hasListeners, true);
  });

  testWidgets('function notifier: dispose listeners',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    state.controller.dispose();
    expect(state.controller.hasListeners, false);
  });

  testWidgets('composedwidget: get composable with key',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var key = ValueKey("MockKey");
    var mockComposableViewModel = MockComposableViewModel("Mock Text");
    mockComposableViewModel.key = key;
    var mockComposable = MockComposable(mockComposableViewModel);
    state.appendRow(section: mockSection, composable: mockComposable);

    var composable = state.composableWith(key);
    var isIdentical = identical(composable, mockComposable);
    expect(isIdentical, true);
  });

  testWidgets('composedwidget: update composables list',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;

    var mockComposable =
        MockComposable(MockComposableViewModel("new composable"));
    mockSection =
        Section(sectionComposable: mockComposable, rows: [mockComposable]);
    var sectionList = [mockSection];
    state.composables = sectionList;

    await tester.pumpAndSettle();

    expect(state.composables, sectionList);
  });

  testWidgets('composedwidget: set topcomposable', (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);

    var mockComposable =
        MockComposable(MockComposableViewModel("new composable"));
    state.topComposables = [mockComposable];

    await tester.pump();

    expect(state.topComposables, [mockComposable]);
  });

  testWidgets('composedwidget: set bottom composable',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);

    var mockComposable =
        MockComposable(MockComposableViewModel("new composable"));
    state.bottomComposables = [mockComposable];

    await tester.pump();

    expect(state.bottomComposables, [mockComposable]);
  });

  testWidgets('composedwidget: add section animation',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);
    var mockSection = state.mockSection;
    var mockComposable = MockComposable(MockComposableViewModel("Mock Text"));
    mockSection =
        Section(sectionComposable: mockComposable, rows: [mockComposable]);

    state.appendSection(
        section: mockSection, animation: SliverAnimation.automatic);
    expect(mockSection.animation, SliverAnimation.automatic);
  });

  test('composer: assign widget validator', () {
    StatefulComposable composable = (ValidateableMockComposer()
          ..withValidators([MockCharacterLengthValidator(2)]))
        .compose();

    expect(composable.composableModel.validators.length, 1);
  });

  test('composer: assign widget key', () {
    ValueKey key = ValueKey(0);
    Composable composable = (StatelessMockComposer()..withKey(key)).compose();
    expect(composable.key, key);
  });

  testWidgets('statefulcomposable: update composablemodel',
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);

    String composableValue = "old value";
    state.statefulMockComposable.composableModel =
        MockStatefulComposableViewModel(composableValue);

    String updatedValue = "updated value";
    MockStatefulComposableViewModel updatedModel =
        MockStatefulComposableViewModel(updatedValue);
    state.statefulMockComposable.composableModel = updatedModel;

    expectSync(state.statefulMockComposable.composableModel, updatedModel);
  });

  testWidgets("composedwidget: remove section listener",
      (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);

    state.removeSection(state.mockSection);

    await tester.pumpAndSettle();
    expect(state.controller.hasListeners, false);
  });

  testWidgets("composedwidget: widget did appear", (WidgetTester tester) async {
    await tester.pumpWidget(mockWidget);
    var state = getState(tester);

    await tester.pumpAndSettle();
    expect(state.widgetAppeared, true);
  });
}
