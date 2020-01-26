
# compose
[![Build Status](https://travis-ci.com/kaanbiryol/compose.svg?token=xws52V8r1gzMpJMj8tiG&branch=master)](https://travis-ci.com/kaanbiryol/compose)
[![codecov](https://codecov.io/gh/kaanbiryol/compose/branch/master/graph/badge.svg?token=cBtY4b5VfY)](https://codecov.io/gh/kaanbiryol/compose)
 
**Compose** is a Flutter library for building component-based form like user interfaces.

It simply uses a [SliverList](https://api.flutter.dev/flutter/widgets/SliverList-class.html) with sections and rows similar to [UITableView](https://developer.apple.com/documentation/uikit/uitableview) in iOS.

## Usage
**Compose** uses `Composable`'s in order to build your UI. Just like everything in Flutter they are simply Widgets. 

**Stateful and Stateless Composables**

Like there is a `StatelessWidget` and a `StatefulWidget` there are  `StatelessComposable` and `StatefulComposable`. To build a `Composable` you need a `ComposableModel` which is basically a ViewModel for our Widget.

```dart
class ExampleStatelessComposableModel {
  String value;
  ExampleStatelessComposableModel({this.value});
}

class ExampleStatelessComposable<ExampleStatelessComposableModel>
    extends ComposableStatelessWidget {
  ExampleStatelessComposable({ExampleStatelessComposableModel composableModel, Key key})
      : super(componentModel, key: key);

  @override
  Widget build(BuildContext context) {
    return Text(composableModel.value);
  }
```
**ComposedWidget**

To use a `Composable` you need to create a `ComposedWidget` which is a `StatefulWidget` itself. There are two ways you can build `Composable`'s. Either use `prepareCompose()` method or just set `composables` array. `ComposedWidgets` are formed from `Section`'s (also a `Composable`) and `Section`'s are formed from Rows (yep, a `Composable`).

```dart
class ExamplePage extends ComposedWidget {
  @override
  State<StatefulWidget> createState() {
    return ExamplePageState();
  }
}

class ExamplePageState extends ComposedWidgetState {
  @override
    // or you can override build() and just set composables = [] whenever you want
  List<Section> prepareCompose(BuildContext context) {
    var exampleComposable = ExampleComposable("My first Composable");     
    var exampleSection = (SectionComposer()..withTitle("Section Title")).compose();
    exampleSection = Section(firstSectionWidget, [button]);
    return [exampleSection];
  }
}
```
**Composable Validation**

Unlike `StatelessComposable`'s `StatefulComposable`'s can be validated. In order to validate a `StatefulComposable` its corresponding `ComposableModel` has to implement `ViewModelValidateable`.

```dart
class ExampleStatefulComposableModel implements ViewModelValidateable {
  ExampleStatefulComposableModel();

  @override
  bool validate(List<Validator> validators) {
	// Your custom implementation for a list of validators.
  }
}
```
And in `StatefulComposable`'s we use the `validateable` constructor with a `GlobalKey`.
```dart
super.validateable(composableModel, validators, GlobalKey<_State>());
```
**Setting state of Composables**

To modify the state of your `StatefulComposable`  just re-set its `ComposableModel`.
```dart
exampleComposable.composableModel = newViewModel;
```
**Adding or removing Composables**

If you would like to edit `Sections` or `Rows` inside your `ComposedWidget` there are two things you can do. First is simply re-setting the whole composables array. or you can use helper methods such as; 

```dart
void appendRow({@required Section section, @required Composable composable, int index});
void removeRow({@required Section section, @required Composable composable});
void appendSection({@required Section section, int index});
void removeSection(Section section);
```
