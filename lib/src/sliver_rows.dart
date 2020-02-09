import 'package:compose/src/sliver_composable_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../compose.dart';
import 'animated_composable.dart';

typedef RowActionCallback = void Function(RowActionEvent);

enum RowAction { add, remove }

class RowActionEvent {
  int index;
  Composable composable;
  RowAction action;

  RowActionEvent(
      {@required this.action, @required this.composable, this.index});
}

class SliverRow extends StatefulWidget {
  final int index;
  final SliverListNotifier controller;
  const SliverRow({@required this.index, @required this.controller, Key key})
      : super(key: key);

  @override
  _SliverRowState createState() => _SliverRowState();
}

class _SliverRowState extends State<SliverRow> {
  GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  int get _index => widget.index;
  List<Composable> get _composables =>
      widget.controller.dataSource.sectionList[_index].composables;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(notifySectionChange);
  }

  @override
  Widget build(BuildContext context) {
    _listKey = GlobalKey<SliverAnimatedListState>();
    //TODO: handle anim
    return SliverAnimatedList(
        key: _listKey,
        initialItemCount: _composables.length,
        itemBuilder: (context, index, animation) {
          return AnimatedRow(
            animation: animation,
            child: _composables[index],
          );
        });
  }

  void notifySectionChange(RowActionEvent event) {
    int rowIndex = event.index;
    assert(rowIndex >= 0 && rowIndex <= _composables.length,
        "You are trying to remove an non-existing Widget.");
    switch (event.action) {
      case RowAction.add:
        _appendRow(event.composable, rowIndex);
        break;
      case RowAction.remove:
        _removeRow(rowIndex);
        break;
    }
  }

  void _appendRow(Composable composable, int index) {
    _composables.insert(index, composable);
    _listKey.currentState.insertItem(index);
  }

  void _removeRow(int index) {
    Composable composable = _composables[index];
    _composables.removeAt(index);
    _listKey.currentState.removeItem(index, (index, animation) {
      return SizeTransition(
          axis: Axis.vertical, sizeFactor: animation, child: composable);
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class AnimatedRow extends StatelessWidget {
  final Animation animation;
  final Widget child;

  const AnimatedRow({@required this.child, @required this.animation, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: child,
    );
  }
}
