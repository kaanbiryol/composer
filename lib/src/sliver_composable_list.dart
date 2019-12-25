import 'dart:math' as math;
import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SliverComposableValue {
  List<Section> sectionList;
  SliverComposableValue(this.sectionList);
}

class SliverComposableListNotifier
    extends ValueNotifier<SliverComposableValue> {
  final SliverComposableValue sliverValue;
  SliverComposableListNotifier(this.sliverValue) : super(sliverValue);
}

class SliverComposableList extends StatefulWidget {
  final SliverComposableListNotifier controller;

  const SliverComposableList(this.controller, {Key key}) : super(key: key);

  @override
  _SliverComposableListState createState() => _SliverComposableListState();
}

class _SliverComposableListState extends State<SliverComposableList> {
  final double sliverHeaderHeight = 40.0;

  List<Section> get sections => widget.controller.sliverValue.sectionList;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: makeComposables(),
    );
  }

  SliverPersistentHeader makeSection(Section section) {
    return SliverPersistentHeader(
      pinned: section.pinned,
      delegate: _SliverSectionDelegate(
        minHeight: section.height ?? sliverHeaderHeight,
        maxHeight: section.height ?? sliverHeaderHeight,
        child: section.section,
      ),
    );
  }

  List<Widget> makeComposables() {
    List<Widget> widgets = [];
    for (var index = 0; index < sections.length; index++) {
      Section section = sections[index];
      var headerSection = makeSection(section);
      widgets.add(headerSection);
      widgets.add(SliverStateful(
        index: index,
        controller: widget.controller,
      ));
    }
    return widgets;
  }
}

class SliverStateful extends StatefulWidget {
  final int index;
  final SliverComposableListNotifier controller;
  const SliverStateful(
      {@required this.index, @required this.controller, Key key})
      : super(key: key);

  @override
  _SliverStatefulState createState() => _SliverStatefulState();
}

class _SliverStatefulState extends State<SliverStateful> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  List<Composable> _currentComposables = [];
  int get _index => widget.index;
  List<Composable> get _composables =>
      widget.controller.sliverValue.sectionList[_index].composables;

  @override
  void initState() {
    super.initState();
    _currentComposables.addAll(_composables);
    widget.controller.addListener(notifySectionChange);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
        key: _listKey,
        initialItemCount: _composables.length,
        itemBuilder: (context, index, animation) {
          return _AnimatedRow(
            child: _composables[index],
            animation: animation,
          );
        });
  }

  void notifySectionChange() {
    if (_composables.length > _currentComposables.length) {
      _appendRow(null, 1);
    } else if (_composables.length < _currentComposables.length) {
      _removeRow(1);
    }
    _currentComposables.clear();
    _currentComposables.addAll(_composables);
  }

  void _appendRow(Composable composable, int index) {
    _listKey.currentState.insertItem(index);
  }

  void _removeRow(int index) {
    Composable composable = _composables[index];
    SliverAnimatedList.of(context).removeItem(index, (index, animation) {
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

class _SliverSectionDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverSectionDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverSectionDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _AnimatedRow extends StatelessWidget {
  final Animation animation;
  final Widget child;

  const _AnimatedRow({@required this.child, @required this.animation, Key key})
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
