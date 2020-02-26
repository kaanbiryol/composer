import 'dart:math';
import 'package:composer/src/utils/sliver_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../composer.dart';
import 'animated_composable.dart';

class SliverSection extends StatefulWidget {
  final Section section;

  const SliverSection({@required this.section, Key key}) : super(key: key);

  @override
  _SliverSectionState createState() => _SliverSectionState();
}

class _SliverSectionState extends State<SliverSection>
    with SingleTickerProviderStateMixin {
  final double _sliverHeaderHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    double determinedHeight = widget.section.height ?? _sliverHeaderHeight;
    return SliverPersistentHeader(
      pinned: widget.section.pinned,
      delegate: _SliverSectionDelegate(
        minHeight: determinedHeight,
        maxHeight: determinedHeight,
        child: widget.section.sectionComposable,
        animation: widget.section.animation,
      ),
    );
  }
}

class _SliverSectionDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final SliverAnimation animation;

  _SliverSectionDelegate(
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
  bool shouldRebuild(_SliverSectionDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
