import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

class KeyValueComponentViewModel {
  String key;
  String value;

  KeyValueComponentViewModel({this.key, this.value});
}

class KeyValueRowComponent<KeyValueComponentViewModel>
    extends ComposableStatelessWidget {
  KeyValueRowComponent({KeyValueComponentViewModel componentModel, Key key})
      : super(componentModel, key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: move to viewModel?
    var data = ThemeData(
        textTheme: TextTheme(body1: TextStyle(backgroundColor: Colors.red)));
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(componentModel.key, style: ThemeManager.theme().textTheme.body1),
          Text(componentModel.value),
        ]);
  }
}
