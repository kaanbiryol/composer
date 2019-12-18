import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class KeyValueComposable {
  String key;
  String value;
}

class KeyValueComposer extends Composer<KeyValueComponent>
    implements KeyValueComposable {
  @override
  String key;

  @override
  String value;

  void withKey(String key) {
    this.key = key;
  }

  void withValue(String value) {
    this.value = value;
  }

  @override
  KeyValueComponent compose() {
    var keyValueViewModel = KeyValueComponentViewModel(key: key, value: value);
    var keyValueComponent =
        KeyValueComponent(componentModel: keyValueViewModel);
    return keyValueComponent;
  }
}

class KeyValueComponentViewModel {
  String key;
  String value;

  KeyValueComponentViewModel({this.key, this.value});
}

class KeyValueComponent<KeyValueComponentViewModel>
    extends ComposableStatelessWidget {
  KeyValueComponent({KeyValueComponentViewModel componentModel, Key key})
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
