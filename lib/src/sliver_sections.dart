import 'dart:math';
import 'package:flutter/widgets.dart';

import '../compose.dart';

class SliverSection extends StatelessWidget {
  final Section section;
  final double sliverHeaderHeight = 40.0;
  const SliverSection({@required this.section, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: section.pinned,
      delegate: SliverSectionDelegate(
        minHeight: section.height ?? sliverHeaderHeight,
        maxHeight: section.height ?? sliverHeaderHeight,
        child: section.section,
      ),
    );
  }
}

class SliverSectionDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverSectionDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverSectionDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
