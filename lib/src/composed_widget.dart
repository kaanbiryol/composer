import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'composable.dart';
import 'composed_widget_traits.dart';

abstract class ComposedWidget extends StatefulWidget {}

abstract class ComposedWidgetState extends State<ComposedWidget>
    with ComposedWidgetTraits {
  //TODO: prepareCompose
  List<Composable> _composedWidgets = [];

  @override
  Widget build(BuildContext context) {
    var components = prepareCompose(context);
    var traits = setupTraits();
    assert(traits != false, "must setupTraits()");
    assert(components != null, "prepareCompose must not return null");
    return ListView.separated(
        separatorBuilder: (context, index) {
          if (seperatorStyle == SeperatorStyle.none) {
            return Divider(
              height: 0,
              thickness: 0.01,
              color: Colors.transparent,
            );
          }
          return Divider(height: 2);
        },
        itemCount: components.length,
        itemBuilder: (context, index) {
          Composable component = components[index];
          return component;
        });
  }

  //TODO:
  bool setupTraits();
  List<Composable> prepareCompose(BuildContext context);
}
