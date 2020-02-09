import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../compose.dart';
import 'animated_composable.dart';

class SliverSection extends StatefulWidget {
  final Section section;

  const SliverSection({@required this.section, Key key}) : super(key: key);

  @override
  _SliverSectionState createState() => _SliverSectionState();
}

class _SliverSectionState extends State<SliverSection>
    with SingleTickerProviderStateMixin {
  final double sliverHeaderHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverSectionDelegate(
        minHeight: widget.section.height ?? sliverHeaderHeight,
        maxHeight: widget.section.height ?? sliverHeaderHeight,
        child: widget.section.sectionComposable,
        animation: widget.section.animation,
      ),
    );
  }
}

class SliverSectionDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final SliverAnimation animation;

  SliverSectionDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child,
      @required this.animation});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedComposable(
      child: child,
      animation: animation,
    );
  }

  @override
  bool shouldRebuild(SliverSectionDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
