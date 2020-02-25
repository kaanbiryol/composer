import 'package:compose/src/animated_composable.dart';
import 'package:compose/src/sliver_composable_list.dart';
import 'package:compose/src/utils/sliver_animations.dart';
import 'package:compose/src/utils/widget_state_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../compose.dart';

typedef RowActionCallback = void Function(RowActionEvent);

enum RowAction { add, remove }

class RowActionEvent {
  int desiredIndex;
  Composable composable;
  RowAction action;

  RowActionEvent(
      {@required this.action, @required this.composable, this.desiredIndex});
}

class SliverRow extends StatefulWidget {
  final int sectionIndex;
  final SliverListNotifier controller;
  const SliverRow(
      {@required this.sectionIndex, @required this.controller, Key key})
      : super(key: key);

  @override
  _SliverRowState createState() => _SliverRowState();
}

class _SliverRowState extends State<SliverRow> with WidgetStateListener {
  GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  int get _sectionIndex => widget.sectionIndex;
  Section get _section =>
      widget.controller.dataSource.sectionList[_sectionIndex];
  List<Composable> get _composables => _section.composables;

  @override
  void initState() {
    super.initState();
    widget.controller
        .addListener(section: _section, listener: notifySectionChange);
  }

  @override
  Widget build(BuildContext context) {
    _listKey = GlobalKey<SliverAnimatedListState>();
    return SliverAnimatedList(
        key: _listKey,
        initialItemCount: _composables.length,
        itemBuilder: (context, index, animation) {
          var customAnimation = _section.animation;
          switch (customAnimation) {
            case SliverAnimation.none:
              return AnimatedRow(
                  child: _composables[index], animation: animation);
            default:
              return AnimatedComposable(
                animation: customAnimation,
                child: _composables[index],
              );
          }
        });
  }

  void notifySectionChange(RowActionEvent event) {
    int rowIndex = event.desiredIndex;
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
  void widgetDidAppear(BuildContext context) {
    _section.animation = SliverAnimation.none;
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
