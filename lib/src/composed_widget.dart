import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'composable.dart';
import 'composed_widget_traits.dart';

abstract class ComposedWidget extends StatefulWidget {}

abstract class ComposedWidgetState extends State<ComposedWidget>
    with ComposedWidgetTraits {
  List<Composable> _composedWidgets = [];
  List<Composable> _bottomWidgets = [];

  @override
  Widget build(BuildContext context) {
    _composedWidgets = prepareCompose(context);
    _bottomWidgets = prepareBottom(context);
    var traits = setupTraits();
    assert(traits != false, "must setupTraits()");
    assert(_composedWidgets != null, "prepareCompose must not return null");
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
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
              itemCount: _composedWidgets.length,
              itemBuilder: (context, index) {
                Composable component = _composedWidgets[index];
                return component;
              }),
        ),
        Container(
          color: Colors.red,
          child: _buildBottomComposables(),
        )
      ],
    );
  }

  Widget _buildBottomComposables() {
    switch (bottomComposableAxis) {
      case BottomComposableAxis.horizontal:
        return Row(children: _bottomWidgets);
      case BottomComposableAxis.vertical:
        return Column(
          children: _bottomWidgets,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
      default:
        return Column(children: _bottomWidgets);
    }
  }

  //TODO:
  bool setupTraits();
  List<Composable> prepareCompose(BuildContext context);
  List<Composable> prepareBottom(BuildContext context) => [];

  bool validate() {
    var validateableComposables = _composedWidgets
        .where((widget) => widget.validators.isNotEmpty)
        .toList();
    for (final composedWidget in validateableComposables) {
      if (composedWidget.validate() == false) {
        return false;
      }
    }
    return true;
  }

  Composable componentWith(Key key) {
    return _composedWidgets.firstWhere((component) => component.key == key);
  }
}
