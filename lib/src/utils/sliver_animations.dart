import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

enum SliverAnimation { none, automatic }

class SliverAnimations {
  static Animation<double> height(AnimationController controller) {
    return Tween<double>(begin: 0, end: 40.0).animate(
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