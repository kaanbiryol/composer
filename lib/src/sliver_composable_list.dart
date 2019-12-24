import 'dart:math' as math;
import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SliverComposableValue {
  List<Section> sectionList;
  SliverComposableValue(this.sectionList);
}

class SliverComposableListNotifier extends ValueNotifier<SliverComposableValue> {
  final SliverComposableValue sliverValue;
  SliverComposableListNotifier(this.sliverValue) : super(sliverValue);
}

class SliverComposableList extends StatefulWidget {
  final List<Section> sections;
  final SliverComposableListNotifier controller;

  const SliverComposableList(this.sections, this.controller, {Key key})
      : super(key: key);

  @override
  _SliverComposableListState createState() => _SliverComposableListState();
}

class _SliverComposableListState extends State<SliverComposableList> {
  final double sliverHeaderHeight = 40.0;

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
    for (final section in widget.sections) {
      var headerSection = makeSection(section);
      widgets.add(headerSection);
      widgets.add(SliverStateful(
        composables: section.composables,
        controller: widget.controller,
      ));
    }
    return widgets;
  }
}

class SliverStateful extends StatefulWidget {
  final List<Composable> composables;
  final SliverComposableListNotifier controller;
  const SliverStateful(
      {@required this.composables, @required this.controller, Key key})
      : super(key: key);

  @override
  _SliverStatefulState createState() => _SliverStatefulState();
}

class _SliverStatefulState extends State<SliverStateful> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  List<Composable> old = [];
  String oldString;

  @override
  void initState() {
    super.initState();
    // oldString = widget.controller.value;
    old.addAll(widget.controller.value.sectionList.first.composables);
    widget.controller.addListener(notifySectionChange);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
        key: _listKey,
        initialItemCount: widget.composables.length,
        itemBuilder: (context, index, animation) {
          return _AnimatedRow(
            child: widget.composables[index],
            animation: animation,
          );
        });
  }

  void notifySectionChange() {
    print(old.length.toString());
    print(widget.controller.value.sectionList.first.composables.length.toString());
    // List<Composable> composables =
    //     widget.controller.value.sectionList.first.composables;
    // print("CHANGE" +
    //     old.length.toString() +
    //     "- " +
    //     composables.length.toString());
    // if (composables.length > old.length) {
    //   appendRow(null, 1);
    //   // _oldComposables = widget.composables;
    // }

    // //  else if (composables.length < _oldComposables.length) {
    // //   removeRow(1);
    // //   _oldComposables = widget.composables;
    // // }
  }

  void appendRow(Composable composable, int index) {
    widget.composables.add(widget.composables[1]);
    _listKey.currentState.insertItem(index);
  }

  void removeRow(int index) {
    Composable composable = widget.composables[index];
    widget.composables.removeAt(index);
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
