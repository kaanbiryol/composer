import 'package:compose/compose.dart';
import 'package:flutter/widgets.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  final List<Component> components = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: components.length,
        itemBuilder: (context, index) {
          var component = components[index];
          return component.build(context);
        });
  }

  void compose();
}
