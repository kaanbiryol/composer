import 'package:compose/src/sliver_composable_list.dart';
import 'package:compose/src/sliver_rows.dart';
import 'package:compose/src/utils/composed_widget_traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'animated_composable.dart';
import 'composable.dart';

abstract class ComposedWidget extends StatefulWidget {}

abstract class ComposedWidgetState extends State<ComposedWidget>
    with ComposedWidgetTraits {
  List<Section> _composables = [];
  List<Composable> _bottomComposables;
  List<Composable> _topComposables;
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
        .withBottom(_bottomComposables)
        .withTop(_topComposables);
  }

  List<Section> prepareCompose(BuildContext context);

  bool validate() {
    var composableList = allComposables();
    var validateableComposables =
        composableList.where((widget) => widget.validators.isNotEmpty).toList();

    /*return validateableComposables.fold(
        true, (result, type) => result = type.validate());*/

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

  void appendSection(
      {@required Section section, int index, SliverAnimation animation}) {
    section.animation = animation;
    if (index != null) {
      assert(index >= 0 && index < _composables.length,
          "If you are providing an index, it must be less than the current item size, otherwise just ignore index.");
      _composables.insert(index, section);
    } else {
      _composables.add(section);
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
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  set bottomComposables(List<Composable> composables) {
    _bottomComposables = composables;
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  set topComposables(List<Composable> composables) {
    _topComposables = composables;
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  get topComposables => _topComposables;
  get bottomComposables => _bottomComposables;
  get composables => _composables;

  @mustCallSuper
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

extension ComposedWidgetBottom on Widget {
  Widget withBottom(List<Composable> bottom) {
    if (bottom == null) {
      return this;
    }
    var bottomComposables = bottom.where((x) => x != null).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: this,
        ),
        Column(
          children: bottomComposables,
        ),
      ],
    );
  }

  Widget withTop(List<Composable> top) {
    if (top == null) {
      return this;
    }
    var topComposables = top.where((x) => x != null).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          children: topComposables,
        ),
        Expanded(
          child: this,
        ),
      ],
    );
  }
}
