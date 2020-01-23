import 'package:compose/src/sliver_composable_list.dart';
import 'package:compose/src/sliver_rows.dart';
import 'package:compose/src/utils/composed_widget_traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'composable.dart';

abstract class ComposedWidget extends StatefulWidget {}

abstract class ComposedWidgetState extends State<ComposedWidget>
    with ComposedWidgetTraits {
  List<Section> _composables = [];
  Composable _bottomComposable;
  Composable _topComposable;
  SliverListNotifier controller;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    _composables = prepareCompose(context);
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    var value = SliverListDataSource(_composables);
    controller = SliverListNotifier(value);
    return SliverComposableList(controller)
        .withBottom(_bottomComposable)
        .withTop(_topComposable);
  }

  List<Section> prepareCompose(BuildContext context);

  bool validate() {
    var composableList = allComposables();
    var validateableComposables =
        composableList.where((widget) => widget.validators.isNotEmpty).toList();
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
      assert(index >= 0 && index < _composables.length,
          "If you are providing an index, it must be less than the current item size, otherwise just ignore index.");
      _composables.insert(index, section);
    } else {
      _composables..add(section);
    }
    setState(() {});
  }

  void removeSection(Section section) {
    var sectionIndex =
        _composables.indexWhere((item) => identical(item, section));
    _composables.removeAt(sectionIndex);
    setState(() {});
  }

  List<Composable> allComposables() =>
      _composables.expand((section) => section.composables).toList();

  Composable composableWith(Key key) {
    return allComposables().firstWhere((composable) => composable.key == key);
  }

  set composables(List<Section> composables) {
    _composables = composables;
    setState(() {});
  }

  set bottomComposable(Composable composable) {
    _bottomComposable = composable;
    setState(() {});
  }

  set topComposable(Composable composable) {
    _topComposable = composable;
    setState(() {});
  }

  @mustCallSuper
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

extension ComposedWidgetBottom on Widget {
  Widget withBottom(Composable bottom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: this,
        ),
        Container(
          child: bottom,
        )
      ],
    );
  }

  Widget withTop(Composable top) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          child: top,
        ),
        Expanded(
          child: this,
        ),
      ],
    );
  }
}
