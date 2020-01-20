import 'package:compose/src/sliver_composable_list.dart';
import 'package:compose/src/sliver_rows.dart';
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
  SliverListNotifier controller;

  @override
  Widget build(BuildContext context) {
    if (_composedWidgets.isEmpty) _composedWidgets = prepareCompose(context);
    _bottomWidgets = prepareBottom(context);
    var traits = setupTraits();
    assert(traits != false, "must setupTraits()");
    assert(_composedWidgets != null, "prepareCompose must not return null");
    var value = SliverListDataSource(_composedWidgets);
    controller = SliverListNotifier(value);
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

  void appendRow(
      {@required Section section, @required Composable composable, int index}) {
    var rowIndex = index ?? section.composables.length;
    controller.notifyListeners(RowActionEvent(
        action: RowAction.add, composable: composable, index: rowIndex));
  }

  void removeRow({@required Section section, @required Composable composable}) {
    int rowIndex =
        section.composables.indexWhere((item) => identical(item, composable));
    controller.notifyListeners(RowActionEvent(
        action: RowAction.remove, composable: composable, index: rowIndex));
  }

  void appendSection({@required Section section, int index}) {
    if (index != null) {
      assert(index >= 0 && index < _composedWidgets.length,
          "If you are providing an index, it must be less than the current item size, otherwise just ignore index.");
      _composedWidgets.insert(index, section);
    } else {
      _composedWidgets..add(section);
    }
    setState(() {});
  }

  void removeSection(Section section) {
    var sectionIndex =
        _composedWidgets.indexWhere((item) => identical(item, section));
    _composedWidgets.removeAt(sectionIndex);
    setState(() {});
  }

  List<Composable> getComposables() =>
      _composedWidgets.expand((section) => section.composables).toList();

  Composable componentWith(Key key) {
    return getComposables().firstWhere((component) => component.key == key);
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
