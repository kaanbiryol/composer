import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

enum SliverAnimation { none, automatic }

class SliverAnimations {
  //TODO: give height as a parameter
  static Animation<double> height(AnimationController controller) {
    return Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutSine),
    );
  }

  static Animation<double> opacity(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutSine),
    );
  }
}
