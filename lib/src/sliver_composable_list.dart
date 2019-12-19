import 'dart:math' as math;
import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SliverComposableList extends StatelessWidget {
  final double sliverHeaderHeight = 40.0;
  final List<Section> sections;

  const SliverComposableList(this.sections, {Key key}) : super(key: key);

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
    for (final section in sections) {
      var headerSection = makeSection(section);
      widgets.add(headerSection);
      var sliverList =
          SliverList(delegate: SliverChildListDelegate(section.composables));
      widgets.add(sliverList);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: makeComposables(),
    );
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
