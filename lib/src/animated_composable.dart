import 'package:compose/src/utils/sliver_animations.dart';
import 'package:flutter/widgets.dart';
import '../compose.dart';

class AnimatedComposable extends StatefulWidget {
  final Composable child;
  final SliverAnimation animation;
  AnimatedComposable({@required this.child, @required this.animation, Key key})
      : super(key: key);

  @override
  _AnimatedComposableState createState() => _AnimatedComposableState();
}

class _AnimatedComposableState extends State<AnimatedComposable>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final Duration animationDuration = Duration(milliseconds: 380);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: animationDuration, lowerBound: 0, upperBound: 1);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animation) {
      case SliverAnimation.none:
        return widget.child;
      default:
        return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return _buildAnimation(context, widget.child);
            });
    }
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    var opacity = SliverAnimations.opacity(_animationController);
    return Opacity(
      opacity: opacity.value,
      child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(), child: child),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
