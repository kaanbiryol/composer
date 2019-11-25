import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

class KeyValueComponentViewModel {
  String key;
  String value;

  KeyValueComponentViewModel({this.key, this.value});
}

class KeyValueRowComponent<KeyValueComponentViewModel>
    extends ComposableStatelessWidget {
  KeyValueRowComponent({this.viewModel, Key key}) : super(key: key);
  @override
  final ComponentModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(viewModel.value.key),
          Text(viewModel.value.value),
        ]);
  }
}
