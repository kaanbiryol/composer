import 'package:compose/compose.dart';
import 'package:flutter/material.dart';

abstract class KeyValueModelable implements ComposableModel {
  String keyValue;
  String value;
}

class KeyValueComposer extends Composer<KeyValueComposable>
    implements KeyValueModelable {
  String keyValue;
  String value;

  void withKeyValue(String key) {
    this.keyValue = key;
  }

  void withValue(String value) {
    this.value = value;
  }

  @override
  KeyValueComposable compose() {
    var composableModel =
        KeyValueComposableModel(keyValue: keyValue, value: value);
    //TODO: find a better way
    composableModel.key = key;
    var keyValueComponent = KeyValueComposable(composableModel);
    return keyValueComponent;
  }

  @override
  ThemeData themeData;
}

class KeyValueComposableModel implements KeyValueModelable {
  String keyValue;
  String value;
  KeyValueComposableModel({this.keyValue, this.value});

  @override
  Key key;

  @override
  ThemeData themeData;
}

class KeyValueComposable extends StatelessComposable<KeyValueModelable> {
  KeyValueComposable(KeyValueModelable composableModel)
      : super(composableModel);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(composableModel.keyValue,
              style: composableModel.themeData.textTheme.body1),
          Text(composableModel.value),
        ]);
  }
}