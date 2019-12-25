import 'package:compose/src/sliver_composable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'composable.dart';
import 'composed_widget_traits.dart';

abstract class ComposedWidget extends StatefulWidget {}

abstract class ComposedWidgetState extends State<ComposedWidget>
    with ComposedWidgetTraits {
  List<Section> _composedWidgets = [];
  List<Composable> _bottomWidgets = [];
  //TODO:
  Composable headerView;
  SliverComposableListNotifier controller;

  @override
  Widget build(BuildContext context) {
    _composedWidgets = prepareCompose(context);
    _bottomWidgets = prepareBottom(context);
    var traits = setupTraits();
    assert(traits != false, "must setupTraits()");
    assert(_composedWidgets != null, "prepareCompose must not return null");
    var value = SliverComposableValue(_composedWidgets);
    controller = SliverComposableListNotifier(value);
    return SliverComposableList(controller);
  }

  //TODO: class or const
  Widget _buildBottomComposables() {
    switch (bottomComposableAxis) {
      case BottomComposableAxis.horizontal:
        return Row(children: _bottomWidgets);
      case BottomComposableAxis.vertical:
        return Column(
          children: _bottomWidgets,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
      default:
        return Column(children: _bottomWidgets);
    }
  }

  //TODO:
  bool setupTraits();
  List<Section> prepareCompose(BuildContext context);
  List<Composable> prepareBottom(BuildContext context) => [];

  bool validate() {
    var composables = getComposables();
    var validateableComposables =
        composables.where((widget) => widget.validators.isNotEmpty).toList();
    for (final composedWidget in validateableComposables) {
      if (composedWidget.validate() == false) {
        return false;
      }
    }
    return true;
  }

  List<Composable> getComposables() =>
      _composedWidgets.expand((section) => section.composables).toList();

  Composable componentWith(Key key) {
    return getComposables().firstWhere((component) => component.key == key);
  }

  void appendRow({@required Section section, @required Composable composable, int index}) {
    Section section = _composedWidgets[index];
    var rowIndex = index ?? section.composables.length;
    section.composables.add(composable);
    _composedWidgets[0] = section;
    controller.value = SliverComposableValue(_composedWidgets);
  }

}

extension ComposedWidgetBottom on Widget {
  Widget withBottomComposables(Widget bottomComposables) {
    return Column(
      children: <Widget>[
        Expanded(
          child: this,
        ),
        Container(
          color: Colors.yellow,
          child: bottomComposables,
        )
      ],
    );
  }

  Widget withTraits(Widget bottomComposables) {
    return Column(
      children: <Widget>[
        Expanded(
          child: this,
        ),
        Container(
          color: Colors.yellow,
          child: bottomComposables,
        )
      ],
    );
  }

  Widget withHeader(Widget header) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          color: Colors.black,
        ),
        this
      ],
    );
  }
}

extension WidgetPadding on Widget {
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);
}
