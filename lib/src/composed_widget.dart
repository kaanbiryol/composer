import 'package:compose/src/sliver_composable_list.dart';
import 'package:compose/src/sliver_rows.dart';
import 'package:compose/src/stateful_composable.dart';
import 'package:compose/src/utils/composed_widget_traits.dart';
import 'package:compose/src/utils/sliver_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'composable.dart';

abstract class ComposedWidget extends StatefulWidget {}

abstract class ComposedWidgetState extends State<ComposedWidget>
    with ComposedWidgetTraits {
  List<Section> _composables = [];
  List<Composable> _bottomComposables;
  List<Composable> _topComposables;
  final SliverListNotifier controller =
      SliverListNotifier(SliverListDataSource([]));

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    _composables = prepareCompose(context);
    controller.dataSource = SliverListDataSource(_composables);
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return SliverComposableList(controller)
        .withBottom(_bottomComposables)
        .withTop(_topComposables);
  }

  List<Section> prepareCompose(BuildContext context);

  bool validate() {
    List<Composable> composableList = allComposables();
    List<Composable<ComposableModel>> statefulComposables = composableList
        .where((widget) =>
            widget is StatefulComposable && widget.validators.isNotEmpty)
        .toList();
    var validateableComposables =
        List<StatefulComposable>.from(statefulComposables);
    return validateableComposables.fold(
        true, (result, type) => result = type.validate());
  }

  void appendRow(
      {@required Section section, @required Composable composable, int index}) {
    int rowIndex = index ?? section.composables.length;
    controller.notifyListeners(
        section,
        RowActionEvent(
            action: RowAction.add,
            composable: composable,
            desiredIndex: rowIndex));
  }

  void removeRow({@required Section section, @required Composable composable}) {
    int rowIndex =
        section.composables.indexWhere((item) => identical(item, composable));
    controller.notifyListeners(
        section,
        RowActionEvent(
            action: RowAction.remove,
            composable: composable,
            desiredIndex: rowIndex));
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
    setState(() {
      controller.removeListener(section: section);
    });
  }

  List<Composable> allComposables() =>
      _composables.expand((section) => section.composables).toList();

  Composable composableWith(Key key) {
    return allComposables().firstWhere((composable) => composable.key == key);
  }

  set composables(List<Section> composables) {
    _composables = composables;
    controller.dataSource = SliverListDataSource(_composables);
    setState(() {});
  }

  set bottomComposables(List<Composable> composables) {
    _bottomComposables = composables;
    setState(() {});
  }

  set topComposables(List<Composable> composables) {
    _topComposables = composables;
    setState(() {});
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
    List<Composable> bottomComposables =
        bottom.where((x) => x != null).toList();
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
    List<Composable> topComposables = top.where((x) => x != null).toList();
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
