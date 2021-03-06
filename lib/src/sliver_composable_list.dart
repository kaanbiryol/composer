import 'package:composer/src/sliver_rows.dart';
import 'package:composer/src/sliver_sections.dart';
import 'package:composer/src/utils/function_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../composer.dart';

class SliverListDataSource {
  List<Section> sectionList;
  SliverListDataSource(this.sectionList);
}

class SliverListNotifier extends FunctionNotifier<SliverListDataSource,
    RowActionEvent, RowActionCallback> {
  SliverListDataSource dataSource;
  SliverListNotifier(this.dataSource) : super(dataSource);
}

class SliverComposableList extends StatefulWidget {
  final SliverListNotifier controller;
  const SliverComposableList(this.controller, {Key key}) : super(key: key);

  @override
  _SliverComposableListState createState() => _SliverComposableListState();
}

class _SliverComposableListState extends State<SliverComposableList> {
  List<Section> get sections => widget.controller.dataSource.sectionList;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: makeComposables(),
    );
  }

  List<Widget> makeComposables() {
    List<Widget> widgets = [];
    if (sections == null) {
      return widgets;
    }
    for (var index = 0; index < sections.length; index++) {
      Section section = sections[index];
      assert(section != null, "Section cannot be null.");
      var headerSection = SliverSection(
        section: section,
      );
      widgets.add(headerSection);
      widgets
          .add(SliverRow(sectionIndex: index, controller: widget.controller));
    }
    return widgets;
  }
}
